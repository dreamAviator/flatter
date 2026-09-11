import 'package:flatter/main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

class MyPlayer extends AudioPlayer{

  @override
  MyPlayer() {
    JustAudioMediaKit.ensureInitialized();
  }

  Future<void> setSource(String id) async {//bei id lassen, i yt odus halt die yt id und beim lokalen modus den stuff in einer datenbank machen oder so
    if (settingsControl.loadSetting('mode') == "navidrome" || settingsControl.loadSetting('mode') == "subsonic" || settingsControl.loadSetting("mode") == "opensubsonic") {
      List<String> baseUrl = subsonicService.getURL(null, null, null);
      Uri uriSource = Uri.parse("${baseUrl[0]}stream${baseUrl[1]}&id=$id");
      await setAudioSource(AudioSource.uri(uriSource));
    }
  }
}