import 'package:flatter/home/home_navigation_bar.dart';
import 'package:flatter/player/player_controls.dart';
import 'package:flatter/storage/database/database_controller.dart';
import 'package:flatter/settings/settings_controller.dart';
import 'package:flutter/material.dart';

PlayerControls playerControl = PlayerControls();
late DatabaseController databaseControl;
late SettingsController settingsControl;


void main() async {
  databaseControl = DatabaseController();
  settingsControl = SettingsController();
  await databaseControl.initialize();
  await settingsControl.initialize();
  WidgetsFlutterBinding.ensureInitialized();
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