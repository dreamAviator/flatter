import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:toml/toml.dart';

class LocalNotDatabaseStorageController {
  final usefulScripts = OtherScripts();
  void saveQueue() async {//TODO:vlt eine möglichkeit finden, das als mediaitem list zu speichern. wäre einfacher.
    List<String> idList = usefulScripts.queueToIDlist(await playerControl.customAction('getQueue'));
    String dataDirectory = pathProvider.dataDirectory;
    String path = "$dataDirectory/flatter_persistent_queue.toml";
    int position = await playerControl.customAction('getCurrentIndex');
    Map<dynamic,dynamic> persistentQueueMap = {
      'queue':idList,
      'position':position
    };
    TomlDocument persistentQueueDocument = TomlDocument.fromMap(persistentQueueMap);
    persistentQueueDocument.save(path);
  }

  Future<List<MediaItem>> loadQueue() async {
    return [];
  }
}