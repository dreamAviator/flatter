/*
import 'package:flatter/home/library_screen/add_to_playlist_popup.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class ItemMenus {//have to completely rework this, either by using mediaitems or by using the full maps
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

  PopupMenuEntry playNowShuffled(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        playerControl.clearQueue();
        if (ids[0] == null) {
          if (ids[2] == "album") {
            playerControl.addItemAlbumShuffled(ids[1]);
          } else if (ids[2] == "playlist") {
            playerControl.addItemPlaylistShuffled(ids[1]);
          }
          return;
        }
        List<String> toGive = [];
        for (Map song in ids) {
          toGive.add(song['id']);
        }
        toGive.shuffle();
        playerControl.addItemList(toGive);
      },
      child: Text("Play now shuffled"),
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

  PopupMenuEntry addNextShuffled(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        if (ids[0] == [null]) {
          if (ids[2] == "album") {
            playerControl.addNextAlbumShuffled(ids[1]);
          } else if (ids[2] == "playlist") {
            playerControl.addNextPlaylistShuffled(ids[1]);
          }
          return;
        }
        List<String> toGive = [];
        for (Map song in ids.reversed) {
          toGive.add(song['id']);
        }
        toGive.shuffle();
        playerControl.addNextList(toGive);
      },
      child: Text("Add next shuffled"),
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

  PopupMenuEntry enqueueShuffled(List<dynamic> ids) {
    return PopupMenuItem(
      onTap: () {
        if (ids[0] == null) {
          if (ids[2] == "album") {
            playerControl.addItemAlbumShuffled(ids[1]);
          } else if (ids[2] == "playlist") {
            playerControl.addItemPlaylistShuffled(ids[1]);
          }
          return;
        }
        List<String> toGive = [];
        for (Map song in ids) {
          toGive.add(song['id']);
        }
        toGive.shuffle();
        playerControl.addItemList(toGive);
      },
      child: Text("Enqueue shuffled"),
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

  PopupMenuEntry addToPlaylist(List<dynamic> songIDs) {
    List<String> onlySongIDs = [];
    songIDs.forEach((song) {
      onlySongIDs.add(song['id']);
    });
    return PopupMenuItem(
      onTap: () {//irgendwie mit album und so mafhen
        AddToPlaylistPopup.showAddToPlaylistPopup(context, onlySongIDs);
      },
      child: Text("Add to playlist"),
    );
  }

  Widget songMenu(String id,String artistID, String albumID) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow([{'id': id}]),
        addNext([{'id': id}]),
        enqueue([{'id': id}]),
        PopupMenuDivider(),
        playNowShuffled([{'id': id}]),
        addNextShuffled([{'id': id}]),
        enqueueShuffled([{'id': id}]),
        PopupMenuDivider(),
        addToPlaylist([{'id': id}]),
        goToAlbum(albumID),
        goToArtist(artistID),
      ],
      child: Icon(Icons.more_vert),
    );
  }

  Widget albumMenu(String id,String albumArtistID, List<dynamic>? songIDs) {
    songIDs ??= [];
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow(songIDs!),
        addNext(songIDs),
        enqueue(songIDs),
        PopupMenuDivider(),
        playNowShuffled(songIDs),
        addNextShuffled(songIDs),
        enqueueShuffled(songIDs),
        PopupMenuDivider(),
        addToPlaylist(songIDs),
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
        playNowShuffled([null,id,"album"]),
        addNextShuffled([null,id,"album"]),
        enqueueShuffled([null,id,"album"]),
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

  Widget playlistMenu(String id,List<dynamic>? songIDs,String owner) {//TODO:brauchst bei den dingern immer noch etwas zum shufflen/shuffled hinzufügen
    songIDs ??= [];
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        playNow(songIDs!),
        addNext(songIDs),
        enqueue(songIDs),
        PopupMenuDivider(),
        playNowShuffled(songIDs),
        addNextShuffled(songIDs),
        enqueueShuffled(songIDs),
        PopupMenuDivider(),
        addToPlaylist(songIDs),
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
        playNowShuffled([null,id,"playlist"]),
        addNextShuffled([null,id,"playlist"]),
        enqueueShuffled([null,id,"playlist"]),
        PopupMenuDivider(),
        showPlaylistsByOwner(owner),
      ],
      child: Icon(Icons.more_vert),
    );
  }
}

 */