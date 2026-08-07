import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab.dart';
import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/artists_tab/artists_tab.dart';
import 'package:flatter/home/library_screen/library_tab_bar/artists_tab/artists_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/folders_tab.dart';
import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/folders_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/playlists_tab/playlists_tab.dart';
import 'package:flatter/home/library_screen/library_tab_bar/playlists_tab/playlists_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/songs_tab/songs_tab.dart';
import 'package:flatter/home/library_screen/library_tab_bar/songs_tab/songs_tab_viewModel.dart';
import 'package:flatter/home/search_screen/search_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

import '../../../settings/settings_screen.dart';
import '../../../settings/settings_screen_ViewModel.dart';

class LibraryTabBar extends StatelessWidget {
  const LibraryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    int startTab = settingsControl.settingsMap['libraryTab'];
    if (startTab == -1) {
      startTab = settingsControl.settingsMap['lastLibraryTab'];
    }
//    final FoldersTabViewModel foldersTabViewModel = FoldersTabViewModel();
  //TODO:du brauchst noch einen tab nur zum suchen hier in dem man nach allem suchen kann//entweder macht das der suchen tab schon, oder ich weiß aktuell nicht was ich hier gemeint habe
    final PlaylistsTabViewModel playlistsTabViewModel = PlaylistsTabViewModel();
    final SongsTabViewModel songsTabViewModel = SongsTabViewModel();
    final AlbumsTabViewModel albumsTabViewModel = AlbumsTabViewModel();
    final ArtistsTabViewModel artistsTabViewModel = ArtistsTabViewModel();
    return DefaultTabController(
      initialIndex: startTab,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Library"),
          actions: [//im offline/local folder mode noch einen sync button
            if (settingsControl.loadSetting('landscapeMode') == false) IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(viewModel: SettingsScreenViewmodel())));
                },
                icon: Icon(Icons.settings)
            ),
            if (settingsControl.loadSetting('landscapeMode') == false) IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(Icons.search),
            )
          ],
          bottom: const TabBar(
            tabs: [
              //Tab(icon: Icon(Icons.folder_copy),),
              Tab(icon: Icon(Icons.queue_music),),
              Tab(icon: Icon(Icons.music_note),),
              Tab(icon: Icon(Icons.album),),
              Tab(icon: Icon(Icons.person),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //FoldersTab(viewModel: foldersTabViewModel),
            PlaylistsTab(viewModel: playlistsTabViewModel),
            SongsTab(viewModel: songsTabViewModel),
            AlbumsTab(viewModel: albumsTabViewModel),
            ArtistsTab(viewModel: artistsTabViewModel),
          ],
        ),
      ),

    );
  }
}