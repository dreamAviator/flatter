import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab_ViewModel.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../itemMenus.dart';

class AlbumsTab extends StatefulWidget {
  const AlbumsTab({super.key,required this.viewModel});
  final AlbumsTabViewModel viewModel;

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
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
    int index = 0;
    while (index < items.length) {
      Map albumOne = items[index];
      widgetList.add(
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumOne['id'])));
            },
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumOne['coverArt']}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => IconButton(
                    onPressed: () {
                      //hier retry
                    },
                    icon: Icon(Icons.error),
                  ),
                ),
                ListTile(
                  title: Text(albumOne['name']),
                  subtitle: Text(albumOne['artist']),
                  trailing: ItemMenus(context).albumMenu2(albumOne['id'], albumOne['artistId']),
                ),
              ],
            ),
          ),
        ),
      );
      index = index + 1;
    }
    return Expanded(child: SingleChildScrollView(child: MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList,)));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final albumList = ref.watch(riverpodManager.albumListProvider(filterSortList));
          return Column(
            children: [
              ListTile(
                title: Text("uh"),
                subtitle: Text("hier suchleiste und filter stuff"),
              ),
              Row(
                children: [
                  Text("hier drop down menü"),
                  IconButton(
                    onPressed: () {
                      reverseSort();
                      ref.invalidate(riverpodManager.albumListProvider);
                    },
                    icon: (ascending
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward)),
                  )
                ],
              ),
              Expanded(
                child: switch (albumList) {
                  AsyncValue(:final value?) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(riverpodManager.albumListProvider);
                        },
                        child: Text("invalidate"),
                      ),
                      buildListView(value,context,screenSize.width),
                    ],
                  ),
                  AsyncValue(error: != null) => Center(child: const Text("Error")),
                  AsyncValue() => Center(child: const CircularProgressIndicator()),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}