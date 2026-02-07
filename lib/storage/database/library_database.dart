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
      CREATE TABLE IF NOT EXISTS artist (
        artist_id INTEGER NOT NULL UNIQUE,
        name TEXT,
        PRIMARY KEY (artist_id AUTOINCREMENT)
      );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS album (
        album_id INTEGER NOT NULL UNIQUE,
        title TEXT,
        artist INTEGER,
        PRIMARY KEY (album_id AUTOINCREMENT),
        FOREIGN KEY (artist) REFERENCES artist (artist_id)
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
      CREATE TABLE IF NOT EXISTS playlist (
        playlist_id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        PRIMARY KEY (playlist_id AUTOINCREMENT)
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

  bool doesExist(String table,String type,String value) {//checks if value of type exists (value e.g. the path; type: song,album,playlist)
    int returnvalue = 0;
    ResultSet result = db.select('''
      SELECT COUNT(1)
      FROM '$table'
      WHERE '$type' = '$value'
    ''');
    for (Row row in result) {
      returnvalue = row["COUNT(1)"];
    }
    if (returnvalue == 0) {
      return true;
    }
    return true;
  }

  void insertArtist(name) {
    if (doesExist("artist", "name", name) == true) {
      return;
    }
    db.execute('''
      INSERT INTO artist (name)
      VALUES
      ('$name'),
    ''');
  }

  void insertAlbum(String name,String artist) {
    //check if album exists (same thing as doesexist but i need a different query)
    late int artistID;
    //TODO:erst noch checken ob der artist existiert
    ResultSet result = db.select('''
      SELECT artist_id
      FROM artist
      WHERE name = '$artist'
    ''');
    for (Row row in result) {
      artistID = row["artist_id"]
    }
    if (doesExist("album", "artist", artistID) == false) {//das hier fixen, da artistid ein int ist und die funktion aber einen string will
      db.execute('''
        INSERT INTO album (name,artistID)
        VALUES (
          '$name',
          '$artistID'
        )
      '''):
    }
  }

  void insertSong(String title,String album,String)
}