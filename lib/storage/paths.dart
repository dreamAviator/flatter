import 'dart:io';

import 'package:path_provider/path_provider.dart';


class PathProvider {

  Future<void> initialize() async {
    await getDataDir();
    return;
  }

  Future<String> getDataDir() async {
    if (Platform.isAndroid == false) {
      Directory dataDirectory = await getApplicationSupportDirectory();
      return dataDirectory.path;
    } else {
      Directory? dataDirectory = await getExternalStorageDirectory();
      if (dataDirectory != null) {
        return dataDirectory.path;
      } else {
        Directory dataDirectory = await getApplicationSupportDirectory();
        return dataDirectory.path;
      }
    }
  }
}

class DirectoryManager {
  Future<void> initialize() async {

  }
}