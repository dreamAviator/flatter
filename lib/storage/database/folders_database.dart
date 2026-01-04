import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class FoldersDatabase {
  late Database db;

  FoldersDatabase() {
    openDatabase();
  }

  void openDatabase() async {
    Directory dataDirectory = await getApplicationSupportDirectory();
    print(dataDirectory.path);
    String path = dataDirectory.path;
    path = "${path}/flatter_library_folders.sqlite";
    print(path);
    db = sqlite3.open(path);
    createTables();
    closeDatabase();
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
        PRIMARY KEY (id AUTOINCREMENT)
      )
    ''');
  }
}