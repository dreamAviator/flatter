import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saf_util/saf_util_platform_interface.dart';

import '../main.dart';


class PathProvider {
  late final String dataDirectory;
  late final String tempDirectory;

  Future<void> initialize() async {
    await getDataDir();
    await getTempDir();
    if (Directory(dataDirectory).existsSync() == false) {
      await Directory(dataDirectory).create(recursive: true);
    }
    if (Directory(tempDirectory).existsSync() == false) {
      await Directory(tempDirectory).create(recursive: true);
    }
    return;
  }

  Future<void> getDataDir() async {
    if (Platform.isAndroid == false) {
      Directory dataDirectoryDirectory = await getApplicationSupportDirectory();
      dataDirectory = dataDirectoryDirectory.path;
    } else {
      Directory? dataDirectoryDirectory = await getExternalStorageDirectory();
      if (dataDirectoryDirectory != null) {
        dataDirectory = dataDirectoryDirectory.path;
      } else {
        Directory dataDirectoryDirectory = await getApplicationSupportDirectory();
        dataDirectory = dataDirectoryDirectory.path;
      }
    }
  }

  Future<void> getTempDir() async {
    Directory tempDirectoryDirectory = await getTemporaryDirectory();
    tempDirectory = tempDirectoryDirectory.path;
    return;
  }
}

/*
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

  Future<SafDocumentFile?> getDocumentFileFromUri(String path) async {
    return await safutil.documentFileFromUri(path, false);
  }

  Future<SafDocumentFile?> getDocumentDirectoryFromUri(String path) async {
    return await safutil.documentFileFromUri(path, true);
  }
/*
  Future<String> createTempFile(String uriPath) async {
    //File file = await toFile(uriPath);
    File.fromUri(getD);
    //return file.path;
  }

 */
}

 */