import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../../main.dart';
import '../library_screen/album_screen/album_screen.dart';
import '../library_screen/itemMenus.dart';

class SearchAlbumScreen extends StatelessWidget {
  const SearchAlbumScreen({super.key,required this.query});

  final String query;

  Widget buildAlbumGrid(BuildContext context,List<dynamic>? albumsNullable,double screenWidth) {
    //hier halt das gridview, evt aus diesen imagecards
    //idk ob gridview.builder der call ist oder besser gesagt wann das nicht der call ist :shrug:
    List<dynamic> albums = [];
    if (albumsNullable == null || albumsNullable.isEmpty) {
      return Text("No albums");
    }
    for (var value in albumsNullable) {
      albums.add(value);
    }
    List<Widget> widgetList = [];
    for (Map<dynamic,dynamic> album in albums) {
      widgetList.add(
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: album['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${album['coverArt']}",
                      progressIndicatorBuilder: (context, url, downloadProgress) => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                      errorWidget: (context,url,error) => IconButton(
                        onPressed: () {
                          //hier retry
                        },
                        icon: Icon(Icons.error),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(album['name']),
                    subtitle: Text("Song count: ${album['songCount']}"),
                    trailing: ItemMenus(context).albumMenuList(album),
                  ),
                ],
              ),
            ),
          )
      );
    }
    return MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    RiverpodManager riverpodManager = RiverpodManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text("All albums"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer(
        builder: (context,ref,child) {
          final fullSearchResults = ref.watch(riverpodManager.fullSearchProvider(query));
          return switch (fullSearchResults) {
            AsyncValue(:final value?) => SingleChildScrollView(child: buildAlbumGrid(context, value['album'], screenSize.width)),
            AsyncValue(error: != null) => Text("error"),
            AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
          };
        },
      ),
    );
  }
}