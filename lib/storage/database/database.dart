import 'package:flatter/main.dart';
import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  final db = sqlite3.open(appDirs.data);

  ResultSet readsomething() {
    return db.select('SELECT * FROM artist');
  }

  void writesomething() {
    db.execute('CREATE TABLE artist (artist_id INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT, name TEXT)');
  }
}