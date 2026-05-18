import 'package:audio_service/audio_service.dart';
import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/player/audio_player.dart';

class PlayerControls extends BaseAudioHandler with QueueHandler, SeekHandler {
  final QueueRepository _queueRepository = QueueRepository();
  final _player = MyPlayer();

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    _queueRepository.clearQueue();
    _queueRepository.addItem(mediaItem);
    skipToQueueItem(0);
    return;
  }
  @override
  addQueueItem(MediaItem mediaItem) async {
    _queueRepository.addItem(mediaItem);
    return;
  }
  @override
  insertQueueItem(int index,MediaItem mediaItem) async {
    _queueRepository.insertItem(mediaItem, index);
  }
  @override
  Future<void> skipToQueueItem(int index) async {
    MediaItem item = _queueRepository.getItemAtPos(index);
    _queueRepository.makeCurrent(index);
    _player.seek(Duration.zero);
    _player.setSource(item.id);
    return;
  }
}