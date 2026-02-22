import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab_ViewModel.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'artists_tab_ViewModel.dart';

class ArtistsTab extends StatelessWidget {
  const ArtistsTab({super.key,required this.viewModel});
  final ArtistsTabViewModel viewModel;

  Widget buildListView(List<dynamic> items,BuildContext context) {
    List<Widget> widgetList = [];
    print(items.length);
    int index = 0;
    while (index < items.length) {
      Map albumOne = items[index];
      Map albumTwo = items[index + 1];
      widgetList.add(
        Row(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumOne['id'])));
                },
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumOne['coverArt']}&size=100",
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => IconButton(
                        onPressed: () {
                          //hier retry
                        },
                        icon: Icon(Icons.error),
                      ),
                    ),
                    Text(albumOne['name']),
                    Text(albumOne['id'])
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumTwo['id'])));
                },
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumTwo['coverArt']}&size=100",
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => IconButton(
                        onPressed: () {
                          //hier retry
                        },
                        icon: Icon(Icons.error),
                      ),
                    ),
                    Text(albumTwo['name']),
                    Text(albumTwo['artist']),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      index = index + 2;
    }
    return ListView(shrinkWrap: true,children: widgetList,);
  }
  //hier irgendwie ein filtering einfügen
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("uh"),
          subtitle: Text("hier sorting stuff und so, probably nd im listtile"),
        ),
        Consumer(
          builder: (context,ref,child) {
            final artistList = ref.watch(riverpodManager.artistListProvider);
            return Center(
              child: switch (artistList) {
                AsyncValue(:final value?) => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(riverpodManager.albumListProvider);
                      },
                      child: Text("invalidate"),
                    ),
                    buildListView(value,context),
                  ],
                ),
                AsyncValue(error: != null) => const Text("Error"),
                AsyncValue() => const CircularProgressIndicator(),
              },
            );
          },
        )
      ],
    );
  }
}