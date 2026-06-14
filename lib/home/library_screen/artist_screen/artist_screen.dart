import 'dart:io';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/library_screen/album_grid.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../../Riverpod/riverpod_manager.dart';
import '../favorite_button.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key,required this.artistID});
  final String artistID;

  Widget buildAlbumGrid(BuildContext context,List<dynamic>? albumsNullable,double screenWidth) {
    //hier halt das gridview, evt aus diesen imagecards
    //idk ob gridview.builder der call ist oder besser gesagt wann das nicht der call ist :shrug:
    List<dynamic> albums = [];
    print(albumsNullable);
    print("thjs was albvumsnullable");
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
    List<String> nameAndId = [artistID,"Said the Sky"];
    final riverpodManager = RiverpodManager();
    final Size screenSize = MediaQuery.sizeOf(context);

    Widget buildArtistAppearances(BuildContext context,String name,double screenWidth) {
      nameAndId[1] = name;
      return Consumer(
        builder: (context,ref,child) {
          final artistAppearances = ref.watch(riverpodManager.artistAppearancesProvider(nameAndId));
          return Container(
            child: switch (artistAppearances) {
              AsyncValue(:final value?) => buildAlbumGrid(context, value, screenSize.width),
              AsyncValue(error: != null) => Text(artistAppearances.error.toString()),
              AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            },
          );
        },
      );
    }

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
              FavoriteButton(songID: null, albumID: null, artistID: artistID),
              switch (artistDetails) {
                AsyncValue(:final value?) => ItemMenus(context).artistMenu(value),
                AsyncValue(error: != null) => Text("Error"),
                AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
              },
            ],
          ),
          body: CustomScrollView(
            slivers: [//evt einige actions von den actions hier nach oben oder so mal schauen wie du das strukturieren willst
              //hier evt einen text von nem anderen server fetchen idk ob das bei alben geht
              if (settingsControl.settingsMap['landscapeMode'] == false) switch (artistDetails) {
                AsyncValue(:final value?) => SliverToBoxAdapter(
                  child: CachedNetworkImage(
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
                ),
                AsyncValue(error: != null) => SliverToBoxAdapter(child: Text("Error")),
                AsyncValue() => SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)),
              },
              if (settingsControl.settingsMap['landscapeMode'] == false) SliverToBoxAdapter(
                child: Row(
                  children: [
                    //also ja hier actions
                    //diese diablen bis ergebnis da ist
                    Text("hier sollen actions hin")
                  ],
                ),
              ),
              if (settingsControl.settingsMap['landscapeMode'] == true) SliverToBoxAdapter(
                child: Row(
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
                    SliverToBoxAdapter(
                      child: Center(
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
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(child: Text("Albums")),
              switch (artistDetails) {
                //AsyncValue(:final value?) => buildAlbumGrid(context, value['album'],screenSize.width),
                AsyncValue(:final value?) => AlbumGrid(albumListNullable: value['album'],crossAxisCount: (screenSize.width / 175).toInt(),sliver: true,),
                AsyncValue(error: != null) => SliverToBoxAdapter(child: Text("error")),
                AsyncValue() => SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25)),
              },
              SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(child: Text("Appears in:")),
              switch (artistDetails) {
                AsyncValue(:final value?) => buildArtistAppearances(context, value['name'], screenSize.width),
                AsyncValue(error: != null) => SliverToBoxAdapter(child: Text("error1")),
                AsyncValue() => SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25))
              }
            ],
          ),
        );
      },
    );
  }
}