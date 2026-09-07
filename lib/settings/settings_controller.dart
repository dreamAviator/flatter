import 'dart:io';

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
      'mainMenu':['playNow','addNext','enqueue','addToPlaylist','removeFromPlaylist'],
      'moreSheet':['album','artist','unFavorite'],
      'unused':[],
    },
    'albumMenuActionOrder':{
      'mainMenu':['playNow','addNext','enqueue'],
      'moreSheet':['artist','playNowShuffled','addNextShuffled','enqueueShuffled','unFavorite','addToPlaylist'],
      'unused':[],
    },
    'artistMenuActionOrder':{
      'mainMenu':['playNow','addNext','enqueue'],
      'moreSheet':['playNowShuffled','addNextShuffled','enqueueShuffled','unFavorite','addToPlaylist'],
      'unused':[],
    },
    'playlistMenuActionOrder':{
      'mainMenu':['playNow','addNext','enqueue'],
      'moreSheet':['playNowShuffled','addNextShuffled','enqueueShuffled','addToPlaylist'],
      'unused':[],
    },
    'moreOptionsSheetGridSize':3,//evt wegmachen, falls du das nicht als grid nimmst
    'timeUntilSeekToStart':3,//inSeconds
    'timeUntilScrobble':3,
    'skipArtistSelectionOnPlayerScreen':false,
    'skipArtistSelectionEverywhereElse':false,
    'clearSearchOnExit':true,
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
    _checkAndCorrectMenuActions();
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

  //additional functions
  void _checkAndCorrectMenuActions() {
    //songMenuActionOrder check
    List<dynamic> songMenuActions = [];
    songMenuActions = songMenuActions + settingsMap['songMenuActionOrder']['mainMenu'];
    songMenuActions = songMenuActions + settingsMap['songMenuActionOrder']['moreSheet'];
    songMenuActions = songMenuActions + settingsMap['songMenuActionOrder']['unused'];
    for (String action in defaultSettingsMap['songMenuActionOrder']['mainMenu']) {
      if (songMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['songMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['songMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['songMenuActionOrder']['moreSheet']) {
      if (songMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['songMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['songMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['songMenuActionOrder']['unused']) {
      if (songMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['songMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['songMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    songMenuActions.clear();
    songMenuActions = songMenuActions + defaultSettingsMap['songMenuActionOrder']['mainMenu'];
    songMenuActions = songMenuActions + defaultSettingsMap['songMenuActionOrder']['moreSheet'];
    songMenuActions = songMenuActions + defaultSettingsMap['songMenuActionOrder']['unused'];
    List<dynamic> actionsToRemove = [];
    for (String action in settingsMap['songMenuActionOrder']['mainMenu']) {
      if (songMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    List<dynamic> mainMenuActions = settingsMap['songMenuActionOrder']['mainMenu'];
    for (String action in actionsToRemove) {
      mainMenuActions.remove(action);
    }
    settingsMap['songMenuActionOrder']['mainMenu'] = mainMenuActions;
    actionsToRemove.clear();
    for (String action in settingsMap['songMenuActionOrder']['moreSheet']) {
      if (songMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    List<dynamic> moreSheetActions = settingsMap['songMenuActionOrder']['moreSheet'];
    for (String action in actionsToRemove) {
      moreSheetActions.remove(action);
    }
    settingsMap['songMenuActionOrder']['moreSheet'] = moreSheetActions;
    actionsToRemove.clear();
    for (String action in settingsMap['songMenuActionOrder']['unused']) {
      if (songMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    List<dynamic> unusedActions = settingsMap['songMenuActionOrder']['unused'];
    for (String action in actionsToRemove) {
      unusedActions.remove(action);
    }
    settingsMap['songMenuActionOrder']['unused'] = unusedActions;
    actionsToRemove.clear();
    //albumMenuActionOrder check
    List<dynamic> albumMenuActions = [];
    albumMenuActions = albumMenuActions + settingsMap['albumMenuActionOrder']['mainMenu'];
    albumMenuActions = albumMenuActions + settingsMap['albumMenuActionOrder']['moreSheet'];
    albumMenuActions = albumMenuActions + settingsMap['albumMenuActionOrder']['unused'];
    for (String action in defaultSettingsMap['albumMenuActionOrder']['mainMenu']) {
      if (albumMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['albumMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['albumMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['albumMenuActionOrder']['moreSheet']) {
      if (albumMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['albumMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['albumMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['albumMenuActionOrder']['unused']) {
      if (albumMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['albumMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['albumMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    albumMenuActions.clear();
    albumMenuActions = albumMenuActions + defaultSettingsMap['albumMenuActionOrder']['mainMenu'];
    albumMenuActions = albumMenuActions + defaultSettingsMap['albumMenuActionOrder']['moreSheet'];
    albumMenuActions = albumMenuActions + defaultSettingsMap['albumMenuActionOrder']['unused'];
    for (String action in settingsMap['albumMenuActionOrder']['mainMenu']) {
      if (albumMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    mainMenuActions = settingsMap['albumMenuActionOrder']['mainMenu'];
    for (String action in actionsToRemove) {
      mainMenuActions.remove(action);
    }
    settingsMap['albumMenuActionOrder']['mainMenu'] = mainMenuActions;
    actionsToRemove.clear();
    for (String action in settingsMap['albumMenuActionOrder']['moreSheet']) {
      if (albumMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    moreSheetActions = settingsMap['albumMenuActionOrder']['moreSheet'];
    for (String action in actionsToRemove) {
      moreSheetActions.remove(action);
    }
    settingsMap['albumMenuActionOrder']['moreSheet'] = moreSheetActions;
    actionsToRemove.clear();
    for (String action in settingsMap['albumMenuActionOrder']['unused']) {
      if (albumMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    unusedActions = settingsMap['albumMenuActionOrder']['unused'];
    for (String action in actionsToRemove) {
      unusedActions.remove(action);
    }
    settingsMap['albumMenuActionOrder']['unused'] = unusedActions;
    actionsToRemove.clear();
    //artistMenuActionOrder check
    List<dynamic> artistMenuActions = [];
    artistMenuActions = artistMenuActions + settingsMap['artistMenuActionOrder']['mainMenu'];
    artistMenuActions = artistMenuActions + settingsMap['artistMenuActionOrder']['moreSheet'];
    artistMenuActions = artistMenuActions + settingsMap['artistMenuActionOrder']['unused'];
    for (String action in defaultSettingsMap['artistMenuActionOrder']['mainMenu']) {
      if (artistMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['artistMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['artistMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['artistMenuActionOrder']['moreSheet']) {
      if (artistMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['artistMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['artistMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['artistMenuActionOrder']['unused']) {
      if (artistMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['artistMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['artistMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    artistMenuActions.clear();
    artistMenuActions = artistMenuActions + defaultSettingsMap['artistMenuActionOrder']['mainMenu'];
    artistMenuActions = artistMenuActions + defaultSettingsMap['artistMenuActionOrder']['moreSheet'];
    artistMenuActions = artistMenuActions + defaultSettingsMap['artistMenuActionOrder']['unused'];
    for (String action in settingsMap['artistMenuActionOrder']['mainMenu']) {
      if (artistMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    mainMenuActions = settingsMap['artistMenuActionOrder']['mainMenu'];
    for (String action in actionsToRemove) {
      mainMenuActions.remove(action);
    }
    settingsMap['artistMenuActionOrder']['mainMenu'] = mainMenuActions;
    actionsToRemove.clear();
    for (String action in settingsMap['artistMenuActionOrder']['moreSheet']) {
      if (artistMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    moreSheetActions = settingsMap['artistMenuActionOrder']['moreSheet'];
    for (String action in actionsToRemove) {
      moreSheetActions.remove(action);
    }
    settingsMap['artistMenuActionOrder']['moreSheet'] = moreSheetActions;
    actionsToRemove.clear();
    for (String action in settingsMap['artistMenuActionOrder']['unused']) {
      if (artistMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    unusedActions = settingsMap['artistMenuActionOrder']['unused'];
    for (String action in actionsToRemove) {
      unusedActions.remove(action);
    }
    settingsMap['artistMenuActionOrder']['unused'] = unusedActions;
    actionsToRemove.clear();
    //playlistMenuActionOrder check
    List<dynamic> playlistMenuActions = [];
    playlistMenuActions = playlistMenuActions + settingsMap['playlistMenuActionOrder']['mainMenu'];
    playlistMenuActions = playlistMenuActions + settingsMap['playlistMenuActionOrder']['moreSheet'];
    playlistMenuActions = playlistMenuActions + settingsMap['playlistMenuActionOrder']['unused'];
    for (String action in defaultSettingsMap['playlistMenuActionOrder']['mainMenu']) {
      if (playlistMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['playlistMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['playlistMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['playlistMenuActionOrder']['moreSheet']) {
      if (playlistMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['playlistMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['playlistMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    for (String action in defaultSettingsMap['playlistMenuActionOrder']['unused']) {
      if (playlistMenuActions.contains(action) == false) {
        List<dynamic> moreSheetActions = settingsMap['playlistMenuActionOrder']['moreSheet'];
        moreSheetActions.add(action);
        settingsMap['playlistMenuActionOrder']['moreSheet'] = moreSheetActions;
      }
    }
    playlistMenuActions.clear();
    playlistMenuActions = playlistMenuActions + defaultSettingsMap['playlistMenuActionOrder']['mainMenu'];
    playlistMenuActions = playlistMenuActions + defaultSettingsMap['playlistMenuActionOrder']['moreSheet'];
    playlistMenuActions = playlistMenuActions + defaultSettingsMap['playlistMenuActionOrder']['unused'];
    for (String action in settingsMap['playlistMenuActionOrder']['mainMenu']) {
      if (playlistMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    mainMenuActions = settingsMap['playlistMenuActionOrder']['mainMenu'];
    for (String action in actionsToRemove) {
      mainMenuActions.remove(action);
    }
    settingsMap['playlistMenuActionOrder']['mainMenu'] = mainMenuActions;
    actionsToRemove.clear();
    for (String action in settingsMap['playlistMenuActionOrder']['moreSheet']) {
      if (playlistMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    moreSheetActions = settingsMap['playlistMenuActionOrder']['moreSheet'];
    for (String action in actionsToRemove) {
      moreSheetActions.remove(action);
    }
    settingsMap['playlistMenuActionOrder']['moreSheet'] = moreSheetActions;
    actionsToRemove.clear();
    for (String action in settingsMap['playlistMenuActionOrder']['unused']) {
      if (playlistMenuActions.contains(action) == false) {
        actionsToRemove.add(action);
      }
    }
    unusedActions = settingsMap['playlistMenuActionOrder']['unused'];
    for (String action in actionsToRemove) {
      unusedActions.remove(action);
    }
    settingsMap['playlistMenuActionOrder']['unused'] = unusedActions;
  }
}