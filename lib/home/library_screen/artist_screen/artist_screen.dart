import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key,required this.artistID});
  final String artistID;

  Widget buildAlbumGrid(context,List<Map> albums) {
    //hier halt das gridview, evt aus diesen imagecards
    //idk ob gridview.builder der call ist oder besser gesagt wann das nicht der call ist :shrug:
    return Text("here will later be the albumgrid");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final albumDetails = ref.watch(riverpodManager.artistDetailsProvider(artistID));
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
                Row(
                  children: [
                    //also ja hier actions
                    //diese diablen bis ergebnis da ist
                    Text("hier sollen actions hin")
                  ],
                ),
                Text("Albums"),
                switch (albumDetails) {
                  AsyncValue(:final value?) => buildAlbumGrid(context, value['album']),
                  AsyncValue(error: != null) => Text("Error"),
                  AsyncValue() => CircularProgressIndicator(),
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