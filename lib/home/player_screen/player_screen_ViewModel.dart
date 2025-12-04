import 'package:flatter/player/audio_player.dart';
import 'package:flutter/cupertino.dart';

class PlayerScreenViewModel extends ChangeNotifier {
  final player = MyPlayer();

  Future<void> setSource() async {
    await player.setSource("bleh :P");
  }

  Future<void> play() async {
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }
}