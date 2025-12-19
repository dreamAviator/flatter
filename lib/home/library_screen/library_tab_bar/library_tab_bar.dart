import 'package:flatter/Repositories/queue_repository.dart';
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
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryTabBar extends StatelessWidget {
  const LibraryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final FoldersTabViewModel foldersTabViewModel = FoldersTabViewModel();
    final PlaylistsTabViewModel playlistsTabViewModel = PlaylistsTabViewModel();
    final SongsTabViewModel songsTabViewModel = SongsTabViewModel();
    final AlbumsTabViewModel albumsTabViewModel = AlbumsTabViewModel();
    final ArtistsTabViewModel artistsTabViewModel = ArtistsTabViewModel();
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Library"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.folder_copy),),
              Tab(icon: Icon(Icons.queue_music),),
              Tab(icon: Icon(Icons.music_note),),
              Tab(icon: Icon(Icons.album),),
              Tab(icon: Icon(Icons.person),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FoldersTab(viewModel: foldersTabViewModel),
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