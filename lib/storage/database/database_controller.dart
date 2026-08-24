import 'package:flatter/main.dart';
import 'package:flatter/storage/database/local/folders_database.dart';
import 'package:flatter/storage/database/local/local_library_database.dart';
import 'package:flatter/storage/database/navidrome/navidrome_mode_servers_database.dart';
import 'package:sqlite3/common.dart';

class DatabaseController {
  late LocalModeLibraryDatabase _library_db;
  late LocalModeLibraryFoldersDatabase _folder_db;
  late ServersDatabase _servers_db;

  Future<void> initialize() async {
    _library_db = LocalModeLibraryDatabase();
    _folder_db = LocalModeLibraryFoldersDatabase();
    _servers_db = ServersDatabase();
    await _library_db.initialize();
    await _folder_db.initialize();
    await _servers_db.initialize();
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

  //library database

  //servers database

  void addServer(String name,String url,String username,String password) {
    _servers_db.addServer(name, url, username, password);
  }

  void deleteServer(int id) {
    _servers_db.deleteServer(id);
  }

  void selectServer(int id) {
    settingsControl.changeSetting('selectedServer', id);
  }

  List<String> getCurrentServer() {
    int currentID = settingsControl.loadSetting('selectedServer');
    return getServerByID(currentID);
  }

  List<String> getServerByID(int id) {
    return _servers_db.getServerInfo(id);
  }

  List<List> getServers() {
    return _servers_db.getServers();
  }

  String getCurrentUsername() {
    return getCurrentServer()[1];
  }
}