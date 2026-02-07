import 'package:flatter/main.dart';
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

  //folders

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

  //songs
  void addSong(String path) async {
    //check if file exists
    bool doesExist = _library_db.doesExist("song", "path", path);
    if (doesExist) {
      return;
    }
    await metadataControl.loadFile(path);
    String title = "[Unknown title]";
    String album = "[Unknown Album]";
    String trackArtist = "[Unknown Artist]";
    String albumArtist = "[Unknown Artist]";
    int albumTrackNumber = 0;
    title = metadataControl.tags!.title!;
    trackArtist = metadataControl.tags!.trackArtist!;
    albumArtist = metadataControl.tags!.albumArtist!;
    album = metadataControl.tags!.album!;
    albumTrackNumber = metadataControl.tags!.trackNumber!;

    if (_library_db.doesExist("artist", "name", trackArtist) == false) {
      //artist einfügen
    }

    void insertArtist(String name) {
      
    }
  }
}