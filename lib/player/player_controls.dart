import 'package:audio_service/audio_service.dart';
import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player/audio_player.dart';
import 'package:just_audio/just_audio.dart';

import '../useful_scripts.dart';

class PlayerControls extends BaseAudioHandler with QueueHandler, SeekHandler {
  final QueueRepository _queueRepository = QueueRepository();
  final _player = MyPlayer();

  PlayerControls() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    playbackState.listen((data) async {
      if (data.processingState == AudioProcessingState.completed) {
        if (_queueRepository.getCurrentIndex() == _queueRepository.getQueueLength() - 1) {
          stop();
        }
        skipToNext();
      }
    });
    /*
    AudioService.position.listen((data) {
      if (data >= Duration(seconds: settingsControl.loadSetting('timeUntilScrobble'))) {
        print("harharhar");
        subsonicService.scrobble(mediaItem.value?.id ?? null, true);
      }
    });
    */
  }

  final SubsonicJustAudioCompatibility usefulScript = SubsonicJustAudioCompatibility();

  //play controls
  @override
  Future<void> play() async {
    _player.play();
  }
  @override
  Future<void> pause() async {
    _player.pause();
  }
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> skipToNext() async {
    if (_queueRepository.getCurrentIndex() != _queueRepository.getQueueLength() - 1) {
      skipToQueueItem(_queueRepository.getCurrentIndex() + 1);
    }
  }
  @override
  Future<void> skipToPrevious() async {
    if (_queueRepository.getCurrentIndex() != 0) {//vlt hier machen, dass es funktioniert wenn man ein looping angeschaltet hat
      skipToQueueItem(_queueRepository.getCurrentIndex() - 1);
    }
  }
  @override
  Future<void> skipToQueueItem(int index) async {
    MediaItem item = _queueRepository.getItemAtPos(index);
    _queueRepository.makeCurrent(index);
    _player.seek(Duration.zero);
    _player.setSource(item.id);
    mediaItem.add(item);
    play();
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
      return;
    } else if (name case 'addNext') {
      if (extras != null) {
        int currentIndex = _queueRepository.getCurrentIndex();
        List<MediaItem> mediaItemList = extras['addNext']['tracks'];
        bool? shuffled = extras['addNext']['shuffled'];
        if (shuffled == true) mediaItemList.shuffle();
        for (MediaItem item in mediaItemList.reversed) {
          insertQueueItem(currentIndex, item);
        }
      }
    } else if (name case 'addMultiple') {
      if (extras != null) {
        List<MediaItem> mediaItemList = extras['addMultiple']['tracks'];
        bool? shuffled = extras['addMultiple']['shuffled'];
        if (shuffled == true) mediaItemList.shuffle();
        for (MediaItem item in mediaItemList) {
          addQueueItem(item);
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
    } else if (name case 'addByID') {//TODO: das hier fehlt halt

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
          customAction('addNext',{'addNext':[mediaItem]});
        }
        if (albumID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getAlbumDetails(albumID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['song']);
          if (shuffled == true) mediaItemList.shuffle();
          customAction('addNext',{'addNext':mediaItemList});
        }
        if (playlistID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getPlaylistDetails(playlistID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['entry']);
          if (shuffled == true) mediaItemList.shuffle();
          customAction('addNext',{'addNext':mediaItemList});
        }
        if (artistID != null) {
          //hier halt alle songs bekommen, probably durch full search einfach
          //shuffle nd vergessen
        }
      }
    } else if (name case 'getCurrentItem') {
      return _queueRepository.getItemAtPos(_queueRepository.getCurrentIndex());
    }
  }
  //queue controls
  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    _queueRepository.addItem(mediaItem);
    if (_queueRepository.getQueueLength() == 1) skipToQueueItem(0);
    return;
  }
  @override
  Future<void> insertQueueItem(int index,MediaItem mediaItem) async {
    _queueRepository.insertItem(mediaItem, index);
    if (_queueRepository.getQueueLength() == 1) skipToQueueItem(0);
  }
  @override
  Future<void> removeQueueItemAt(int index) => _queueRepository.removeItem(index);


  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playerState.playing) MediaControl.pause else MediaControl.play,//TODO:aussuchen, was alles angezeigt werden soll
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
  Duration getPosition() {
    return _player.position;
  }
  Duration getBufferedPosition() {
    return _player.bufferedPosition;
  }
}