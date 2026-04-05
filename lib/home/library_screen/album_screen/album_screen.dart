import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key,required this.albumID});
  final String albumID;

  Widget buildAlbumColumn(List<dynamic> songList,BuildContext context,ItemMenus itemMenus) {
    List<Widget> widgetList = [];
    for (Map song in songList) {
      widgetList.add(
        ListTile(//evt noch cover hinzufügen oder so idk
          leading: Text(song['track'].toString()),
          title: Text(song['title']),
          subtitle: Text(song['duration'].toString()),
          trailing: itemMenus.songMenu(song['id'], song['artistId'], song['albumId']),//artist und album geben leider namen und keine ids zurück...👩‍🦲
          onTap: () {
            playerControl.addItem(song['id']);
          },
        ),
      );
    }
    return Column(children: widgetList,);
  }

  @override
  Widget build(BuildContext context) {
    ItemMenus itemMenus = ItemMenus(context);
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
            actions: switch (albumDetails) {
              AsyncValue(:final value?) => [//evt einige von den actions hier nach unten oder so mal schauen wie du das strukturieren willst
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
                itemMenus.albumMenu(value['id'], value['artistId'], value['song']),
              ],
              AsyncValue(error: != null) => [Text("Error")],
              AsyncValue() => [CircularProgressIndicator()]
            }
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: value['artistId'])));
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
                  AsyncValue(:final value?) => buildAlbumColumn(value['song'],context,itemMenus),
                  AsyncValue(error: != null) => Text("Error"),
                  AsyncValue() => CircularProgressIndicator(),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}