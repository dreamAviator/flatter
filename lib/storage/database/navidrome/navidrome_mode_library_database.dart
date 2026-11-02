import 'package:flatter/main.dart';
import 'package:sqlite3/sqlite3.dart';

class NavidromeModeLibraryDatabase {
  late Database db;

  //muss pro server unterscheiden können

  Future<void> initialize() async {
    await openDatabase();
    return;
  }

  Future<void> openDatabase() async {
    String path = pathProvider.dataDirectory;
    path = "$path/navidrome_mode/flatter_navidrome_mode_library.sqlite";
    db = sqlite3.open(path);
    createTables();
    return;
  }

  void closeDatabase() {
    db.close();
  }

  void createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS playlists (
        id INTEGER NOT NULL UNIQUE,
        navidrome_playlist_id INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL,
        server_id INTEGER NOT NULL,
        PRIMARY KEY (id AUTOINCREMENT)
      )
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER NOT NULL UNIQUE,
        navidrome_song_id INTEGER NOT NULL,
        replay_gain INTEGER,
        server_id INTEGER NOT NULL,
        PRIMARY KEY (id AUTOINCREMENT)
      )
    ''');
  }

  void favoritePlaylist(int serverID,int playlistID,bool isFavorite) {
    //checken ob die playlist-server kombi existiert, wenn nicht dann value erstellen. oder maybe bei jedem holen vom server alle playlists einladen
  }
}