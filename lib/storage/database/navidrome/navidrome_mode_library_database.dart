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
        navidrome_playlist_id TEXT NOT NULL,
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

  int getPlaylistID(int serverID,String playlistID) {
    print("hi 3.1");
    ResultSet result = db.select(
      'SELECT id FROM playlists WHERE server_id = ? AND navidrome_playlist_id = ?',
      [serverID, playlistID], // Werte werden hier sicher übergeben//thx deepseek
    );
    print("hi 3.2");
    print(result);
    for (Map playlist in result) {//should only be one playlist tho 😭
      int id = playlist['id'];
      return id;
    }
    return -1;
  }

  bool getPlaylistFavoriteStatus(int serverID,String playlistID) {
    print("hi 3");
    int id = getPlaylistID(serverID, playlistID);
    if (id == -1) {
      return false;
    }
    print(id);
    print("hi 4");
    ResultSet result = db.select(
      'SELECT is_favorite FROM playlists WHERE id = ?',
      [id],
    );
    print("favorite status result");
    print(result);
    for (Map playlist in result) {
      int isFavoriteInt = playlist['is_favorite'];
      print("hi5");
      if (isFavoriteInt == 1) {
        return true;
      }
    }
    return false;
  }

  void favoritePlaylist(int serverID,String playlistID) {
    //checken ob die playlist-server kombi existiert, wenn nicht dann value erstellen. oder maybe bei jedem holen vom server alle playlists einladen
    int id = getPlaylistID(serverID, playlistID);
    if (id == -1) {
      db.execute('''
        INSERT INTO playlists (navidrome_playlist_id,is_favorite,server_id)
        VALUES (?,1,?)
        ''',
        [playlistID,serverID],
      );
    } else {
      db.execute(
        'UPDATE playlists SET is_favorite = 1 WHERE id = ?',
        [id],
      );
    }
  }

  void unfavoritePlaylist(int serverID,String playlistID) {
    int id = getPlaylistID(serverID, playlistID);
    if (id == -1) {
      return;
    }
    db.execute(
      'UPDATE playlists SET is_favorite = 0 WHERE id = ?',
      [id],
    );
  }
}