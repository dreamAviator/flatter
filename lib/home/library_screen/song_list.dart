import 'package:flatter/useful_scripts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';

import '../../main.dart';
import 'album_screen/album_screen.dart';
import 'artist_screen/artist_screen.dart';

class SongList extends StatelessWidget {
  const SongList({super.key,required this.songListNullable,required this.listView});
  final List<dynamic>? songListNullable;
  final bool listView;

  @override
  Widget build(BuildContext context) {
    final SubsonicJustAudioCompatibility usefulScripts = SubsonicJustAudioCompatibility();
    List<dynamic> songList = [];
    if (songListNullable != null && songListNullable?.isEmpty == false) {
      print(songListNullable);
      songList.addAll(songListNullable!);
    } else {
      return Center(child: Text("No songs"));
    }
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
    }
    if (listView == true) {
      return ListView.builder(
        itemCount: songList.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            startActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => (playerControl.customAction('addNext',{'addNext': {
                    'tracks':[usefulScripts.subsonicSongToMediaItem(songList[index])]
                  }})),
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
                  onPressed: (_) => (goToAlbum(context, songList[index]['albumId'])),
                  icon: Icons.album,
                  label: 'Album',
                ),
                SlidableAction(
                  onPressed: (_) => (goToArtist(context, songList[index]['artistId'])),
                  icon: Icons.person,
                  label: 'Artist',
                ),
              ],
            ),
            child: ListTile(//evt noch cover hinzufügen oder so idk
              leading: Text(songList[index]['duration'].toString()),//hier cover image
              title: Row(
                spacing: 8,
                children: [
                  if (songList[index]['starred'] != null) Icon(Icons.favorite),
                  Text(songList[index]['title']),
                ],
              ),
              subtitle: Text(songList[index]['artist'].toString()),
              trailing: ItemMenus(context).songMenu(songList[index]),//artist und playlist geben leider namen und keine ids zurück...👩‍🦲
              onTap: () {
                playerControl.addQueueItem(usefulScripts.subsonicSongToMediaItem(songList[index]));
              },
            ),
          );
        },
      );
    } else {
      List<Widget> widgetList = [];
      for (Map song in songList) {
        widgetList.add(
            Slidable(
              startActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => (playerControl.customAction('addNext',{'addNext': {
                      'tracks':usefulScripts.subsonicSongToMediaItem(song)
                    }})),
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
                    label: 'Album',
                  ),
                  SlidableAction(
                    onPressed: (_) => (goToArtist(context, song['artistId'])),
                    icon: Icons.person,
                    label: 'Artist',
                  ),
                ],
              ),
              child: ListTile(//evt noch cover hinzufügen oder so idk
                leading: Text(song['duration'].toString()),//hier cover image
                title: Row(
                  spacing: 8,
                  children: [
                    if (song['starred'] != null) Icon(Icons.favorite),
                    Text(song['title']),
                  ],
                ),
                subtitle: Text(song['artist'].toString()),
                trailing: ItemMenus(context).songMenu(song),//artist und playlist geben leider namen und keine ids zurück...👩‍🦲
                onTap: () {
                  playerControl.addQueueItem(usefulScripts.subsonicSongToMediaItem(song));
                },
              ),
            )
        );
      }
      return Column(children: widgetList,);
    }

  }
}