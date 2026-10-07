import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';



class PathProvider {
  late final String dataDirectory;
  late final String tempDirectory;

  Future<void> initialize() async {
    await getDataDir();
    await getTempDir();
    if (Directory(dataDirectory).existsSync() == false) {
      await Directory(dataDirectory).create(recursive: true);
      await Directory("$dataDirectory/navidrome_mode").create(recursive: true);
      await Directory("$dataDirectory/local_mode").create(recursive: true);
    }
    if (Directory("$dataDirectory/navidrome_mode").existsSync() == false) {
      await Directory("$dataDirectory/navidrome_mode").create(recursive: true);
    }
    if (Directory("$dataDirectory/local_mode").existsSync() == false) {
      await Directory("$dataDirectory/local_mode").create(recursive: true);
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

    String readmeFilePath = "$dataDirectory/readme.txt";
    if (await File(readmeFilePath).exists() == false) {
      File(readmeFilePath).writeAsString("""
        flatter stores both config files and AppData in this directory.
        
        On Linux for example, this is not best practice,
        config files should be stored elsewhere (.config/appname),
        however, the package I use to dynamically get the directory paths,
        does not support that on linux yet, which is why all files are in
        this directory.
      """);
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