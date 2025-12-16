import 'package:audioplayers/audioplayers.dart';

class MyPlayer {
  final player = AudioPlayer();

  Future<void> setSource(source) async {
    await player.setSource(DeviceFileSource(source));
  }

  Future<void> play() async {
    await player.resume();
  }

  Future<void> pause() async {
    await player.pause();
  }
}