import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player/audio_player.dart';
import 'package:flutter/cupertino.dart';

class PlayerScreenViewModel extends ChangeNotifier {

  Future<void> setSource() async {
    playerControl.playSpecificFromQueue(0);
  }

  Future<void> play() async {
    playerControl.play();
  }

  Future<void> pause() async {
    playerControl.pause();
  }

  Future<void> rewind() async {
    print("nothing here yet");
  }

  Future<void> skip() async {
    print("nothing heree yetr");
  }
}