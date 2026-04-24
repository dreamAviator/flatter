import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key,required this.artistID});
  final String artistID;

  Widget buildAlbumGrid(BuildContext context,List<dynamic> albums,double screenWidth) {
    //hier halt das gridview, evt aus diesen imagecards
    //idk ob gridview.builder der call ist oder besser gesagt wann das nicht der call ist :shrug:
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
                  trailing: ItemMenus(context).albumMenu2(album['id'], album['artistId']),
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
    return Consumer(
      builder: (context,ref,child) {
        final artistDetails = ref.watch(riverpodManager.artistDetailsProvider(artistID));
        return Scaffold(
          appBar: AppBar(
            title: switch (artistDetails) {
              AsyncValue(:final value?) => Text(value['name']),
              AsyncValue(error: != null) => Text("Error"),
              AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            },
            actions: [//evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
              IconButton(
                onPressed: () {
                  //hier eine aktion auswählen, kann man in den settings einstellen. entweder abspielen, enqueue oder play next
                },
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: () {
                  //hier favouriten
                },
                icon: Icon(Icons.favorite_border),//probably damit sich das ändert hier ein eigenes widget bauen
              ),
              IconButton(
                onPressed: () {
                  //Navigator.of(context).push();
                },
                icon: Icon(Icons.more_vert),
              ),//hier muss ich schauen was ich mache
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [//evt einige actions von den actions hier nach oben oder so mal schauen wie du das strukturieren willst
                //hier evt einen text von nem anderen server fetchen idk ob das bei alben geht
                if (settingsControl.settingsMap['landscapeMode'] == false) switch (artistDetails) {
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
                    switch (artistDetails) {
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
                Text("Albums"),
                switch (artistDetails) {
                  AsyncValue(:final value?) => buildAlbumGrid(context, value['album'],screenSize.width),
                  AsyncValue(error: != null) => Text("Error"),
                  AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                },
                Divider(),
                Text("Appears in:"),
              ],
            ),
          ),
        );
      },
    );
  }
}