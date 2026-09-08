import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:toml/toml.dart';

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

class OtherScripts {
  List<String> queueToIDlist(List<MediaItem> queue) {
    List<String> idList = [];
    for (MediaItem item in queue) {
      idList.add(item.id);
    }
    return idList;
  }

  Future<List<MediaItem>> idListToQueue(List<String> idList) async {
    return [];
  }
}


// Source - https://stackoverflow.com/a/73503029
// Posted by eamirho3ein, modified by community. See post 'Timeline' for change history
// Retrieved 2026-09-08, License - CC BY-SA 4.0

extension BoolOpposite on bool {
  bool opposite() {
    return this ? false : true;
  }
}

extension TomlDocumentSave on TomlDocument {
  Future<void> save(String filename) {
    return File(filename).writeAsString(toString());
  }
}