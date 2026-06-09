import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/artist_select_window.dart';
import 'package:flatter/home/library_screen/favorite_button.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/home/library_screen/song_list.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key,required this.albumID});
  final String albumID;

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    ItemMenus itemMenus = ItemMenus(context);
    final Size screenSize = MediaQuery.sizeOf(context);
    return Consumer(
      builder: (context,ref,child) {
        final albumDetails = ref.watch(riverpodManager.albumDetailsProvider(albumID));
        return Scaffold(
          appBar: AppBar(
            title: switch (albumDetails) {
              AsyncValue(:final value?) => Text(value['name']),
              AsyncValue(error: != null) => Text("Error"),
              AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            },
            actions: switch (albumDetails) {
              AsyncValue(:final value?) => [//evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
                IconButton(
                  onPressed: () {
                    String action = settingsControl.settingsMap['albumPlayButtonAction'];
                    switch (action) {//die sachen so implementieren, dass sich dieses ding hier die dinger holt oder ein anderer teil und dann die sahcne an die playercontrol weitergegeben werden, die playercontrol sollte nicht die sachen holen müssen
                      case "playNow":
                        playerControl.customAction('clearQueue');
                        playerControl.customAction('addMultiple',{'addMultiple': {
                          'tracks':value['id'],
                        }});
                      case "playNext":
                        playerControl.customAction('addNextByID',{'addNextByID':value['id']});
                      case "enqueue":
                        playerControl.customAction('addByID',{'addByID':value['id']});
                        //muss noch was für die shuffled dinger machen
                    }
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                FavoriteButton(songID: null, albumID: albumID, artistID: null),
                itemMenus.albumMenu(value),
              ],
              AsyncValue(error: != null) => [Text("Error")],
              AsyncValue() => [LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)]
            }
          ),
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
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
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
                  ],
                ),
              ),
              switch (albumDetails) {
                AsyncValue(:final value?) => SongList(songListNullable: value['song'],listView: true,sliver: true,),
                AsyncValue(error: != null) => Text("Error"),
                AsyncValue() => SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)),
              },
            ],
          ),
        );
      },
    );
  }
}