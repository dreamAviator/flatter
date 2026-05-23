import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/edit_playlist_popup.dart';
import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/playlists_tab/playlists_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/playlist_screen/playlist_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../../../Riverpod/riverpod_manager.dart';
import '../../itemMenus.dart';

class PlaylistsTab extends StatefulWidget {
  const PlaylistsTab({super.key,required this.viewModel});
  final PlaylistsTabViewModel viewModel;

  @override
  State<PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {
  String type = "random";
  bool ascending = true;
  int elementCount = 10;
  int offset = 0;
  List<String> filterSortList = ["random","50","0","ASC"];

  void reverseSort() {
    if (ascending == true) {
      setState(() {
        filterSortList = [type,elementCount.toString(),offset.toString(),"DESC"];
        ascending = false;
      });
    } else {
      setState(() {
        filterSortList = [type,elementCount.toString(),offset.toString(),"ASC"];
        ascending = true;
      });
    }
  }

  Widget buildListView(List<dynamic> items,BuildContext context,double screenWidth) {
    List<Widget> widgetList = [];
    List<Widget> widgetListTwo = [];
    int index = 0;
    while (index < items.length) {
      Map playlist = items[index];
      if (playlist['owner'] == databaseControl.getCurrentUsername()) {
        widgetList.add(
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print("playlost tapped");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistScreen(playlistID: playlist['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(
                          null, null, null)[0]}getCoverArt${subsonicService
                          .getURL(
                          null, null, null)[1]}&id=${playlist['coverArt']}",
                      progressIndicatorBuilder: (context, url,
                          downloadProgress) =>
                          LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                      errorWidget: (context, url, error) =>
                          IconButton(
                            onPressed: () {
                              //hier retry
                            },
                            icon: Icon(Icons.error),
                          ),
                    ),
                  ),
                  ListTile(
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['songCount'].toString()),
                    trailing: ItemMenus(context).playlistMenuList(playlist),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      index = index + 1;
    }
    index = 0;
    while (index < items.length) {
      Map playlist = items[index];
      if (playlist['owner'] != databaseControl.getCurrentUsername()) {
        widgetListTwo.add(
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print("playlist tabbed");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistScreen(playlistID: playlist['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(
                          null, null, null)[0]}getCoverArt${subsonicService
                          .getURL(
                          null, null, null)[1]}&id=${playlist['coverArt']}",
                      progressIndicatorBuilder: (context, url,
                          downloadProgress) =>
                          LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                      errorWidget: (context, url, error) =>
                          IconButton(
                            onPressed: () {
                              //hier retry
                            },
                            icon: Icon(Icons.error),
                          ),
                    ),
                  ),
                  ListTile(
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['owner']),
                    trailing: ItemMenus(context).playlistMenuList(playlist),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      index = index + 1;
    }
    return Expanded(child: SingleChildScrollView(child: Column(
      children: [
        MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList,),
        Divider(),
        Text("Public"),
        MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetListTwo,),
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    final Size screenSize = MediaQuery.sizeOf(context);
    return Consumer(
      builder: (context, ref, child) {
        final playlistList = ref.watch(riverpodManager.playlistListProvider);
        return Column(
          children: [
            Row(
              children: [
                Text("hier suchleiste und filter stuff"),
                IconButton.filled(
                  onPressed: () {
                    EditPlaylistPopup.showEditPlaylistPopUp(context, true, null, null, null, null, null);
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
            Row(
              children: [
                Text("hier drop down menü"),
                IconButton(
                  onPressed: () {
                    reverseSort();
                    ref.invalidate(riverpodManager.playlistListProvider);
                  },
                  icon: (ascending
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward)),
                )
              ],
            ),
            Expanded(
              child: switch (playlistList) {
                AsyncValue(:final value?) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(riverpodManager.playlistListProvider);
                        print('value');
                        print(value);
                      },
                      child: Text("invalidate"),
                    ),
                    buildListView(value,context,screenSize.width),
                  ],
                ),
                AsyncValue(error: != null) => Center(child: const Text("Error")),
                AsyncValue() => Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)),
              },
            ),
          ],
        );
      },
    );
  }
}