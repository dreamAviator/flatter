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
    'landscapeMode':true,//TODO:needs to override automatic change of layout, extra setting added below
    'automaticRotationOverride':false,
    'firstStart':true,//einstellung für stern oder herz für das favouriten der songs vlt
    'searchArtistCount':10,
    'searchAlbumCount':10,
    'searchSongCount':30,
    'mode':"navidrome",
    'songMenuActionOrder':{//TODO:das hier muss sich automatisch ändern, wenn optionen hinzugefügt oder entfernt werden
      'mainMenu':['playNow','addNext','enqueue','removeFromPlaylist'],
      'moreSheet':['album','artist','unFavorite'],
      'unused':[],
    },
    'albumMenuActionOrder':{
      'mainMenu':['playNow','addNext','enqueue'],
      'moreSheet':['artist','playNowShuffled','addNextShuffled','enqueueShuffled','unFavorite'],
      'unused':[],
    },
    'artistMenuActionOrder':{
      'mainMenu':['playNow','addNext','enqueue'],
      'moreSheet':['playNowShuffled','addNextShuffled','enqueueShuffled','unFavorite'],
      'unused':[],
    },
    'playlistMenuActionOrder':{
      'mainMenu':['playNow','addNext','enqueue'],
      'moreSheet':['playNowShuffled','addNextShuffled','enqueueShuffled'],
      'unused':[],
    },
    'moreOptionsSheetGridSize':3,//evt wegmachen, falls du das nicht als grid nimmst
    'timeUntilSeekToStart':3,//inSeconds
    'timeUntilScrobble':3,
    'skipArtistSelectionOnPlayerScreen':false,
    'skipArtistSelectionEverywhereElse':false,
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
  }

  Future<void> loadSettings() async {
    TomlDocument settingsDocument;
    Directory dataDirectory = await getApplicationSupportDirectory();
    String path = dataDirectory.path;
    path = "${path}/flatter_settings.toml";
    if (await File(path).exists() == false) {
      print("file does not exist");
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
    List keysToRemove = [];
    settingsMap.forEach((key,value) {
      if (defaultSettingsMap[key] == null) {
        keysToRemove.add(key);
      }
    });
    for (String key in keysToRemove) {
      settingsMap.remove(key);
    }
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