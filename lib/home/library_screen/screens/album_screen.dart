import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/library_screen/screens/artist_screen.dart';
import 'package:flatter/home/library_screen/popups/artist_select_popup.dart';
import 'package:flatter/home/library_screen/item_widgets/per_item/favorite_button.dart';
import 'package:flatter/home/library_screen/item_widgets/per_item/item_menus.dart';
import 'package:flatter/home/library_screen/item_widgets/song_list.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AlbumScreen extends StatefulWidget {
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
    return FutureBuilder(
      future: subsonicService.getAlbumDetails(widget.albumID),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(asyncSnapshot.data!['name']),
              actions: [//TODO:(bei den anderen screens auch) evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
                IconButton(
                  onPressed: () {
                    String action = settingsControl.settingsMap['albumPlayButtonAction'];
                    List<dynamic>? subsonicSongList = asyncSnapshot.data!['song'];
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
                      if (settingsControl.settingsMap['landscapeMode'] == false) CachedNetworkImage(
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
                      if (settingsControl.settingsMap['landscapeMode'] == false) TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: asyncSnapshot.data!['artistId'])));
                        },
                        child: Text(asyncSnapshot.data!['artist']),
                      ),
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
                          )
                        ],
                      ),
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