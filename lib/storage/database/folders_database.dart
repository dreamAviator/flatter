import 'dart:io';

import 'package:flatter/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class FoldersDatabase {
  late Database db;

  Future<void> initialize() async {
    await openDatabase();
    return;
  }

  Future<void> openDatabase() async {
    String path = pathProvider.dataDirectory;
    path = "${path}/flatter_library_folders.sqlite";
    print(path);
    db = sqlite3.open(path);
    createTables();
    return;
  }

  void closeDatabase() {
    db.close();
  }

  void createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS folder (
        id INTEGER NOT NULL UNIQUE,
        path TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        isFavorited INTEGER NOT NULL,
        PRIMARY KEY (id AUTOINCREMENT)
      )
    ''');
  }

  void addFolder(String path, String name) {
    db.execute('''
      REPLACE INTO folder (path,name,isFavorited)
      VALUES
      ('$path','$name',0)
    ''');
  }

  ResultSet getFolders() {
    ResultSet resultSet = db.select(
      'SELECT * FROM folder'
    );
    return resultSet;
  }

  ResultSet getFavoriteStatus(String path) {
    return db.select('''
      SELECT isFavorited FROM folder WHERE path = '$path'
    ''');
  }

  void setFavorite(String path, int isFavorite) {
    db.execute('''
      UPDATE folder SET isFavorited = $isFavorite WHERE path = '$path'
    ''');
  }

  void changeName(String path, String name) {
    db.execute('''
      UPDATE folder SET name = '$name' WHERE path = '$path'
    ''');
  }

  void remove(String path) {
    db.execute('''
      DELETE FROM folder WHERE path = '$path'
    ''');
  }
}