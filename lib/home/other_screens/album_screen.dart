
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/other_screens/artist_screen.dart';
import 'package:flatter/home/item_widgets/favorite_button.dart';
import 'package:flatter/home/item_widgets/item_menus.dart';
import 'package:flatter/home/item_widgets/song_list.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AlbumScreen extends StatefulWidget {//TODO:mehr infos anzeigen
  const AlbumScreen({super.key,required this.albumID});
  final String albumID;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  SubsonicService subsonicService = SubsonicService();

  @override
  Widget build(BuildContext context) {
    final usefulScripts = SubsonicJustAudioCompatibility();
    ItemMenus itemMenus = ItemMenus(context);
    final Size screenSize = MediaQuery.sizeOf(context);
    final filterNotifier = ValueNotifier<String>('');
    final PageController pageController = PageController();

    return FutureBuilder(
      future: subsonicService.getAlbumDetails(widget.albumID),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          List<dynamic>? subsonicSongList = asyncSnapshot.data!['song'];
          List<MediaItem> songList = usefulScripts.subsonicSongListToMediaItemList(subsonicSongList ?? []);

          void playNow() {
            playerControl.customAction('clearQueue');
            playerControl.customAction('addMultiple',{'addMultiple': {
              'tracks':songList,
            }});
          }
          void playNext() {
            playerControl.customAction('addNext',{'addNext': {
              'tracks':songList,
            }});
          }
          void enqueue() {
            playerControl.customAction('addMultiple',{'addMultiple': {
              'tracks':songList,
            }});
          }
          void playNowShuffled() {
            playerControl.customAction('clearQueue');
            playerControl.customAction('addMultiple',{'addMultiple': {
              'tracks':songList,
              'shuffled':true,
            }});
          }
          void playNextShuffled() {
            playerControl.customAction('addNext',{'addNext': {
              'tracks':songList,
              'shuffled':true,
            }});
          }
          void enqueueShuffled() {
            playerControl.customAction('addMultiple',{'addMultiple': {
              'tracks':songList,
              'shuffled':true,
            }});
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(asyncSnapshot.data!['name']),
              actions: [//TODO:(bei den anderen screens auch) evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
                IconButton(
                  onPressed: () {
                    String action = settingsControl.settingsMap['albumPlayButtonAction'];
                    switch (action) {
                      case "playNow":
                        playNow();
                      case "playNext":
                        playNext();
                      case "enqueue":
                        enqueue();
                      case "playNowShuffled":
                        playNowShuffled();
                      case "playNextShuffled":
                        playNextShuffled();
                      case "enqueueShuffled":
                        enqueueShuffled();
                    }
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                FavoriteButton(songID: null, albumID: widget.albumID, artistID: null),
                itemMenus.albumMenu(asyncSnapshot.data!),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [//evt einige actions von den actions hier nach oben oder so mal schauen wie du das strukturieren willst
                      //hier evt einen text von nem anderen server fetchen idk ob das bei alben geht
                      if (settingsControl.settingsMap['landscapeMode'] == false) AspectRatio(
                        aspectRatio: 1,
                        child: PageView(
                          scrollBehavior: MaterialScrollBehavior().copyWith(
                            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.trackpad, PointerDeviceKind.unknown},
                          ),
                          controller: pageController,
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${asyncSnapshot.data!['coverArt']}",
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                                  errorWidget: (context, url, error) => IconButton(
                                    onPressed: () {
                                      //hier retry
                                    },
                                    icon: Icon(Icons.error),
                                  ),
                                  height: screenSize.width,
                                ),
                                IconButton(
                                  onPressed: () {
                                    pageController.jumpToPage(1);
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Center(
                                  child: FutureBuilder(
                                    future: subsonicService.getArtistDetails(asyncSnapshot.data!['artistId']),
                                    builder: (context, innerAsyncSnapshot) {
                                      if (innerAsyncSnapshot.hasData && innerAsyncSnapshot.connectionState == ConnectionState.done) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(//row to allow for more data in the future
                                                children: [
                                                  Text(innerAsyncSnapshot.data!['name'] ?? "Unknown"),
                                                ],
                                              ),
                                              Divider(),
                                              Expanded(
                                                child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    print("building image");
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        spacing: 8,
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${innerAsyncSnapshot.data!['coverArt']}",
                                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                                                            errorWidget: (context, url, error) => IconButton(
                                                              onPressed: () {
                                                                //hier retry
                                                              },
                                                              icon: Icon(Icons.error),
                                                            ),
                                                            width: (constraints.maxWidth / 3 * 2),
                                                            height: (constraints.maxWidth / 3 * 2),
                                                          ),
                                                          Text(innerAsyncSnapshot.data!['biography'] ?? "No biography"),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (innerAsyncSnapshot.hasError) {
                                        return Text("Error");
                                      } else {
                                        return LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25);
                                      }
                                    }
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    pageController.jumpToPage(0);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_new),
                                ),
                              ]
                            )
                          ],
                        ),
                      ),
                      if (settingsControl.settingsMap['landscapeMode'] == false) TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: asyncSnapshot.data!['artistId'])));
                        },
                        child: Text(asyncSnapshot.data!['artist']),
                      ),
                      if (settingsControl.settingsMap['landscapeMode'] == false) Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(//TODO:hier auch einstellen lassen was angezeigt wird und in welcher reihenfolge
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 8,
                              children: [//TODO:einstellung um die zu iconbuttons zu machen
                                ElevatedButton(
                                  child: Text("Play now"),
                                  onPressed: () {
                                    playNow();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Play now shuffled"),
                                  onPressed: () {
                                    playNowShuffled();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Add next"),
                                  onPressed: () {playNext();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Add next shuffled"),
                                  onPressed: () {
                                    playNextShuffled();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Enqueue"),
                                  onPressed: () {
                                    enqueue();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Enqueue shuffled"),
                                  onPressed: () {
                                    enqueueShuffled();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (settingsControl.settingsMap['landscapeMode'] == true) SizedBox(
                        height: screenSize.width / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 8,
                          children: [
                            CachedNetworkImage(
                              imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${asyncSnapshot.data!['coverArt']}",
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                              errorWidget: (context, url, error) => IconButton(
                                onPressed: () {
                                  //hier retry
                                },
                                icon: Icon(Icons.error),
                              ),
                              width: screenSize.width / 3,
                              height: screenSize.width / 3,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    spacing: 8,
                                    children: [
                                      ElevatedButton(
                                        child: Text("Play now"),
                                        onPressed: () {
                                          playNow();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Play now shuffled"),
                                        onPressed: () {
                                          playNowShuffled();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Add next"),
                                        onPressed: () {
                                          playNext();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Add next shuffled"),
                                        onPressed: () {
                                          playNextShuffled();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Enqueue"),
                                        onPressed: () {
                                          enqueue();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Enqueue shuffled"),
                                        onPressed: () {
                                          enqueueShuffled();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: asyncSnapshot.data?['artistId'],)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FutureBuilder(
                                        future: subsonicService.getArtistDetails(asyncSnapshot.data!['artistId']),
                                        builder: (context, innerAsyncSnapshot) {
                                          if (innerAsyncSnapshot.hasData && innerAsyncSnapshot.connectionState == ConnectionState.done) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  child: Text(innerAsyncSnapshot.data?['name'] ?? "Unknown"),
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: asyncSnapshot.data?['artistId'],)));
                                                  },
                                                ),
                                                Divider(),
                                                Expanded(
                                                  child: Row(
                                                    spacing: 8,
                                                    children: [
                                                      Expanded(
                                                        child: LayoutBuilder(
                                                          builder: (BuildContext context, BoxConstraints constraints) {
                                                            return CachedNetworkImage(
                                                              imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${innerAsyncSnapshot.data!['coverArt']}",
                                                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                  LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                                                              errorWidget: (context, url, error) => IconButton(
                                                                onPressed: () {
                                                                  //hier retry
                                                                },
                                                                icon: Icon(Icons.error),
                                                              ),
                                                              width: constraints.maxHeight,
                                                              height: constraints.maxHeight,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Divider(),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.vertical,
                                                          child: Text(innerAsyncSnapshot.data!['biography'] ?? "No biography"),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          } else if (innerAsyncSnapshot.hasError) {
                                            return Center(
                                              child: Text("Error"),
                                            );
                                          } else {
                                            return Center(
                                              child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                                            );
                                          }
                                        }
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 24,
                          children: [
                            if ((asyncSnapshot.data!['song'] as List).length == 1) Text(
                              "${(asyncSnapshot.data!['song'] as List).length} track"
                            ) else Text(
                                "${(asyncSnapshot.data!['song'] as List).length} tracks"
                            ),
                            Text((asyncSnapshot.data!['year'] ?? "").toString()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SongList(songListNullable: asyncSnapshot.data!['song'],listView: true,sliver: true,filterNotifier: filterNotifier,playlistID: null,),
              ],
            ),
          );
        } else if (asyncSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(child: Text("Error"),),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            ),
            body: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),),
          );
        }
      }
    );
  }
}

//old singlechildscrollview
/*
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [//evt einige actions von den actions hier nach oben oder so mal schauen wie du das strukturieren willst
                    //hier evt einen text von nem anderen server fetchen idk ob das bei alben geht
                    if (settingsControl.settingsMap['landscapeMode'] == false) switch (albumDetails) {
                      AsyncValue(:final value?) => CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${value['coverArt']}",
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        errorWidget: (context, url, error) => IconButton(
                          onPressed: () {
                            //hier retry
                          },
                          icon: Icon(Icons.error),
                        ),
                        height: screenSize.width,
                      ),
                      AsyncValue(error: != null) => Text("Error"),
                      AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    },
                    if (settingsControl.settingsMap['landscapeMode'] == false) switch (albumDetails) {
                      AsyncValue(:final value?) => TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: value['artistId'])));
                        },
                        child: Text(value['artist']),
                      ),
                      AsyncValue(error: != null) => Text("Error"),
                      AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    },
                    if (settingsControl.settingsMap['landscapeMode'] == false) Row(
                      children: [
                        //also ja hier actions
                        //diese diablen bis ergebnis da ist
                        Text("hier sollen actions hin")
                      ],
                    ),
                    if (settingsControl.settingsMap['landscapeMode'] == true) Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        switch (albumDetails) {
                          AsyncValue(:final value?) => CachedNetworkImage(
                            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${value['coverArt']}",
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                            errorWidget: (context, url, error) => IconButton(
                              onPressed: () {
                                //hier retry
                              },
                              icon: Icon(Icons.error),
                            ),
                            width: screenSize.width / 3,
                            height: screenSize.width / 3,
                          ),
                          AsyncValue(error: != null) => Text("Error"),
                          AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        },
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("hier"),
                              Text("sollen"),
                              Text("actions"),
                              Text("hin"),
                            ],
                          ),
                        )
                      ],
                    ),
                    switch (albumDetails) {
                      AsyncValue(:final value?) => SongList(songListNullable: value['song'],listView: false,),
                      AsyncValue(error: != null) => Text("Error"),
                      AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    },
                  ],
                ),
              ),

               */