import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/player/audio_player.dart';

class PlayerControls {
  final player = MyPlayer();
  final QueueRepository queueRepository = QueueRepository();

  int _currentIndex = 0;
  bool playing = false;

  //player controls
  void setSource(String source) {
    player.setSource(source);
  }

  void togglePlayPause() {
    if (player.playerState().toString() == "PlayerState.playing") {
      pause();
    } else if (player.playerState().toString() == "PlayerState.paused") {
      play();
    } else if (player.playerState().toString() == "PlayerState.stopped") {
      player.setSource(queueRepository.getItemAtPos(_currentIndex)[0]);
      play();
    }
  }

  String checkPlayerState() {
    if (player.playerState().toString() == "PlayerState.playing") {
      return "playing";
    } else if (player.playerState().toString() == "PlayerState.paused") {
      return "paused";
    } else if (player.playerState().toString() == "PlayerState.stopped") {
      return "stopped";
    } else {
      return "";
    }
  }

  bool isPlayerPlaying() {
    if (checkPlayerState() == "playing") {
      return true;
    } else {
      return false;
    }
  }

  void play() {
    if (queueRepository.getQueueLength() == 0) {
      return;
    }
    if (checkPlayerState() == "stopped") {
      player.setSource(queueRepository.getItemAtPos(_currentIndex)[0]);
    }
    player.play();
  }

  void pause() {
    player.pause();
  }

  void seek(Duration position) async {
    player.seek(position);
  }

  void rewind() async {
    //hier seek zum anfang des songs oder vorheriger song
    if (true) {
      _currentIndex = _currentIndex - 1;
    }
    setSource(queueRepository.getItemAtPos(_currentIndex)[0]);
    play();
  }

  void skip() async {
    _currentIndex = _currentIndex + 1;
    setSource(queueRepository.getItemAtPos(_currentIndex)[0]);
    play();
  }

  //playlist controls
  int getCurrentIndex() {
    return _currentIndex;
  }

  void playSpecificFromQueue(int index) {
    player.setSource(queueRepository.getItemAtPos(index)[0]);
  }

  void addItemAt(int position, String item) {
    queueRepository.addItem(getMetadata(item), position);
  }

  List<List<String>> getQueue() {
    return queueRepository.getQueue();
  }

  void moveItem(oldIndex,newIndex) {
    final List<String> file = queueRepository.getItemAtPos(oldIndex);
    queueRepository.removeItem(oldIndex);
    queueRepository.addItem(file, newIndex);
  }

  //metadata
  List<String> getMetadata(String path) {
    int lastSlash = path.lastIndexOf("/");
    String name = path.substring(lastSlash + 1);
    return [path,name];
  }
}