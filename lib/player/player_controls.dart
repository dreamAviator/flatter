import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player/audio_player.dart';

class PlayerControls {
  final player = MyPlayer();
  final QueueRepository queueRepository = QueueRepository();

  void setSource(String source) {
    player.setSource(source);
  }

  void play() {
    player.play();
  }

  void pause() {
    player.pause();
  }

  void seek(Duration position) async {
    player.seek(position);
  }

  //playlist controls
  void playSpecificFromQueue(int index) {
    player.setSource(queueRepository.getItemAtPos(index));
  }

  void addItemAt(int position, String item) {
    queueRepository.addItem(item, position);
  }
}