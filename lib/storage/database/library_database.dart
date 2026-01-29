import 'dart:io';

import 'package:flatter/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class LibraryDatabase {
  late Database db;

  Future<void> initialize() async {
    await openDatabase();
  }

  Future<void> openDatabase() async {
    String path = pathProvider.dataDirectory;
    path = "${path}/flatter_library.sqlite";
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
      CREATE TABLE IF NOT EXISTS album (
        album_id INTEGER NOT NULL UNIQUE,
        title TEXT,
        artist TEXT,
        PRIMARY KEY (album_id AUTOINCREMENT)
      );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS artist (
        artist_id INTEGER NOT NULL UNIQUE,
        name TEXT,
        PRIMARY KEY (artist_id AUTOINCREMENT)
      );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS playlist (
        playlist_id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        PRIMARY KEY (playlist_id AUTOINCREMENT)
      );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS song (
        song_id INTEGER NOT NULL UNIQUE,
        path TEXT NOT NULL UNIQUE,
        duration INTEGER NOT NULL,
        title TEXT,
        artist_id INTEGER,
        album_id INTEGER,
        isFavorited INTEGER,
        PRIMARY KEY (song_id AUTOINCREMENT),
        FOREIGN KEY (album_id) REFERENCES album (album_id),
        FOREIGN KEY (artist_id) REFERENCES artist (artist_id)
      );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS song_playlist_relation (
        song_id INTEGER,
        playlist_id INTEGER,
        position INTEGER,
        FOREIGN KEY (song_id) REFERENCES song (song_id),
        FOREIGN KEY (playlist_id) REFERENCES playlist (playlist_id)
      );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS song_album_relation (
        song_id INTEGER,
        album_id INTEGER,
        position INTEGER,
        FOREIGN KEY (song_id) REFERENCES song (song_id),
        FOREIGN KEY (album_id) REFERENCES album (album_id)
      );
    ''');
  }
}