import 'package:flatter/main.dart';
import 'package:sqlite3/sqlite3.dart';

class NavidromeModeDatabase {
  late Database db;

  Future<void> initialize() async {
    await openDatabase();
    return;
  }

  Future<void> openDatabase() async {
    String path = pathProvider.dataDirectory;
    path = "${path}/navidrome/navidrome_mode_database";
    db = sqlite3.open(path);

    return;
  }

  void closeDatabase() {
    db.close();
  }

  void createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS playlist_favorites (
        id INTEGER NOT NULL UNIQUE,
        PRIMARY KEY (id)
      )
    ''');
  }

  void addPlaylist(String id) {
    db.execute('''
      INSERT INTO playlist_favorites (id)
      VALUES
      ('$id')
    ''');
  }

  void removePlaylist(String id) {

  }
}