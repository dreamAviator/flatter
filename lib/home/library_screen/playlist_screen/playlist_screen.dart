import 'dart:io';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/artist_select_window.dart';
import 'package:flatter/home/library_screen/edit_playlist_popup.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/home/library_screen/song_list.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Riverpod/riverpod_manager.dart';
import '../album_screen/album_screen.dart';
import '../search_filter_widget.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key,required this.playlistID});
  final String playlistID;

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    ItemMenus itemMenus = ItemMenus(context);
    final Size screenSize = MediaQuery.sizeOf(context);
    final filterNotifier = ValueNotifier<String>('');
    return Consumer(
      builder: (context,ref,child) {
        final playlistDetails = ref.watch(riverpodManager.playlistDetailsProvider(playlistID));
        return Scaffold(
          appBar: AppBar(
            title: switch (playlistDetails) {
              AsyncValue(:final value?) => Text(value['name']),
              AsyncValue(error: != null) => Text("Error"),
              AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            },
            actions: switch (playlistDetails) {
              AsyncValue(:final value?) => [//evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
                IconButton(
                  onPressed: () {
                    ArtistSelectWindow.showArtistSelectWindow(context, ["1"]);
                    //hier eine aktion auswählen, kann man in den settings einstellen. entweder abspielen, enqueue oder play next
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () {
                    //hier bearbeiten
                    //wär babo wenn du das nur anzeigen würdest, wenn du der owner bist
                    EditPlaylistPopup.showEditPlaylistPopUp(context, false, value['id'], value['name'], value['comment'], value['public'],null);
                  },
                  icon: Icon(Icons.edit),//probably damit sich das ändert hier ein eigenes widget bauen
                ),
                itemMenus.playlistMenu(value),
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
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
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
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SearchFilterWidget(filterNotifier: filterNotifier),),
              switch (playlistDetails) {
                AsyncValue(:final value?) => SongList(songListNullable: value['entry'],listView: true,sliver: true,filterNotifier: filterNotifier),
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