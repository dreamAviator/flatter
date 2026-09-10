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

  List<dynamic> mediaItemListToSubsonicSongList(List<MediaItem> songList) {
    List<dynamic> subsonicSongList = [];
    for (MediaItem song in songList) {
      subsonicSongList.add(mediaItemToSubsonicSong(song));
    }
    return subsonicSongList;
  }

  Map<dynamic,dynamic> mediaItemToSubsonicSong(MediaItem song) {
    Map<dynamic,dynamic> subsonicSong = {
      'id':song.id,
      'title':song.title,
      'album':song.album,
      'artist':song.artist,
      'duration':song.duration?.inSeconds,
    };
    song.extras?.forEach((key,value) {
      subsonicSong[key] = value;
    });
    return subsonicSong;
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