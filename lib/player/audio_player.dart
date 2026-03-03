

import 'dart:io';

import 'package:flatter/main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

class MyPlayer {
  final _player = AudioPlayer();

  MyPlayer() {
    JustAudioMediaKit.ensureInitialized();
  }

  Future<void> setSource(String source) async {
    print(source);
    if (Platform.isAndroid == true) {
      Uri uriSource = Uri.parse(source);
      await _player.setAudioSource(AudioSource.uri(uriSource));
    } if (source.startsWith("/")) {//idk irgendwie checken, ob das eine lokale datei ist
      List<String> baseUrl = subsonicService.getURL(null, null, null);
      Uri uriSource = Uri.parse("${baseUrl[0]}stream${baseUrl[1]}&id=$source");
      await _player.setAudioSource(AudioSource.uri(uriSource));
    } else {
      await _player.setAudioSource(AudioSource.file(source));
    }
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  PlayerState playerState() {
    return _player.playerState;
  }
}