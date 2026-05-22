import 'package:audio_service/audio_service.dart';
import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player/audio_player.dart';

import '../useful_scripts.dart';

class PlayerControls extends BaseAudioHandler with QueueHandler, SeekHandler {
  final QueueRepository _queueRepository = QueueRepository();
  final _player = MyPlayer();

  final SubsonicJustAudioCompatibility usefulScript = SubsonicJustAudioCompatibility();

  //play controls
  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> skipToNext() => skipToQueueItem(_queueRepository.getCurrentIndex() + 1);
  @override
  Future<void> skipToPrevious() => skipToQueueItem(_queueRepository.getCurrentIndex() - 1);
  @override
  Future<void> skipToQueueItem(int index) async {
    MediaItem item = _queueRepository.getItemAtPos(index);
    _queueRepository.makeCurrent(index);
    _player.seek(Duration.zero);
    _player.setSource(item.id);
    return;
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
    skipToQueueItem(0);
    return;
  }
  //queue controls
  @override
  Future<dynamic> customAction(String name,[Map<String,dynamic>? extras]) async {//hier fehlt noch addshuffled
    if (name case 'getQueue') {
      return getQueue();
    } else if (name case 'clearQueue') {
      _queueRepository.clearQueue();
      return;
    } else if (name case 'addNext') {
      if (extras != null) {
        int currentIndex = _queueRepository.getCurrentIndex();
        List<MediaItem> mediaItemList = extras['addNext'];
        for (MediaItem item in mediaItemList.reversed) {
          insertQueueItem(currentIndex, item);
        }
      }
    } else if (name case 'addMultiple') {
      if (extras != null) {
        List<MediaItem> mediaItemList = extras['addMultiple'];
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
    } else if (name case 'addByID') {

    } else if (name case 'addNextByID') {
      if (extras != null) {
        String? albumID = extras['addNextByID']['albumID'];
        String? playlistID = extras['addNextByID']['albumID'];
        String? artistID = extras['addNextByID']['albumID'];
        if (albumID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getAlbumDetails(albumID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['song']);
          customAction('addNext',{'addNext':mediaItemList});
        }
        if (playlistID != null) {
          Map<dynamic,dynamic> details = await subsonicService.getPlaylistDetails(playlistID);
          List<MediaItem> mediaItemList = usefulScript.subsonicSongListToMediaItemList(details['entry']);
          customAction('addNext',{'addNext':mediaItemList});
        }
        if (artistID != null) {
          //hier halt alle songs bekommen, probably durch full search einfach
        }
      }
    }
  }
  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    _queueRepository.addItem(mediaItem);
    return;
  }
  @override
  Future<void> insertQueueItem(int index,MediaItem mediaItem) async {
    _queueRepository.insertItem(mediaItem, index);
  }
  @override
  Future<void> removeQueueItemAt(int index) => _queueRepository.removeItem(index);

  List<MediaItem> getQueue() {
    return _queueRepository.getQueue();
  }
}