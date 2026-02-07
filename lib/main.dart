import 'dart:io';

import 'package:flatter/home/home_navigation_bar.dart';
import 'package:flatter/player/metadata_control.dart';
import 'package:flatter/player/player_controls.dart';
import 'package:flatter/storage/database/database_controller.dart';
import 'package:flatter/settings/settings_controller.dart';
import 'package:flatter/storage/paths.dart';
import 'package:flutter/material.dart';
import 'package:saf_util/saf_util.dart';

bool allow_android = false;
PlayerControls playerControl = PlayerControls();
DirectoryManager directoryControl = DirectoryManager();
SafUtil safutil = SafUtil();
MetadataControl metadataControl = MetadataControl();
late DatabaseController databaseControl;
late SettingsController settingsControl;
late PathProvider pathProvider;


void main() async {
  if (allow_android == false) {
    if (Platform.isAndroid == true) {
      return;
    }
  }
  WidgetsFlutterBinding.ensureInitialized();
  pathProvider = PathProvider();
  databaseControl = DatabaseController();
  settingsControl = SettingsController();
  await pathProvider.initialize();
  await databaseControl.initialize();
  await settingsControl.initialize();
  runApp(const MyApp());
}

void startApp() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flatter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const HomeNavigationBar(),
    );
  }
}