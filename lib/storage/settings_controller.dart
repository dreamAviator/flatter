import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';

class SettingsController {
  Map defaultSettingsMap = {};
  late Map settingsMap;

  SettingsController() {
    loadSettings();
  }

  void loadSettings() async {
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
}