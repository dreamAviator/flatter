import 'package:flatter/home/library_screen/popups/add_to_playlist_popup.dart';
import 'package:flatter/home/library_screen/item_widgets/per_item/item_menus.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:marqueer/marqueer.dart';

import '../../../useful_scripts.dart';
import '../album_screen/album_screen.dart';
import '../artist_screen/artist_screen.dart';
import '../popups/artist_select_popup.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key,required this.song,required this.playlistID, required this.usecase});
  final Map song;
  final String? playlistID;
  final String? usecase;//um je nach usecase verschiedene einstellungen (bspw zu item menüs bzw slidables) zu holen

  @override
  Widget build(BuildContext context) {
    final SubsonicJustAudioCompatibility usefulScripts = SubsonicJustAudioCompatibility();
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id,List? artists) {
      if (artists?.length == 1 || artists == null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
      } else {
        ArtistSelectWindow.showArtistSelectWindow(context, artists);
      }
    }
    return Slidable(
      startActionPane: ActionPane(
        motion: DrawerMotion(),//einstellbar
        children: [//einstellbar
          SlidableAction(
            onPressed: (_) => (playerControl.customAction('addNext',{'addNext': {
              'tracks':[usefulScripts.subsonicSongToMediaItem(song)]
            }})),
            icon: Icons.list,//ich glaube anderes icon
            label: "Play next",
          ),
          SlidableAction(
            onPressed: (_) => AddToPlaylistPopup.showAddToPlaylistPopup(context, [song['id']]),
            icon: Icons.playlist_add,
            label: "Add to playlist",
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: DrawerMotion(),//einstellbar
        children: [
          SlidableAction(
            onPressed: (_) => (goToAlbum(context, song['albumId'])),
            icon: Icons.album,
            label: 'Album',
          ),
          SlidableAction(
            onPressed: (_) => (goToArtist(context, song['artistId'], song['artists'])),
            icon: Icons.person,
            label: 'Artist',
          )
        ],
      ),
      child: ListTile(
        leading: Text(song['duration'].toString()),
        title: Row(
          spacing: 8,
          children: [
            if (song['starred'] != null) Icon(Icons.favorite),
            Expanded(child: Marqueer(intrinsicCrossAxisSize: true, infinity: false,child: Text(song['title']),)),
          ],
        ),
        subtitle: Expanded(child: Marqueer(intrinsicCrossAxisSize: true,infinity: false,child: Text(song['artist'].toString()))),
        trailing: ItemMenus(context).songMenu(song,playlistID),
        onTap: () {
          playerControl.addQueueItem(usefulScripts.subsonicSongToMediaItem(song));
        },
      ),
    );
  }
}