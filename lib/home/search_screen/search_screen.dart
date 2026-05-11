import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/song_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../main.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    final Size screenSize = MediaQuery.sizeOf(context);
    List<dynamic> searchParams = ["",0,0,0];
    TextEditingController searchFieldController = TextEditingController();

    void search(String value,WidgetRef ref) {
      print(value);
      searchParams = [searchFieldController.text,0,0,0];
      ref.invalidate(riverpodManager.searchProvider);
    }

    Widget buildSearchResultsColumn(BuildContext context,Map<dynamic,dynamic> searchResults) {//einstellen, in welcher reihenfolge die kategorien angezeigt werden sollen//kategorien expandable machen//nur die anzahl der reihen, nicht der elemente einstellen
      List<Widget> widgetList = [];
      if (searchResults['artist'] != null) {
        widgetList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Artists"),
          ElevatedButton(
            onPressed: () {
              //zum albumscreen gehen
            },
            child: Row(
              children: [
                Text("Show all"),
                Icon(Icons.arrow_forward),
              ],
            ),
          )
        ],
      ));
        widgetList.add(Divider());
        List<Widget> artistWidgetList = [];
        for (Map<dynamic,dynamic> artist in searchResults['artist']) {
          artistWidgetList.add(
              Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artist['id'])));
                  },
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${artist['coverArt']}",
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                          errorWidget: (context, url, error) => IconButton(
                            onPressed: () {
                              //hier retry
                            },
                            icon: Icon(Icons.error),
                          ),
                        ),
                      ),
                      Text(artist['name']),
                      Text(artist['id']),
                    ],
                  ),
                ),
              )
          );
        }
        widgetList.add(MasonryGrid(column: (screenSize.width / 175).toInt(),children: artistWidgetList,));
      }
      if (searchResults['album'] != null) {
        widgetList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Albums"),
            ElevatedButton(
              onPressed: () {
                //zum albumscreen gehen
              },
              child: Row(
                children: [
                  Text("Show all"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            )
          ],
        ));
        List<Widget> albumWidgetList = [];
        for (Map<dynamic,dynamic> album in searchResults['album']) {
          albumWidgetList.add(
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
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                          errorWidget: (context, url, error) => IconButton(
                            onPressed: () {
                              //hier retry
                            },
                            icon: Icon(Icons.error),
                          ),
                        ),
                      ),
                      Text(album['name']),
                      Text(album['artist']),
                    ],
                  ),
                ),
              )
          );
        }
        widgetList.add(MasonryGrid(column: (screenSize.width / 175).toInt(),children: albumWidgetList,));
      }
      if (searchResults['song'] != null) {//vlt eine einstellung machen, dass welches der suchelemente auch immer als letztes ist, dass das eine unendlich lang scrollbare liste wird
        widgetList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Songs"),
            ElevatedButton(
              onPressed: () {
                //zum albumscreen gehen
              },
              child: Row(
                children: [
                  Text("Show all"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            )
          ],
        ));
        widgetList.add(SongList(songListNullable: searchResults['song'], listView: false));
      }
      return SingleChildScrollView(child: Column(children: widgetList,),);
    }
    //auch hier muss es doch eigentlich eine einfachere version geben, ohne dieses große if statement, naja egal
    if (settingsControl.loadSetting('landscapeMode') == true) {
      return Scaffold(//eine zweite version so machen mit dem zurück knopf
          appBar: AppBar(
            title: Consumer(builder: (context, ref, child) { return TextField(
              controller: searchFieldController,
              decoration: const InputDecoration(
                  hintText: "Search"
              ),
              onChanged: (String value) {
                search(value,ref);
              },
              autofocus: true,
              //hmm
            ); },),
            actions: [
              IconButton(
                icon: Icon(Icons.backspace),
                onPressed: () {
                  searchFieldController.clear();
                },
              )
            ],
          ),
          body: Consumer(
            builder: (context,ref,child) {
              final searchResults = ref.watch(riverpodManager.searchProvider(searchParams));
              return Container(
                child: switch (searchResults) {
                  AsyncValue(:final value?) => buildSearchResultsColumn(context,value),
                  AsyncValue(error: != null) => const Text("error"),
                  AsyncValue() => Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)),
                },
              );
            },
          )
      );
    } else {
      return Scaffold(//eine zweite version so machen mit dem zurück knopf
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Consumer(builder: (context, ref, child) { return TextField(
              controller: searchFieldController,
              decoration: const InputDecoration(
                  hintText: "Search"
              ),
              onChanged: (String value) {
                search(value,ref);
              },
            ); },),
            actions: [
              Consumer(builder: (context, ref, child) { return IconButton(
                icon: Icon(Icons.backspace),
                onPressed: () {
                  searchFieldController.clear();
                  search("", ref);
                },
              ); },)
            ],
          ),
          body: Consumer(
            builder: (context,ref,child) {
              final searchResults = ref.watch(riverpodManager.searchProvider(searchParams));
              return Container(
                child: switch (searchResults) {
                  AsyncValue(:final value?) => buildSearchResultsColumn(context,value),
                  AsyncValue(error: != null) => const Text("error"),
                  AsyncValue() => Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)),
                },
              );
            },
          )
      );
    }
  }
}