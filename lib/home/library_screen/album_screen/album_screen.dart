import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key,required this.albumID});
  final String albumID;

  Widget buildAlbumList(List<dynamic> songList) {
    List<Widget> widgetList = [];
    print(songList);
    for (Map song in songList) {
      widgetList.add(
        ListTile(//evt noch cover hinzufügen oder so idk
          leading: Text(song['track'].toString()),
          title: Text(song['title']),
          subtitle: Text(song['duration'].toString()),
          trailing: IconButton(
            onPressed: () {
              //hier mehr menü
            },
            icon: Icon(Icons.more_vert),
          ),
          onTap: () {
            //hier stuff
          },
        ),
      );
    }
    return ListView(shrinkWrap: true,children: widgetList,);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final albumDetails = ref.watch(riverpodManager.albumDetailsProvider(albumID));
        return Scaffold(
          appBar: AppBar(
            title: switch (albumDetails) {
              AsyncValue(:final value?) => Text(value['name']),
              AsyncValue(error: != null) => Text("Error"),
              AsyncValue() => CircularProgressIndicator(),
            },
            actions: [//evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
              IconButton(
                onPressed: () {
                  //hier ein abspielen menü oder so
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
                  //hier irgendwie eine mehr tun aktion
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Column(
            children: [//evt einige actions von den actions hier nach oben oder so mal schauen wie du das strukturieren willst
              //hier evt einen text von nem anderen server fetchen idk ob das bei alben geht
              switch (albumDetails) {
                AsyncValue(:final value?) => CachedNetworkImage(
                  imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${value['coverArt']}&size=300",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => IconButton(
                    onPressed: () {
                      //hier retry
                    },
                    icon: Icon(Icons.error),
                  ),
                ),
                AsyncValue(error: != null) => Text("Error"),
                AsyncValue() => CircularProgressIndicator(),
              },
              switch (albumDetails) {
                AsyncValue(:final value?) => TextButton(
                  onPressed: () {
                    //zum artist gehen
                  },
                  child: Text(value['artist']),
                ),
                AsyncValue(error: != null) => Text("Error"),
                AsyncValue() => CircularProgressIndicator(),
              },
              Row(
                children: [
                  //also ja hier actions
                  //diese diablen bis ergebnis da ist
                  Text("hier sollen actions hin")
                ],
              ),
              switch (albumDetails) {
                AsyncValue(:final value?) => buildAlbumList(value['song']),
                AsyncValue(error: != null) => Text("Error"),
                AsyncValue() => CircularProgressIndicator(),
              },
            ],
          ),
        );
      },
    );
  }
}