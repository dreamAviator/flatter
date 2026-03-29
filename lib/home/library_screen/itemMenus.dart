import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class ItemMenus {
  final BuildContext context;
  ItemMenus(this.context);

  PopupMenuEntry playNow(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        playerControl.clearQueue();
        for (Map song in ids) {
          playerControl.addItem(song['id']);
        }
      },
      child: Text("Play now"),
    );
  }

  PopupMenuEntry addNext(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        for (Map song in ids.reversed) {
          playerControl.addNext(song['id']);
        }
      },
      child: Text("Add next"),
    );
  }

  PopupMenuEntry enqueue(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        for (Map song in ids) {
          playerControl.addItem(song['id']);
        }
      },
      child: Text("Enqueue"),
    );
  }

  PopupMenuEntry goToAlbum(String id) {
    return PopupMenuItem(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
      },
      child: Text("Album"),
    );
  }

  PopupMenuEntry goToArtist(String id) {
    return PopupMenuItem(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
      },
      child: Text("Artist"),
    );
  }

  Widget songMenu(String id,String artistID, String albumID) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow([{'id': id}]),
        addNext([{'id': id}]),
        enqueue([{'id': id}]),
        PopupMenuDivider(),
        goToAlbum(albumID),
        goToArtist(artistID),
      ],
      child: Icon(Icons.more_vert),
    );
  }

  Widget albumMenu(String id,String albumArtistID, List<dynamic> songIDs) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow(songIDs),
        addNext(songIDs),
        enqueue(songIDs),
        PopupMenuDivider(),
        goToArtist(albumArtistID),
      ],
      child: Icon(Icons.more_vert),
    );
  }

  Widget artistMenu(String id,List<dynamic> songIDs) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        addNext(songIDs),
        enqueue(songIDs),
      ],
      child: Icon(Icons.more_vert),
    );
  }
}