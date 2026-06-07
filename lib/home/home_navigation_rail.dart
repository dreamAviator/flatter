import 'package:flatter/home/library_screen/library_screen_ViewModel.dart';
import 'package:flatter/home/player_screen/player_screen.dart';
import 'package:flatter/home/queue_screen/queue_screen.dart';
import 'package:flatter/home/search_screen/search_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../settings/settings_screen.dart';
import '../settings/settings_screen_ViewModel.dart';
import 'first_start_popup.dart';
import 'library_screen/library_screen.dart';

class HomeNavigationRail extends StatefulWidget {
  const HomeNavigationRail({super.key});

  @override
  State<HomeNavigationRail> createState() => _HomeNavigationRailState();
}

class _HomeNavigationRailState extends State<HomeNavigationRail> {
  int currentPageIndex = settingsControl.loadSetting('startTab');
  final LibraryScreenViewModel libraryScreenViewModel = LibraryScreenViewModel();
  final SettingsScreenViewmodel settingsScreenViewmodel = SettingsScreenViewmodel();

  @override
  Widget build(BuildContext context) {
    /*
    if (settingsControl.loadSetting('firstStart') == false) {
      FirstStartPopup.showFirstStartPopup(context);
    }
    funktioniert nicht
     */
    if (currentPageIndex == -1) {
      currentPageIndex = settingsControl.loadSetting('lastTab');
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
                settingsControl.changeSetting('lastTab', index);
              });
            },
            selectedIndex: currentPageIndex,
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.library_music), label: Text('Library')),
              NavigationRailDestination(icon: Icon(Icons.music_note), label: Text('Player')),
              NavigationRailDestination(icon: Icon(Icons.queue_music), label: Text('Queue')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text("")),//works tho lol
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text("")),//looks nice xD
            ],
            groupAlignment: -1,//in den einstellungen festlegen
            labelType: NavigationRailLabelType.all,
            //extended: true,das ding extendable machen (dazu musst du noch was anderes umstellen, sonst gibt es einen fehler
          ),
          const VerticalDivider(),
          Expanded(
            child: [
              LibraryScreen(viewModel: libraryScreenViewModel),
              PlayerScreen(),
              QueueScreen(),
              SearchScreen(),
              SettingsScreen(viewModel: settingsScreenViewmodel),
              ][currentPageIndex],
            /*
            child: IndexedStack(
              index: currentPageIndex,
              children: [
                LibraryScreen(viewModel: libraryScreenViewModel),
                PlayerScreen(),
                QueueScreen(),
                SearchScreen(),
                SettingsScreen(viewModel: settingsScreenViewmodel),
              ],
            ),

             */
          ),
        ],
      ),
    );
  }
}