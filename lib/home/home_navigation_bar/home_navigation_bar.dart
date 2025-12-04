import 'package:flatter/home/library_screen/library_screen.dart';
import 'package:flatter/home/library_screen/library_screen_ViewModel.dart';
import 'package:flatter/home/player_screen/player_screen.dart';
import 'package:flatter/home/player_screen/player_screen_ViewModel.dart';
import 'package:flatter/home/queue_screen/queue_screen.dart';
import 'package:flatter/home/queue_screen/queue_screen_ViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int currentPageIndex = 1;
  final PlayerScreenViewModel playerScreenViewModel = PlayerScreenViewModel();
  final LibraryScreenViewModel libraryScreenViewModel = LibraryScreenViewModel();
  final QueueScreenViewModel queueScreenViewModel = QueueScreenViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Library',),
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Player'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: 'Queue'),
        ],
      ),
      body: <Widget>[
        LibraryScreen(viewModel: libraryScreenViewModel,),
        PlayerScreen(viewModel: playerScreenViewModel),
        QueueScreen(viewModel: queueScreenViewModel),
      ][currentPageIndex],
    );
  }
}