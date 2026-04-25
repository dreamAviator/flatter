import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/artist_select_window.dart';
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
                    switch (action) {
                      case "playNow":
                        playerControl.clearQueue();
                        playerControl.addItemAlbum(value['id']);
                      case "playNext":
                        playerControl.addNextAlbum(value['id']);
                      case "enqueue":
                        playerControl.addItemAlbum(value['id']);
                        //muss noch was für die shuffled dinger machen
                    }
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () {
                    //hier favouriten
                  },
                  icon: Icon(Icons.favorite_border),//probably damit sich das ändert hier ein eigenes widget bauen
                ),
                itemMenus.albumMenu(value['id'], value['artistId'], value['song']),
              ],
              AsyncValue(error: != null) => [Text("Error")],
              AsyncValue() => [LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)]
            }
          ),
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
        );
      },
    );
  }
}