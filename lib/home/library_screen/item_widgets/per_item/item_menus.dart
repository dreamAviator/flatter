import 'package:audio_service/audio_service.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/popups/add_to_playlist_popup.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:flutter/material.dart';
import 'package:deepcopy/deepcopy.dart';

import '../../popups/artist_select_popup.dart';//TODO:add to playlist fehlt

class ItemMenus {//man muss hier halt später einstellen können, welche aktionen hier und welche im bottom sheet angezeigt werden sollen
  ItemMenus(this.context);
  final BuildContext context;
  final SubsonicJustAudioCompatibility usefulScripts = SubsonicJustAudioCompatibility();

  //Pop Up Menu Entry actions//TODO:noch die by id dinger hinzufügen, dafür gibt's ja was in den player controls
  //mal schauen, ob ich die anderen actions als bottom sheet behalte, oder als untermenü. bei einem untermenü könnte ich diesen code so wie er ist wiederverwenden. aber eig finde ich ein bottom sheet schöner dafür
  PopupMenuEntry playNow(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addMultiple',{'addMultiple':{'tracks':items}});
      },
      child: const Text("Play now"),
    );
  }
  PopupMenuEntry addNext(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addNext',{'addNext':{'tracks':items}});
      },
      child: const Text("Add next"),
    );
  }
  PopupMenuEntry enqueue(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addMultiple',{'addMultiple':{'tracks':items}});
      },
      child: const Text("Enqueue"),
    );
  }
  PopupMenuEntry playNowShuffled(List<MediaItem> items) {
    items.shuffle();
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addMultiple',{'addMultiple':{
          'tracks':items,
          'shuffled':true,
        }});
      },
      child: const Text("Play now shuffled"),
    );
  }
  PopupMenuEntry addNextShuffled(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addNext',{'addNext': {
          'tracks': items,
          'shuffled':true,
        }});
      },
      child: const Text("Add next shuffled"),
    );
  }
  PopupMenuEntry enqueueShuffled(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('enqeue',{'enqueue':{
          'tracks':items,
          'shuffled':true,
        }});
      },
      child: const Text("Enqueue shuffled"),
    );
  }
  PopupMenuEntry playNowByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: const Text("Play now"),
    );
  }
  PopupMenuEntry addNextByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      child: const Text("Add next"),
    );
  }
  PopupMenuEntry enqueueByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: const Text("Enqueue"),
    );
  }
  PopupMenuEntry playNowShuffledByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('clearQueue');
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: const Text("Play now shuffled"),
    );
  }
  PopupMenuEntry addNextShuffledByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      child: const Text("Add next shuffled"),
    );
  }
  PopupMenuEntry enqueueShuffledByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: const Text("Enqueue shuffled"),
    );
  }
  PopupMenuEntry album(String albumID) {
    return PopupMenuItem(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumID)));
      },
      child: const Text("Album"),
    );
  }
  PopupMenuEntry artist(String artistID,List? artists) {
    return PopupMenuItem(
      onTap: () {
        Navigator.of(context).pop();
        if (artists?.length == 1 || artists == null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistID)));
        } else {
          ArtistSelectWindow.showArtistSelectWindow(context, artists);
        }
      },
      child: const Text("Artist"),
    );
  }
  PopupMenuEntry unFavorite(String? songID,String? albumID,String? artistID) {
    return PopupMenuItem(
      onTap: () {
        unFavoriteLogic(songID, albumID, artistID);
      },
      child: const Text("(Un)favorite"),
    );
  }
  Future<void> unFavoriteLogic(String? songID,String? albumID,String? artistID) async {
    bool favoriteStatus = await subsonicService.checkStarred(songID, albumID, artistID);
    if (favoriteStatus == true) {
      subsonicService.starUnstar(true, songID, albumID, artistID);
    } else {
      subsonicService.starUnstar(false, songID, albumID, artistID);
    }
  }
  PopupMenuEntry addToPlaylist(List<String> songIDs) {
    return PopupMenuItem(
      onTap: () {
        AddToPlaylistPopup.showAddToPlaylistPopup(context, songIDs);
      },
      child: const Text("Add to playlist"),
    );
  }
  PopupMenuEntry removeFromPlaylist(String songID,String playlistID) {
    return PopupMenuItem(
      onTap: () {
        subsonicService.updatePlaylist(playlistID, null, null, null, null, [songID]);
      },
      child: const Text("Remove from playlist"),
    );
  }
  //More Sheet Menu Entry Actions
  ListTile playNowMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addMultiple',{'addMultiple':items});
      },
      title: const Text("Play now"),
    );
  }
  ListTile addNextMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addNext',{'addNext':{'tracks':items}});
      },
      title: const Text("Add next"),
    );
  }
  ListTile enqueueMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addMultiple',{'addMultiple':{'tracks':items}});
      },
      title: const Text("Enqueue"),
    );
  }
  ListTile playNowShuffledMoreSheet(List<MediaItem> items) {
    items.shuffle();
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addMultiple',{'addMultiple':{
          'tracks':items,
          'shuffled':true,
        }});
      },
      title: const Text("Play now shuffled"),
    );
  }
  ListTile addNextShuffledMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addNext',{'addNext': {
          'tracks': items,
          'shuffled':true,
        }});
      },
      title: const Text("Add next shuffled"),
    );
  }
  ListTile enqueueShuffledMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('enqeue',{'enqueue':{
          'tracks':items,
          'shuffled':true,
        }});
      },
      title: const Text("Enqueue shuffled"),
    );
  }
  ListTile playNowByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: const Text("Play now"),
    );
  }
  ListTile addNextByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      title: const Text("Add next"),
    );
  }
  ListTile enqueueByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: const Text("Enqueue"),
    );
  }
  ListTile playNowShuffledByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: const Text("Play now shuffled"),
    );
  }
  ListTile addNextShuffledByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      title: const Text("Add next shuffled"),
    );
  }
  ListTile enqueueShuffledByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: const Text("Enqueue shuffled"),
    );
  }
  ListTile albumMoreSheet(String albumID) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumID)));
      },
      title: const Text("Album"),
    );
  }
  ListTile artistMoreSheet(String artistID,List? artists) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        if (artists?.length == 1 || artists == null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistID)));
        } else {
          ArtistSelectWindow.showArtistSelectWindow(context, artists);
        }
      },
      title: const Text("Artist"),
    );
  }
  ListTile unFavoriteMoreSheet(String? songID,String? albumID, String? artistID) {
    return ListTile(
      onTap: () {
        unFavoriteLogic(songID, albumID, artistID);
      },
      title: const Text("(Un)Favorite"),//TODO:das hier je nach aktuellem status evt ändern, mal schauen, je nachdem wie einfach das ist
    );
  }
  ListTile addToPlaylistMoreSheet(List<String> songIDs) {
    return ListTile(
      onTap: () {
        AddToPlaylistPopup.showAddToPlaylistPopup(context, songIDs);
      },
      title: const Text("Add to playlist")
    );
  }
  ListTile removeFromPlaylistMoreSheet(String songID,String playlistID) {
    return ListTile(
      onTap: () {
        subsonicService.updatePlaylist(playlistID, null, null, null, null, [songID]);
      },
      title: const Text("Remove from playlist"),
    );
  }

  //menus//TODO:favorite/unfavorite noch hinzufügen
  Widget songMenu(Map<dynamic,dynamic> songOld, String? playlistID) {
    Map<dynamic,dynamic> song = songOld.deepcopy();
    Map actionOrder = settingsControl.loadSetting('songMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    MediaItem songMediaItem = usefulScripts.subsonicSongToMediaItem(song);
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNow([songMediaItem]));
        case 'addNext':
          menuEntryList.add(addNext([songMediaItem]));
        case 'enqueue':
          menuEntryList.add(enqueue([songMediaItem]));
        case 'album':
          menuEntryList.add(album(songMediaItem.extras!['albumId']));
        case 'artist':
          menuEntryList.add(artist(songMediaItem.extras!['artistId'],songMediaItem.extras!['artists']));
        case 'unFavorite':
          menuEntryList.add(unFavorite(songMediaItem.id, null, null));
        case 'addToPlaylist':
          menuEntryList.add(addToPlaylist([songMediaItem.id]));
        case 'removeFromPlaylist':
          if (playlistID != null) {
            menuEntryList.add(removeFromPlaylist(songMediaItem.id, playlistID));
          }
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowMoreSheet([songMediaItem]));
        case 'addNext':
          moreSheetEntryList.add(addNextMoreSheet([songMediaItem]));
        case 'enqueue':
          moreSheetEntryList.add(enqueueMoreSheet([songMediaItem]));
        case 'album':
          moreSheetEntryList.add(albumMoreSheet(songMediaItem.extras!['albumId']));
        case 'artist':
          moreSheetEntryList.add(artistMoreSheet(songMediaItem.extras!['artistId'],songMediaItem.extras!['artists']));
        case 'unFavorite':
          moreSheetEntryList.add(unFavoriteMoreSheet(songMediaItem.id, null, null));
        case 'addToPlaylist':
          moreSheetEntryList.add(addToPlaylistMoreSheet([songMediaItem.id]));
        case 'removeFromPlaylist':
          if (playlistID != null) {
            moreSheetEntryList.add(removeFromPlaylistMoreSheet(songMediaItem.id, playlistID));
          }
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
  Widget songMenuQueue(MediaItem song) {
    Map actionOrder = settingsControl.loadSetting('songMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNow([song]));
        case 'addNext':
          menuEntryList.add(addNext([song]));
        case 'enqueue':
          menuEntryList.add(enqueue([song]));
        case 'album':
          menuEntryList.add(album(song.extras!['albumId']));
        case 'artist':
          menuEntryList.add(artist(song.extras!['artistId'],song.extras!['artists']));
        case 'unFavorite':
          menuEntryList.add(unFavorite(song.id, null, null));
        case 'addToPlaylist':
          addToPlaylist([song.id]);
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowMoreSheet([song]));
        case 'addNext':
          moreSheetEntryList.add(addNextMoreSheet([song]));
        case 'enqueue':
          moreSheetEntryList.add(enqueueMoreSheet([song]));
        case 'album':
          moreSheetEntryList.add(albumMoreSheet(song.extras!['albumId']));
        case 'artist':
          moreSheetEntryList.add(artistMoreSheet(song.extras!['artistId'],song.extras!['artists']));
        case 'unFavorite':
          moreSheetEntryList.add(unFavoriteMoreSheet(song.id, null, null));
        case 'addToPlaylist':
          moreSheetEntryList.add(addToPlaylistMoreSheet([song.id]));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
  Widget albumMenu(Map<dynamic,dynamic> albumOld) {
    Map<dynamic,dynamic> album = albumOld.deepcopy();
    Map actionOrder = settingsControl.loadSetting('albumMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    List<MediaItem> songList = [];
    if (album['song'] != null) songList = usefulScripts.subsonicSongListToMediaItemList(album['song']);
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNow(songList));
        case 'addNext':
          menuEntryList.add(addNext(songList));
        case 'enqueue':
          menuEntryList.add(enqueue(songList));
        case 'artist':
          menuEntryList.add(artist(album['artistId'],album['artists']));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffled(songList));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffled(songList));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffled(songList));
        case 'unFavorite':
          menuEntryList.add(unFavorite(null, album['id'], null));
        case 'addToPlaylist':
          List<String> songIDs = [];
          for (MediaItem song in songList) {
            songIDs.add(song.id);
          }
          menuEntryList.add(addToPlaylist(songIDs));
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowMoreSheet(songList));
        case 'addNext':
          moreSheetEntryList.add(addNextMoreSheet(songList));
        case 'enqueue':
          moreSheetEntryList.add(enqueueMoreSheet(songList));
        case 'artist':
          moreSheetEntryList.add(artistMoreSheet(album['artistId'],album['artists']));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledMoreSheet(songList));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledMoreSheet(songList));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledMoreSheet(songList));
        case 'unFavorite':
          moreSheetEntryList.add(unFavoriteMoreSheet(null, album['id'], null));
        case 'addToPlaylist':
          List<String> songIDs = [];
          for (MediaItem song in songList) {
            songIDs.add(song.id);
          }
          moreSheetEntryList.add(addToPlaylistMoreSheet(songIDs));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
  Widget albumMenuList(Map<dynamic,dynamic> albumMinimalOld) {//TODO:addToPlaylist
    Map<dynamic,dynamic> albumMinimal = albumMinimalOld.deepcopy();
    Map actionOrder = settingsControl.loadSetting('albumMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNowByID({'albumID':albumMinimal['id']}));
        case 'addNext':
          menuEntryList.add(addNextByID({'albumID':albumMinimal['id']}));
        case 'enqueue':
          menuEntryList.add(enqueueByID({'albumID':albumMinimal['id']}));
        case 'artist':
          menuEntryList.add(artist(albumMinimal['artistId'],albumMinimal['artists']));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffledByID({'albumID':albumMinimal['id']}));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffledByID({'albumID':albumMinimal['id']}));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffledByID({'albumID':albumMinimal['id']}));
        case 'unFavorite':
          menuEntryList.add(unFavorite(null, albumMinimal['id'], null));
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'addNext':
          moreSheetEntryList.add(addNextByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'enqueue':
          moreSheetEntryList.add(enqueueByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'artist':
          moreSheetEntryList.add(artistMoreSheet(albumMinimal['artistId'],albumMinimal['artists']));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'unFavorite':
          moreSheetEntryList.add(unFavoriteMoreSheet(null, albumMinimal['id'], null));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
  Widget artistMenu(Map<dynamic,dynamic> artist) {//TODO:addToPlaylist
    Map actionOrder = settingsControl.loadSetting('artistMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNowByID({'artistID':artist['id']}));
        case 'addNext':
          menuEntryList.add(addNextByID({'artistID':artist['id']}));
        case 'enqueue':
          menuEntryList.add(enqueueByID({'artistID':artist['id']}));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffledByID({'artistID':artist['id']}));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffledByID({'artistID':artist['id']}));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffledByID({'artistID':artist['id']}));
        case 'unFavorite':
          menuEntryList.add(unFavorite(null, null, artist['id']));
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowByIDMoreSheet({'artistID':artist['id']}));
        case 'addNext':
          moreSheetEntryList.add(addNextByIDMoreSheet({'artistID':artist['id']}));
        case 'enqueue':
          moreSheetEntryList.add(enqueueByIDMoreSheet({'artistID':artist['id']}));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledByIDMoreSheet({'artistID':artist['id']}));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledByIDMoreSheet({'artistID':artist['id']}));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledByIDMoreSheet({'artistID':artist['id']}));
        case 'unFavorite':
          moreSheetEntryList.add(unFavoriteMoreSheet(null, null, artist['id']));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
  //TODO:artistMenuList//TODO:addToPlaylist
  Widget playlistMenu(Map<dynamic,dynamic> playlistOld) {//vlt noch ein show playlists by user, hast du ja im playlist screen an sich auch schon vor glaube ich
    Map<dynamic,dynamic> playlist = playlistOld.deepcopy();
    Map actionOrder = settingsControl.loadSetting('playlistMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    List<MediaItem> songList = [];
    if (playlist['entry'] != null) songList = usefulScripts.subsonicSongListToMediaItemList(playlist['entry']);
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNow(songList));
        case 'addNext':
          menuEntryList.add(addNext(songList));
        case 'enqueue':
          menuEntryList.add(enqueue(songList));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffled(songList));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffled(songList));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffled(songList));
        case 'addToPlaylist':
          List<String> songIDs = [];
          for (MediaItem song in songList) {
            songIDs.add(song.id);
          }
          menuEntryList.add(addToPlaylist(songIDs));
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowMoreSheet(songList));
        case 'addNext':
          moreSheetEntryList.add(addNextMoreSheet(songList));
        case 'enqueue':
          moreSheetEntryList.add(enqueueMoreSheet(songList));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledMoreSheet(songList));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledMoreSheet(songList));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledMoreSheet(songList));
        case 'addToPlaylist':
          List<String> songIDs = [];
          for (MediaItem song in songList) {
            songIDs.add(song.id);
          }
          moreSheetEntryList.add(addToPlaylistMoreSheet(songIDs));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
  Widget playlistMenuList(Map<dynamic,dynamic> playlistMinimalOld) {//TODO:addToPlaylist
    Map<dynamic,dynamic> playlistMinimal = playlistMinimalOld.deepcopy();
    Map actionOrder = settingsControl.loadSetting('playlistMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNowByID({'playlistID':playlistMinimal['id']}));
        case 'addNext':
          menuEntryList.add(addNextByID({'playlistID':playlistMinimal['id']}));
        case 'enqueue':
          menuEntryList.add(enqueueByID({'playlistID':playlistMinimal['id']}));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffledByID({'playlistID':playlistMinimal['id']}));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffledByID({'playlistID':playlistMinimal['id']}));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffledByID({'playlistID':playlistMinimal['id']}));
      }
    }
    for (String action in actionOrder['moreSheet']) {
      switch (action) {
        case 'playNow':
          moreSheetEntryList.add(playNowByIDMoreSheet({'playlistID':playlistMinimal['id']}));
        case 'addNext':
          moreSheetEntryList.add(addNextByIDMoreSheet({'playlistID':playlistMinimal['id']}));
        case 'enqueue':
          moreSheetEntryList.add(enqueueByIDMoreSheet({'playlistID':playlistMinimal['id']}));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledByIDMoreSheet({'playlistID':playlistMinimal['id']}));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledByIDMoreSheet({'playlistID':playlistMinimal['id']}));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledByIDMoreSheet({'playlistID':playlistMinimal['id']}));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (BuildContext context) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: moreSheetEntryList,
                ),
              );
            }
          );
        },
        child: const Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: const Icon(Icons.more_vert),
    );
  }
}