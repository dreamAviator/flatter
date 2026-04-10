import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/artist_select_window.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../album_screen/album_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key,required this.playlistID});
  final String playlistID;

  Widget buildPlaylistColumn(List<dynamic> songList,BuildContext context,ItemMenus itemMenus) {
    List<Widget> widgetList = [];
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
    }
    for (Map song in songList) {
      widgetList.add(
          Slidable(
            startActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => (playerControl.addNext(song['id'])),
                  icon: Icons.list,
                  label: "Play next",
                ),
                SlidableAction(
                  onPressed: (_) => print("add to playlist"),
                  icon: Icons.playlist_add,
                  label: "Add to playlist",
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => (goToAlbum(context, song['albumId'])),
                  icon: Icons.album,
                  label: 'Playlist',
                ),
                SlidableAction(
                  onPressed: (_) => (goToArtist(context, song['artistId'])),
                  icon: Icons.person,
                  label: 'Artist',
                ),
              ],
            ),
            child: ListTile(//evt noch cover hinzufügen oder so idk//außerdem slidables daraus machen obvs omg
              leading: Text(song['duration'].toString()),
              title: Text(song['title']),
              subtitle: Text(song['artist'].toString()),
              trailing: itemMenus.songMenu(song['id'], song['artistId'], song['albumId']),//artist und playlist geben leider namen und keine ids zurück...👩‍🦲
              onTap: () {
                playerControl.addItem(song['id']);
              },
            ),
          )
      );
    }
    return Column(children: widgetList,);
  }

  @override
  Widget build(BuildContext context) {
    ItemMenus itemMenus = ItemMenus(context);
    final Size screenSize = MediaQuery.sizeOf(context);
    return Consumer(
      builder: (context,ref,child) {
        final playlistDetails = ref.watch(riverpodManager.playlistDetailsProvider(playlistID));
        return Scaffold(
          appBar: AppBar(
            title: switch (playlistDetails) {
              AsyncValue(:final value?) => Text(value['name']),
              AsyncValue(error: != null) => Text("Error"),
              AsyncValue() => CircularProgressIndicator(),
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
                  },
                  icon: Icon(Icons.edit),//probably damit sich das ändert hier ein eigenes widget bauen
                ),
                itemMenus.playlistMenu(value['id'], value['entry'], value['owner']),
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
                switch (playlistDetails) {
                  AsyncValue(:final value?) => CachedNetworkImage(
                    imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${value['coverArt']}",
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
                switch (playlistDetails) {
                  AsyncValue(:final value?) => TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: value['artistId'])));
                    },
                    child: Text(value['owner']),
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
                switch (playlistDetails) {
                  AsyncValue(:final value?) => buildPlaylistColumn(value['entry'],context,itemMenus),
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