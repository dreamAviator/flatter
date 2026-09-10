import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:toml/toml.dart';

class LocalNotDatabaseStorageController {
  final usefulScripts = SubsonicJustAudioCompatibility();
  void saveQueue() async {
    List<MediaItem> queue = await playerControl.customAction('getQueue');
    List<dynamic> queueSubsonicSongs = usefulScripts.mediaItemListToSubsonicSongList(queue);
    String dataDirectory = pathProvider.dataDirectory;
    String path = "$dataDirectory/flatter_persistent_queue.toml";
    int position = await playerControl.customAction('getCurrentIndex');
    Map<dynamic,dynamic> persistentQueueMap = {
      'queue':queueSubsonicSongs,
      'position':position,//not needed, because essentially the mediaitems with the "current" attribute are saved
    };
    TomlDocument persistentQueueDocument = TomlDocument.fromMap(persistentQueueMap);
    persistentQueueDocument.save(path);
  }

  Future<List<MediaItem>> loadQueue() async {
    TomlDocument persistentQueueDocument;
    String dataDirectory = pathProvider.dataDirectory;
    String path = "$dataDirectory/flatter_persistent_queue.toml";
    if (await File(path).exists() == false) {
      return [];
    }
    persistentQueueDocument = await TomlDocument.load(path);
    Map<dynamic,dynamic> persistentQueueMap = persistentQueueDocument.toMap();
    int position = persistentQueueMap['position'];//not needed, because essentially the mediaitems with the "current" attribute are saved
    List<dynamic> queueSubsonicSongs = persistentQueueMap['queue'];
    List<MediaItem> queue = usefulScripts.subsonicSongListToMediaItemList(queueSubsonicSongs);
    return queue;
  }
}