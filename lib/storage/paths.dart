import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathProvider {
  PathProvider() {
    print("hello");
  }

  Future<String> getDataDir() async {
    Directory dataDirectory = await getApplicationSupportDirectory();
    return dataDirectory.path;
  }
}