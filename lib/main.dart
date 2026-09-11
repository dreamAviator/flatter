import 'package:audio_service/audio_service.dart';
import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/home_navigation_bar.dart';
import 'package:flatter/home/home_navigation_rail.dart';
import 'package:flatter/player_related/player_controls.dart';
import 'package:flatter/storage/database/database_controller.dart';
import 'package:flatter/storage/settings_controller.dart';
import 'package:flatter/storage/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saf_util/saf_util.dart';

late final PlayerControls playerControl;
//DirectoryManager directoryControl = DirectoryManager();
SafUtil safutil = SafUtil();
SubsonicService subsonicService = SubsonicService();
late DatabaseController databaseControl;
late SettingsController settingsControl;
late PathProvider pathProvider;
late final AudioSession session;


void main() async {
  pathProvider = PathProvider();
  databaseControl = DatabaseController();
  settingsControl = SettingsController();
  await pathProvider.initialize();
  await databaseControl.initialize();
  await settingsControl.initialize();
  playerControl = await AudioService.init(
    builder: () => PlayerControls(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'me.dreamaviator.flutter.channel.audio',
      androidNotificationChannelName: 'flatter Music Playback'
    ),
  );
  session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.music());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width >= screenSize.height) {//das darf nicht immer ausgeführt werden lol
      settingsControl.changeSetting('landscapeMode', true);
      return MaterialApp(
        title: 'flatter',
        theme: ThemeData(
          useMaterial3: true,//in die settings packen
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: const HomeNavigationRail(),
      );
    } else {
      settingsControl.changeSetting('landscapeMode', false);
      return MaterialApp(
        title: 'flatter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: const HomeNavigationBar(),
      );
    }
  }
}