import 'package:audio_service/audio_service.dart';
import 'package:flatter/player_related/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player_related/audio_player.dart';
import 'package:flatter/storage/local_not_database_storage_controller.dart';
import 'package:just_audio/just_audio.dart';

import '../useful_scripts.dart';

class PlayerControls extends BaseAudioHandler with QueueHandler, SeekHandler {
  final QueueRepository _queueRepository = QueueRepository();
  final _player = MyPlayer();
  final localNotDatabaseStorageController = LocalNotDatabaseStorageController();
  Stream<PlayerState> get playerState => _player.playerStateStream;
  Stream<List<MediaItem>> get queueStream => _queueRepository.queueStream;

  PlayerControls() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    playerState.listen((data) async {
      if (data.processingState == ProcessingState.completed) {
        if (_queueRepository.getCurrentIndex() == _queueRepository.getQueueLength() - 1) {
          stop();
        }
        skipToNext();
      }
    });
    
    if (settingsControl.loadSetting('persistentQueue') == true) {
      print('getting queue');
      customAction('loadPersistentQueue');
    }
  }

  final SubsonicJustAudioCompatibility usefulScript = SubsonicJustAudioCompatibility();

  //play controls
  @override
  Future<void> play() async {
    _player.play();
    localNotDatabaseStorageController.saveQueue();
  }
  @override
  Future<void> pause() async {
    _player.pause();
  }
  @override
  Future<void> stop() async {//TODO:hier player clearen oder so idk
    _player.stop();

    return;
  }
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> skipToNext() async {
    if (_queueRepository.getCurrentIndex() != _queueRepository.getQueueLength() - 1) {
      skipToQueueItem(_queueRepository.getCurrentIndex() + 1);
    }
    localNotDatabaseStorageController.saveQueue();
  }
  @override
  Future<void> skipToPrevious() async {
    if (_queueRepository.getCurrentIndex() != 0) {//vlt hier machen, dass es funktioniert wenn man ein looping angeschaltet hat
      if (getPosition().inSeconds < settingsControl.loadSetting('timeUntilSeekToStart')) {
        skipToQueueItem(_queueRepository.getCurrentIndex() - 1);
      } else {
        seek(Duration.zero);
      }

    }
    localNotDatabaseStorageController.saveQueue();
  }
  @override
  Future<void> skipToQueueItem(int index) async {
    print("skip to queue item");
    MediaItem item = _queueRepository.getItemAtPos(index);
    _queueRepository.makeCurrent(index);
    _player.seek(Duration.zero);
    _player.setSource(item.id);
    mediaItem.add(item);
    play();
    localNotDatabaseStorageController.saveQueue();
  }
  /*
  @override
  Future<void> setRepeatMode(//) =>
  @override
  Future<void> setShuffleMode(//) =>
   */

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    _queueRepository.clearQueue();
    _queueRepository.addItem(mediaItem);
    return;
  }
  @override
  Future<dynamic> customAction(String name,[Map<String,dynamic>? extras]) async {
    if (name case 'getQueue') {
      return _queueRepository.getQueue();
    } else if (name case 'clearQueue') {
      _queueRepository.clearQueue();
      stop();
      localNotDatabaseStorageController.saveQueue();
      return;
    } else if (name case 'getCurrentIndex') {
      return _queueRepository.getCurrentIndex();
    } else if (name case 'addNext') {
      if (extras != null) {
        int currentIndex = _queueRepository.getCurrentIndex();
        List<MediaItem> mediaItemList = extras['addNext']['tracks'];
        bool? shuffled = extras['addNext']['shuffled'];
        if (shuffled == true) mediaItemList.shuffle();
        for (MediaItem item in mediaItemList.reversed) {
          insertQueueItem(currentIndex + 1, item,true);
        }
      }
    } else if (name case 'addMultiple') {
      if (extras != null) {
        List<MediaItem> mediaItemList = extras['addMultiple']['tracks'];
        bool? shuffled = extras['addMultiple']['shuffled'];
        if (shuffled == true) mediaItemList.shuffle();
        for (MediaItem item in mediaItemList) {
          addQueueItem(item,true);
        }
      }
    } else if (name case 'moveQueueItem') {
      if (extras != null) {
        int oldIndex = extras['moveQueueItem']['oldIndex'];
        int newIndex = extras['moveQueueItem']['newIndex'];
        MediaItem item = _queueRepository.getItemAtPos(oldIndex);
        removeQueueItemAt(oldIndex);
        insertQueueItem(newIndex, item);
      }
    } else if (name case 'shuffleQueue') {
      _queueRepository.shuffleQueue();
      localNotDatabaseStorageController.saveQueue();
    } else if (name case 'addByID') {
      if (extras != null) {
        String? songID = extras['addByID']['songID'];//should not be used, i should use full song items
        String? albumID = extras['addByID']['albumID'];
        String? playlistID = extras['addByID']['playlistID'];
        String? artistID = extras['addByID']['artistID'];
        bool? shuffled = extras['addByID']['shuffled'];
        if (songID != null) {
          //hier song details halt bekommen
          Map<dynamic,dynamic> details = await subsonicService.getSongDetails(songID);
          MediaItem mediaItem = usefulScript.subsonicSongToMediaItem(details['song']);
          customAction('addMultiple',{'addMultiple':{'tracks':[mediaItem],'shuffled':shuffled}});
        }
        if (albumID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getAlbumDetails(albumID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['song']);
          if (shuffled == true) mediaItemList.shuffle();
          customAction('addMultiple',{'addMultiple':{'tracks':mediaItemList,'shuffled':shuffled}});
        }
        if (playlistID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getPlaylistDetails(playlistID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['entry']);
          if (shuffled == true) mediaItemList.shuffle();
          customAction('addMultiple',{'addMultiple':{'tracks':mediaItemList,'shuffled':shuffled}});
        }
        if (artistID != null) {
          //hier halt alle songs bekommen, probably durch full search einfach
          //shuffle nd vergessen
          Map<dynamic,dynamic> artistDetails = await subsonicService.getArtistDetails(artistID);
          String artistName = artistDetails['name'];
          Map<dynamic,dynamic> fullSearch = await subsonicService.fullSearch(artistName);
          print(fullSearch);
          print("THIS WAS FULL SEARCH");
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(fullSearch['song']);
          customAction('addMultiple',{'addMultiple':{'tracks':mediaItemList,'shuffled':shuffled}});
        }
      }
    } else if (name case 'addNextByID') {
      if (extras != null) {
        String? songID = extras['addNextByID']['songID'];//should not be used, i should use full song items
        String? albumID = extras['addNextByID']['albumID'];
        String? playlistID = extras['addNextByID']['playlistID'];
        String? artistID = extras['addNextByID']['artistID'];
        bool? shuffled = extras['addNextByID']['shuffled'];
        if (songID != null) {
          //hier song details halt bekommen
          Map<dynamic,dynamic> details = await subsonicService.getSongDetails(songID);
          MediaItem mediaItem = usefulScript.subsonicSongToMediaItem(details['song']);
          customAction('addNext',{'addNext':{'tracks':[mediaItem],'shuffled':shuffled}});
        }
        if (albumID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getAlbumDetails(albumID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['song']);
          if (shuffled == true) mediaItemList.shuffle();
          customAction('addNext',{'addNext':{'tracks':mediaItemList,'shuffled':shuffled}});
        }
        if (playlistID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getPlaylistDetails(playlistID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['entry']);
          if (shuffled == true) mediaItemList.shuffle();
          customAction('addNext',{'addNext':{'tracks':mediaItemList,'shuffled':shuffled}});
        }
        if (artistID != null) {
          //hier halt alle songs bekommen, probably durch full search einfach
          //shuffle nd vergessen
          Map<dynamic,dynamic> artistDetails = await subsonicService.getArtistDetails(artistID);
          String artistName = artistDetails['name'];
          Map<dynamic,dynamic> fullSearch = await subsonicService.fullSearch(artistName);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(fullSearch['song']);
          customAction('addNext',{'addNext':{'tracks':mediaItemList,'shuffled':shuffled}});
        }
      }
    } else if (name case 'getCurrentItem') {
      return _queueRepository.getItemAtPos(_queueRepository.getCurrentIndex());
    } else if (name case 'replaceQueue') {
      if (extras?['queue'] != null) {
        if (extras?['queue'].runtimeType == List<MediaItem>) {
          _queueRepository.replaceQueue(extras!['queue']);
        }
      }
    } else if (name case 'loadPersistentQueue') {
      List<MediaItem> persistentQueue = await localNotDatabaseStorageController.loadQueue();
      await customAction('replaceQueue',{'queue':persistentQueue});
      skipToQueueItem(_queueRepository.getCurrentIndex());
      pause();
    }
  }
  //queue controls
  @override
  Future<void> addQueueItem(MediaItem mediaItem, [bool? dontSave]) async {
    _queueRepository.addItem(mediaItem);
    if (_queueRepository.getQueueLength() == 1) skipToQueueItem(0);
    if (dontSave != true) {
      localNotDatabaseStorageController.saveQueue();
    }
    return;
  }
  @override
  Future<void> insertQueueItem(int index,MediaItem mediaItem, [bool? dontSave]) async {
    _queueRepository.insertItem(mediaItem, index);
    if (_queueRepository.getQueueLength() == 1) skipToQueueItem(0);
    if (dontSave != true) {
      localNotDatabaseStorageController.saveQueue();
    }
  }
  @override
  Future<void> removeQueueItemAt(int index) async {
    _queueRepository.removeItem(index);
    localNotDatabaseStorageController.saveQueue();
    return;
  }


  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playerState.playing) MediaControl.pause else MediaControl.play,//TODO:decide what to show in media noticiation
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.playerState.processingState]!,
      playing: _player.playerState.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  Duration? getDuration() {
    return _player.duration;
  }
  Duration getPosition() {//TODO:das hier für das spulen
    return _player.position;
  }
  Duration getBufferedPosition() {
    return _player.bufferedPosition;
  }
}