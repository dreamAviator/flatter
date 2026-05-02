import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';

extension on TomlDocument {
  Future<void> save(String filename) {
    return File(filename).writeAsString(toString());
  }
}

class SettingsController {
  Map defaultSettingsMap = {
    'startTab':1,
    'lastTab':1,
    'selectedServer':-1,
    'albumSortBy':'random',
    'artistSortBy':'random',
    'albumPlayButtonAction':'playNow',
    'playlistPlayButtonAction':'playNow',
    'albumSongListTapAction':'enqueue',
    'playlistSongListTapAction':'enqueue',
    'songsTabTapAction':'enqueue',
    'libraryTab':0,
    'lastLibraryTab':0,
    'addToPlaylistsSkipDuplicates':true,
    'landscapeMode':true,//TODO:das hier ändern lassen wenn sich die ausrichtung des bildschirms/die größe des fensters so verändert, dass es nicht mehr praktisch wäre
    'firstStart':true,//einstellung für stern oder herz
    'searchArtistCount':10,
    'searchAlbumCount':10,
    'searchSongCount':30,
    //noch die slidable actions machen. vlt auch so, dass man die anzahl machen kann. also einf ein menü, bei dem man die alle an und ausschalten kann. vlt auch die reihenfolge ändern
  };//das hier vielleicht auch zu einer datei machen
  late Map settingsMap;

  Future<void> initialize() async {
    await loadSettings();
    return;
  }

  void firstStart() {
    changeSetting('firstStart', false);
    //sets some settings for the first start
    if (Platform.isAndroid == true|| Platform.isIOS == true) {
      changeSetting('landscapeMode', false);
    }
  }

  Future<void> loadSettings() async {
    TomlDocument settingsDocument;
    Directory dataDirectory = await getApplicationSupportDirectory();
    String path = dataDirectory.path;
    path = "${path}/flatter_settings.toml";
    if (await File(path).exists() == false) {
      settingsDocument = TomlDocument.fromMap(defaultSettingsMap);
      File(path).writeAsString(settingsDocument.toString());
    }
    settingsDocument = await TomlDocument.load(path);
    settingsMap = settingsDocument.toMap();
    defaultSettingsMap.forEach((key,value) {
      if (settingsMap[key] == null) {
        settingsMap[key] = value;
      }
    });
    if (settingsMap['firstStart'] == true) {
      firstStart();
    }
    print(settingsMap);
  }

  void resetSettings() {
    settingsMap.clear();
    defaultSettingsMap.forEach((key,value) {
      changeSetting(key, value);
    });
  }

  void changeSetting(String key,dynamic value) {
    print(key);
    print(value);
    settingsMap[key] = value;
    print(settingsMap);
    saveSettings();
  }

  dynamic loadSetting(String key) {
    if (settingsMap.containsKey(key)) {
      return settingsMap[key];
    } else {
      return defaultSettingsMap[key];
    }
  }

  void saveSettings() async {
    Directory dataDirectory = await getApplicationSupportDirectory();
    String path = dataDirectory.path;
    path = "${path}/flatter_settings.toml";
    TomlDocument settingsDocument = TomlDocument.fromMap(settingsMap);
    await settingsDocument.save(path);
  }
}