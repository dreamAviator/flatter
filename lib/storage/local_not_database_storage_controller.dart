import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:toml/toml.dart';

class LocalNotDatabaseStorageController {
  final usefulScripts = SubsonicJustAudioCompatibility();
  Future<void> saveQueue() async {
    List<MediaItem> queue = await playerControl.customAction('getQueue');
    List<dynamic> queueSubsonicSongs = usefulScripts.mediaItemListToSubsonicSongList(queue);
    String dataDirectory = pathProvider.dataDirectory;
    String path = "$dataDirectory/flatter_persistent_queue.toml";
    int position = playerControl.getPosition().inMilliseconds;
    Map<dynamic,dynamic> persistentQueueMap = {
      'queue':queueSubsonicSongs,
      'inSongPosition':position,//not needed, because essentially the mediaitems with the "current" attribute are saved
    };
    TomlDocument persistentQueueDocument = TomlDocument.fromMap(persistentQueueMap);
    persistentQueueDocument.save(path);
    return;
  }

  Future<(List<MediaItem>,Duration)> loadQueue() async {
    TomlDocument persistentQueueDocument;
    String dataDirectory = pathProvider.dataDirectory;
    String path = "$dataDirectory/flatter_persistent_queue.toml";
    if (await File(path).exists() == false) {
      return (<MediaItem>[],Duration.zero);
    }
    persistentQueueDocument = await TomlDocument.load(path);
    Map<dynamic,dynamic> persistentQueueMap = persistentQueueDocument.toMap();
    List<dynamic> queueSubsonicSongs = persistentQueueMap['queue'];
    List<MediaItem> queue = usefulScripts.subsonicSongListToMediaItemList(queueSubsonicSongs);
    Duration position = Duration(milliseconds: persistentQueueMap['inSongPosition']);
    return (queue,position);
  }
}