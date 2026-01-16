import 'package:flatter/storage/database/folders_database.dart';
import 'package:flatter/storage/database/library_database.dart';
import 'package:sqlite3/common.dart';

class DatabaseController {
  late LibraryDatabase _library_db;
  late FoldersDatabase _folder_db;

  Future<void> initialize() async {
    _library_db = LibraryDatabase();
    _folder_db = FoldersDatabase();
    await _library_db.initialize();
    await _folder_db.initialize();
    return;
  }

  void addFolder(String path) {
    int lastSlash = path.lastIndexOf("/");
    String name = path.substring(lastSlash + 1);
    _folder_db.addFolder(path, name);
  }

  List<List<dynamic>> getFolders() {
    List<List<dynamic>> startFolders = [];
    ResultSet resultSet = _folder_db.getFolders();
    for (Row row in resultSet) {
      bool isFavorited = false;
      if (row['isFavorited'] == 1) {
        isFavorited = true;
      }
      startFolders.add(["${row['path']}","${row['name']}",isFavorited]);
    }
    return startFolders;
  }
}