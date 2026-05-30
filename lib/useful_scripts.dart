import 'package:audio_service/audio_service.dart';

class SubsonicJustAudioCompatibility {

  List<MediaItem> subsonicSongListToMediaItemList(List<dynamic> songList) {
    List<MediaItem> mediaItemList = [];
    for (Map<dynamic,dynamic> song in songList) {
      mediaItemList.add(subsonicSongToMediaItem(song));
    }
    return mediaItemList;
  }

  MediaItem subsonicSongToMediaItem(Map<dynamic,dynamic> song) {
    String id = song['id'];
    String title = song['title'];
    String album = song['album'];
    String artist = song['artist'];
    Duration duration = Duration(seconds: song['duration']);
    song.remove('id');
    song.remove('title');
    song.remove('album');
    song.remove('artist');
    song.remove('duration');
    Map<String,dynamic> extras = {};
    song.forEach((key,value) {
      extras[key] = value;
    });
    return MediaItem(id: id, title: title, album: album, artist: artist, duration: duration,extras: extras);//rating noch rein
  }
}