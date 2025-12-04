import 'package:audioplayers/audioplayers.dart';

class MyPlayer {
  final player = AudioPlayer();

  Future<void> setSource(source) async {
    await player.setSourceUrl("https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_500KB_MP3.mp3");
  }

  Future<void> play() async {
    await player.resume();
  }

  Future<void> pause() async {
    await player.pause();
  }
}