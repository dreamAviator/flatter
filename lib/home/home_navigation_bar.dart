import 'package:flatter/home/first_start_popup.dart';
import 'package:flatter/home/library_screen/library_screen.dart';
import 'package:flatter/home/library_screen/library_screen_ViewModel.dart';
import 'package:flatter/home/player_screen/player_screen.dart';
import 'package:flatter/home/queue_screen/queue_screen.dart';
import 'package:flatter/home/search_screen/search_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int currentPageIndex = settingsControl.loadSetting('startTab');
  final LibraryScreenViewModel libraryScreenViewModel = LibraryScreenViewModel();

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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (currentPageIndex == index) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
            return;//vlt, wenn man das von nem anderen fenster aus macht so machen, dass man nicht den tab wechselt
          }
          setState(() {
            if (currentPageIndex <= 2) {
              currentPageIndex = index;
            }
            settingsControl.changeSetting('lastTab', index);
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Library',),
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Player'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: 'Queue'),
        ],
      ),
      body: [
        LibraryScreen(viewModel: libraryScreenViewModel,),
        PlayerScreen(),
        QueueScreen(),
      ][currentPageIndex],
      /*
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          LibraryScreen(viewModel: libraryScreenViewModel,),
          PlayerScreen(),
          QueueScreen(),
        ],
      ),

       */
    );
  }
}