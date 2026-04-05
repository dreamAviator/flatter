import 'package:audio_service/audio_service.dart';
import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/home_navigation_bar.dart';
import 'package:flatter/player/player_controls.dart';
import 'package:flatter/storage/database/database_controller.dart';
import 'package:flatter/settings/settings_controller.dart';
import 'package:flatter/storage/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saf_util/saf_util.dart';

late final PlayerControls playerControl;
//DirectoryManager directoryControl = DirectoryManager();
SafUtil safutil = SafUtil();
SubsonicService subsonicService = SubsonicService();
RiverpodManager riverpodManager = RiverpodManager();
late DatabaseController databaseControl;
late SettingsController settingsControl;
late PathProvider pathProvider;
late final AudioSession session;


void main() async {
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
  pathProvider = PathProvider();
  databaseControl = DatabaseController();
  settingsControl = SettingsController();
  await pathProvider.initialize();
  await databaseControl.initialize();
  await settingsControl.initialize();
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
    return MaterialApp(
      title: 'flatter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const HomeNavigationBar(),
    );
  }
}