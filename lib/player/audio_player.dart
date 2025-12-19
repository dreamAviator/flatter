import 'package:audioplayers/audioplayers.dart';

class MyPlayer {
  final player = AudioPlayer();

  Future<void> setSource(String source) async {
    await player.setSource(DeviceFileSource(source));
  }

  Future<void> play() async {
    await player.resume();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }
}