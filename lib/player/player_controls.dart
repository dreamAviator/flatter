import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/player/audio_player.dart';

class PlayerControls {
  final player = MyPlayer();
  final QueueRepository queueRepository = QueueRepository();

  bool playing = false;

  //player controls
  void setSource(int index) {
    player.setSource(getQueue()[index][0]);//sets the source to item at index
  }

  void togglePlayPause() {
    if (player.playerState().toString() == "PlayerState.playing") {
      pause();
    } else if (player.playerState().toString() == "PlayerState.paused") {
      play();
    } else if (player.playerState().toString() == "PlayerState.stopped") {
      setSource(getCurrentIndex());
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
      setSource(getCurrentIndex());
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
      makeCurrent(getCurrentIndex() - 1);
    }
    setSource(getCurrentIndex());
    play();
  }

  void skip() async {
    makeCurrent(getCurrentIndex() + 1);
    setSource(getCurrentIndex());
    play();
  }

  //playlist controls
  int getCurrentIndex() {
    List<List<dynamic>> queue = getQueue();
    for (int index = 0; index <= getQueueLength(); index++) {
      if (queue[index][2] == true) {
        return index;
      }
    }
    return -1;
  }

  void playSpecificFromQueue(int index) {
    player.setSource(queueRepository.getItemAtPos(index)[0]);
  }

  void addItemAt(int position, String file) {
    bool current = false;
    if (getQueueLength() == 0) {
      current = true;
    }
    List<dynamic> item = getMetadata(file);
    item.add(current);
    queueRepository.addItem(item, position);
  }

  List<List<dynamic>> getQueue() {
    return queueRepository.getQueue();
  }

  int getQueueLength() {
    return queueRepository.getQueueLength();
  }

  void moveItem(int oldIndex,int newIndex) {
    final List<dynamic> item = queueRepository.getItemAtPos(oldIndex);
    queueRepository.removeItem(oldIndex);
    queueRepository.addItem(item, newIndex);
  }

  void makeCurrent(int index) {
    queueRepository.makeCurrent(index);
  }
  //metadata
  List<dynamic> getMetadata(String path) {
    int lastSlash = path.lastIndexOf("/");
    String name = path.substring(lastSlash + 1);
    return [path,[name]];
  }
}