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
    'startTabSetting':['dropdown',-1,[-1,0,1,2]]//[selection,type,[options]] (-1 = last)
  };//das hier vielleicht auch zu einer datei machen
  late Map settingsMap;

  Future<void> initialize() async {
    await loadSettings();
    return;
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
    print(settingsMap);
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

  List<Widget> getSettingsOptions() {
    //später implementieren
    return [];
  }
}