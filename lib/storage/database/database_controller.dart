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

  void addFolder(String path,String name) {;
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

  void changeFolderFavouriteStatus(String path) {
    if (_folder_db.getFavoriteStatus(path)[0]['isFavorited'] == 1) {
      _folder_db.setFavorite(path, 0);
    } else {
      _folder_db.setFavorite(path, 1);
    }
  }

  void changeFolderName(String path, String name) {
    if (name == "") {
      int lastSlash = path.lastIndexOf("/");
      name = path.substring(lastSlash + 1);
    }
    _folder_db.changeName(path, name);
  }

  void removeFolder(String path) {
    _folder_db.remove(path);
  }

  //TODO: change favorite status (actually wäre das eigentlich auch für songs babo, aber weniger wichtig. user soll sich einfach eine playlist machen xD
}