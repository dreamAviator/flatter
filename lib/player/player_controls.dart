import 'package:audio_service/audio_service.dart';
import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/player/audio_player.dart';

class PlayerControls extends BaseAudioHandler with QueueHandler, SeekHandler {
  QueueRepository queueRepository = QueueRepository();
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
  Future<void> skipToQueueItem(int i) async {
    Map<dynamic,dynamic> item = queueRepository.getItemAtPos(i);
    queueRepository.makeCurrent(i);
    _player.seek(Duration.zero);
    _player.setSource(item['id']);
    return;
  }


}