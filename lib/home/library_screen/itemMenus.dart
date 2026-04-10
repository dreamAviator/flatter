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
        if (ids[0] == null) {
          if (ids[2] == "album") {
            playerControl.addItemAlbum(ids[1]);
          } else if (ids[2] == "playlist") {
            playerControl.addItemPlaylist(ids[1]);
          }
          return;
        }
        List<String> toGive = [];
        for (Map song in ids) {
          toGive.add(song['id']);
        }
        playerControl.addItemList(toGive);
      },
      child: Text("Play now"),
    );
  }

  PopupMenuEntry addNext(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        if (ids[0] == [null]) {
          if (ids[2] == "album") {
            playerControl.addNextAlbum(ids[1]);
          } else if (ids[2] == "playlist") {
            playerControl.addNextPlaylist(ids[1]);
          }
          return;
        }
        List<String> toGive = [];
        for (Map song in ids.reversed) {
          toGive.add(song['id']);
        }
        playerControl.addNextList(toGive);
      },
      child: Text("Add next"),
    );
  }

  PopupMenuEntry enqueue(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        if (ids[0] == null) {
          if (ids[2] == "album") {
            playerControl.addItemAlbum(ids[1]);
          } else if (ids[2] == "playlist") {
            playerControl.addItemPlaylist(ids[1]);
          }
          return;
        }
        List<String> toGive = [];
        for (Map song in ids) {
          toGive.add(song['id']);
        }
        playerControl.addItemList(toGive);
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

  PopupMenuEntry showPlaylistsByOwner(String owner) {
    return PopupMenuItem(
      onTap: () {
        //hier alle playlists vom owner anzeigen, vlt mit filter options machen
      },
      child: Text("Playlists by $owner"),
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

  Widget albumMenu2(String id,String albumArtistID) {//for when no song ids are present
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow([null,id,"album"]),
        addNext([null,id,"album"]),
        enqueue([null,id,"album"]),
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

  Widget playlistMenu(String id,List<dynamic> songIDs,String owner) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow(songIDs),
        addNext(songIDs),
        enqueue(songIDs),
        PopupMenuDivider(),
        showPlaylistsByOwner(owner),
      ],
      child: Icon(Icons.more_vert),
    );
  }

  Widget playlistMenu2(String id,String owner) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow([null,id,"playlist"]),
        addNext([null,id,"playlist"]),
        enqueue([null,id,"playlist"]),
        PopupMenuDivider(),
        showPlaylistsByOwner(owner),
      ],
      child: Icon(Icons.more_vert),
    );
  }
}