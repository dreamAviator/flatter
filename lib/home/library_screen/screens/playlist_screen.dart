import 'dart:io';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/library_screen/screens/artist_screen.dart';
import 'package:flatter/home/library_screen/popups/artist_select_popup.dart';
import 'package:flatter/home/library_screen/popups/edit_playlist_popup.dart';
import 'package:flatter/home/library_screen/item_widgets/per_item/item_menus.dart';
import 'package:flatter/home/library_screen/item_widgets/song_list.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marqueer/marqueer.dart';

import '../../../Riverpod/riverpod_manager.dart';
import '../../../useful_scripts.dart';
import 'album_screen.dart';
import '../filter_widgets/search_string_filter_widget.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key,required this.playlistID,this.playlistChangedNotifier});
  final String playlistID;
  final UpdateNotifier? playlistChangedNotifier;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  SubsonicService subsonicService = SubsonicService();

  @override
  Widget build(BuildContext context) {
    final usefulScripts = SubsonicJustAudioCompatibility();
    ItemMenus itemMenus = ItemMenus(context);
    final Size screenSize = MediaQuery.sizeOf(context);
    final filterNotifier = ValueNotifier<String>('');
    final PageController pageController = PageController();
    late UpdateNotifier playlistChangedNotifier;
    if (widget.playlistChangedNotifier != null) {
      playlistChangedNotifier = widget.playlistChangedNotifier!;
    } else {
      playlistChangedNotifier = UpdateNotifier();
    }
    return ListenableBuilder(
      listenable: playlistChangedNotifier,
      builder: (context, child) {
        return FutureBuilder(
          future: subsonicService.getPlaylistDetails(widget.playlistID),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Marqueer(intrinsicCrossAxisSize: true,infinity: false,child: Text(asyncSnapshot.data!['name']),),
                  actions: [
                    IconButton(
                      onPressed: () {
                        String action = settingsControl.settingsMap['playlistPlayButtonAction'];
                        List<dynamic>? subsonicSongList = asyncSnapshot.data!['entry'];
                        if (subsonicSongList == null) {
                          return;
                        }
                        List<MediaItem> songList = usefulScripts.subsonicSongListToMediaItemList(subsonicSongList);
                        switch (action) {
                          case "playNow":
                            playerControl.customAction('clearQueue');
                            playerControl.customAction('addMultiple',{'addMultiple': {
                              'tracks':songList,
                            }});
                          case "playNext":
                            playerControl.customAction('addNext',{'addNext': {
                              'tracks':songList,
                            }});
                          case "enqueue":
                            playerControl.customAction('addMultiple',{'addMultiple': {
                              'tracks':songList,
                            }});
                          case "playNowShuffled":
                            playerControl.customAction('clearQueue');
                            playerControl.customAction('addMultiple',{'addMultiple': {
                              'tracks':songList,
                              'shuffled':true,
                            }});
                          case "playNextShuffled":
                            playerControl.customAction('addNext',{'addNext': {
                              'tracks':songList,
                              'shuffled':true,
                            }});
                          case "enqueueShuffled":
                            playerControl.customAction('addMultiple',{'addMultiple': {
                              'tracks':songList,
                              'shuffled':true,
                            }});
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                    ),
                    if (asyncSnapshot.data!['owner'] == databaseControl.getCurrentUsername()) IconButton(
                      onPressed: () {
                        //hier bearbeiten
                        //wär babo wenn du das nur anzeigen würdest, wenn du der owner bist
                        EditPlaylistPopup.showEditPlaylistPopUp(context, false, asyncSnapshot.data!['id'], asyncSnapshot.data!['name'], asyncSnapshot.data!['comment'], asyncSnapshot.data!['public'],null,playlistChangedNotifier);
                      },
                      icon: const Icon(Icons.edit),//probably damit sich das ändert hier ein eigenes widget bauen
                    ),
                    itemMenus.playlistMenu(asyncSnapshot.data!),
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
                                          icon: const Icon(Icons.error),
                                        ),
                                        height: screenSize.width,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          pageController.jumpToPage(1);
                                        },
                                        icon: const Icon(Icons.arrow_forward_ios),
                                        color: Colors.white,//TODO:die Farbe hier dynamisch auswählen
                                      ),
                                    ]
                                ),
                                if (asyncSnapshot.data!['comment'] == "")
                                  Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Center(
                                          child: const Text("No comment"),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            pageController.jumpToPage(0);
                                          },
                                          icon: const Icon(Icons.arrow_back_ios_new),
                                        ),
                                      ]
                                  )
                                else
                                  Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Center(
                                          child: SingleChildScrollView(child: Text(asyncSnapshot.data!['comment']),),
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
                            child: Text(asyncSnapshot.data!['owner']),
                          ),
                          if (settingsControl.settingsMap['landscapeMode'] == false) Row(
                            children: [
                              //also ja hier actions
                              //diese diablen bis ergebnis da ist
                              Text("hier sollen actions hin")
                            ],
                          ),
                          if (settingsControl.settingsMap['landscapeMode'] == true) Container(
                            height: screenSize.width / 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(asyncSnapshot.data!['comment']),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(child: SearchStringFilterWidget(filterNotifier: filterNotifier),),
                    SongList(songListNullable: asyncSnapshot.data!['entry'],listView: true,sliver: true,filterNotifier: filterNotifier,playlistID: asyncSnapshot.data!['id'],),
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
                    if (settingsControl.settingsMap['landscapeMode'] == false) switch (playlistDetails) {
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
                    if (settingsControl.settingsMap['landscapeMode'] == false) switch (playlistDetails) {
                      AsyncValue(:final value?) => TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: value['artistId'])));
                        },
                        child: Text(value['owner']),
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
                    if (settingsControl.settingsMap['landscapeMode'] == true) Container(
                      height: screenSize.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          switch (playlistDetails) {
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
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: switch (playlistDetails) {
                                AsyncValue(:final value?) => Text(value['comment']),
                                AsyncValue(error: != null) => Text("error"),
                                AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    switch (playlistDetails) {
                      AsyncValue(:final value?) => SongList(songListNullable: value['entry'],listView: false,sliver: false,),
                      AsyncValue(error: != null) => Text("Error"),
                      AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    },
                  ],
                ),
              ),

               */