import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/item_widgets/album_grid.dart';
import 'package:flatter/home/item_widgets/artist_grid.dart';
import 'package:flatter/home/item_widgets/playlist_grid.dart';
import 'package:flatter/home/item_widgets/song_list.dart';
import 'package:flatter/home/search_screen/search_album_screen.dart';
import 'package:flatter/home/search_screen/search_artist_screen.dart';
import 'package:flatter/home/search_screen/search_playlist_screen.dart';
import 'package:flatter/home/search_screen/search_song_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../main.dart';

TextEditingController searchFieldController = TextEditingController();

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    final Size screenSize = MediaQuery.sizeOf(context);
    List<dynamic> searchParams = ["",0,0,0];
    String query = "";
    int artistOffset = 0;
    int albumOffset = 0;
    int songOffset = 0;
    int playlistOffset = 0;

    if (searchFieldController.text != "") {
      setState(() {
        query = searchFieldController.text;
      });
    }

    /*
    Widget buildSearchResultsColumn(BuildContext context,Map<dynamic,dynamic> searchResults) {//einstellen, in welcher reihenfolge die kategorien angezeigt werden sollen//kategorien expandable machen//nur die anzahl der reihen, nicht der elemente einstellen
      /*
      List<Widget> widgetList = [];
      if (searchResults['artist'] != null) {
        widgetList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Artists"),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchArtistScreen(query: searchFieldController.text)));
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchAlbumScreen(query: searchFieldController.text)));
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchSongScreen(query: searchFieldController.text)));
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
        widgetList.add(SongList(songListNullable: searchResults['song'], listView: false,sliver: false));
      }
      return SingleChildScrollView(child: Column(children: widgetList,),);

       */
      return CustomScrollView(
        slivers: [
          if (searchResults['artist'] != null)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Artists"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchArtistScreen(query: searchFieldController.text)));
                        },
                        child: const Row(
                          children: [
                            Text("Show all"),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          ArtistGrid(artistListNullable: searchResults['artist'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: true,withIndexesGiven: false,),
          if (searchResults['album'] != null)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Albums"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchAlbumScreen(query: searchFieldController.text)));
                        },
                        child: const Row(
                          children: [
                            Text("Show all"),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          AlbumGrid(albumListNullable: searchResults['album'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: true),
          if (searchResults['song'] != null)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Songs"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchSongScreen(query: searchFieldController.text)));
                        },
                        child: const Row(
                          children: [
                            Text("Show all"),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          SongList(songListNullable: searchResults['song'], listView: true, sliver: true,playlistID: null,),
        ],
      );
    }

     */
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
              setState(() {
                query = value;
              });
            },
            autofocus: true,
            onSubmitted: (String value) {
              setState(() {
                query = value;
              });
            },
            //hmm
          ); },),
          actions: [
            IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () {
                searchFieldController.clear();
              },
            )
          ],
        ),
        body: SearchScreenBody(query: query, artistOffset: artistOffset, albumOffset: albumOffset, songOffset: songOffset, playlistOffset: playlistOffset),
      );
    } else {
      return Scaffold(//eine zweite version so machen mit dem zurück knopf
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (settingsControl.loadSetting('clearSearchOnExit') == true) {
                searchFieldController.clear();//TODO:das hier auch im landscape mode hinkriegen
              }
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Consumer(builder: (context, ref, child) { return TextField(
            controller: searchFieldController,
            decoration: const InputDecoration(
                hintText: "Search"
            ),
            onChanged: (String value) {
              setState(() {
                query = value;
              });
            },
          ); },),
          actions: [
            Consumer(builder: (context, ref, child) { return IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () {
                searchFieldController.clear();
                setState(() {
                  query = "";
                });
              },
            ); },)
          ],
        ),
        body: SearchScreenBody(query: query, artistOffset: artistOffset, albumOffset: albumOffset, songOffset: songOffset, playlistOffset: playlistOffset),
      );
    }
  }
}

class SearchScreenBody extends StatelessWidget {
  const SearchScreenBody({super.key,required this.query,required this.artistOffset,required this.albumOffset,required this.songOffset,required this.playlistOffset});
  final String query;
  final int artistOffset;
  final int albumOffset;
  final int songOffset;
  final int playlistOffset;

  Widget buildSearchResultsColumn(BuildContext context,Map<dynamic,dynamic> searchResults) {//einstellen, in welcher reihenfolge die kategorien angezeigt werden sollen//kategorien expandable machen//nur die anzahl der reihen, nicht der elemente einstellen
    final Size screenSize = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        if (searchResults['artist'] != null)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Artists"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchArtistScreen(query: searchFieldController.text)));
                      },
                      child: const Row(
                        children: [
                          Text("Show all"),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ArtistGrid(artistListNullable: searchResults['artist'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: true,withIndexesGiven: false,),
        if (searchResults['album'] != null)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Albums"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchAlbumScreen(query: searchFieldController.text)));
                      },
                      child: const Row(
                        children: [
                          Text("Show all"),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        AlbumGrid(albumListNullable: searchResults['album'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: true),
        if (searchResults['song'] != null)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Songs"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchSongScreen(query: searchFieldController.text)));
                      },
                      child: const Row(
                        children: [
                          Text("Show all"),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        SongList(songListNullable: searchResults['song'], listView: true, sliver: true,playlistID: null,),
        if (searchResults['playlist'] != null)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Playlists"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPlaylistScreen(query: searchFieldController.text)));
                      },
                      child: const Row(
                        children: [
                          Text("Show all"),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        PlaylistGrid(playlistListNullable: searchResults['playlist'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: true),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    SubsonicService subsonicService = SubsonicService();

    return FutureBuilder(
      future: subsonicService.search(query, artistOffset, albumOffset, songOffset,playlistOffset),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done && asyncSnapshot.data != null) {
          return buildSearchResultsColumn(context,asyncSnapshot.data!);
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text("Error"));
        } else {
          return Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),);
        }
      }
    );
  }
}