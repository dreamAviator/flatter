import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saf_util/saf_util.dart';
import 'package:saf_util/saf_util_platform_interface.dart';

import '../main.dart';


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
  Future<String?> openDirectory() async {
    if (Platform.isAndroid == false) {
      String? path = await FilePicker.platform.getDirectoryPath();
      return path;
    } else {
      SafDocumentFile? directory = await safutil.pickDirectory();
      return directory?.uri;
    }
  }

  Future<List> getDirectoryContents(String path) async {
    if (Platform.isAndroid == false) {
      Directory dir = Directory(path);
      List<FileSystemEntity> entries = await dir.list().toList();
      return entries;
    } else {
      var entries = await safutil.list(path);
      return entries;
    }
  }
}