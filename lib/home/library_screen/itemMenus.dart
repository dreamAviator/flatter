import 'package:audio_service/audio_service.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:flutter/material.dart';

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
        playerControl.customAction('addMultiple',{'addMultiple':items});
      },
      child: Text("Play now"),
    );
  }
  PopupMenuEntry addNext(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addNext',{'addNext':{'tracks':items}});
      },
      child: Text("Add next"),
    );
  }
  PopupMenuEntry enqueue(List<MediaItem> items) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addMultiple',{'addMultiple':{'tracks':items}});
      },
      child: Text("Enqueue"),
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
      child: Text("Play now shuffled"),
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
      child: Text("Add next shuffled"),
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
      child: Text("Enqueue shuffled"),
    );
  }
  PopupMenuEntry playNowByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: Text("Play now"),
    );
  }
  PopupMenuEntry addNextByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      child: Text("Add next"),
    );
  }
  PopupMenuEntry enqueueByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: Text("Enqueue"),
    );
  }
  PopupMenuEntry playNowShuffledByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        playerControl.customAction('clearQueue');
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: Text("Play now shuffled"),
    );
  }
  PopupMenuEntry addNextShuffledByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      child: Text("Add next shuffled"),
    );
  }
  PopupMenuEntry enqueueShuffledByID(Map id) {
    return PopupMenuItem(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      child: Text("Enqueue shuffled"),
    );
  }
  PopupMenuEntry album(String albumID) {
    return PopupMenuItem(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumID)));
      },
      child: Text("Album"),
    );
  }
  PopupMenuEntry artist(String artistID) {//TODO:später zu dem machen, dass du zwischen mehreren artists auswählen kannst
    return PopupMenuItem(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistID)));
      },
      child: Text("Artist"),
    );
  }
  //More Sheet Menu Entry Actions
  ListTile playNowMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addMultiple',{'addMultiple':items});
      },
      title: Text("Play now"),
    );
  }
  ListTile addNextMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addNext',{'addNext':{'tracks':items}});
      },
      title: Text("Add next"),
    );
  }
  ListTile enqueueMoreSheet(List<MediaItem> items) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addMultiple',{'addMultiple':{'tracks':items}});
      },
      title: Text("Enqueue"),
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
      title: Text("Play now shuffled"),
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
      title: Text("Add next shuffled"),
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
      title: Text("Enqueue shuffled"),
    );
  }
  ListTile playNowByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: Text("Play now"),
    );
  }
  ListTile addNextByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      title: Text("Add next"),
    );
  }
  ListTile enqueueByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: Text("Enqueue"),
    );
  }
  ListTile playNowShuffledByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        playerControl.customAction('clearQueue');
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: Text("Play now shuffled"),
    );
  }
  ListTile addNextShuffledByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addNextByID',{'addNextByID':id});
      },
      title: Text("Add next shuffled"),
    );
  }
  ListTile enqueueShuffledByIDMoreSheet(Map id) {
    return ListTile(
      onTap: () {
        id['shuffled'] = true;
        playerControl.customAction('addByID',{'addByID':id});
      },
      title: Text("Enqueue shuffled"),
    );
  }
  ListTile albumMoreSheet(String albumID) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumID)));
      },
      title: Text("Album"),
    );
  }
  ListTile artistMoreSheet(String artistID) {//TODO:später zu dem machen, dass du zwischen mehreren artists auswählen kannst
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistID)));
      },
      title: Text("Artist"),
    );
  }

  //menus
  Widget songMenu(Map<dynamic,dynamic> song) {
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
          menuEntryList.add(artist(songMediaItem.extras!['artistId']));
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
          moreSheetEntryList.add(artistMoreSheet(songMediaItem.extras!['artistId']));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
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
          menuEntryList.add(artist(song.extras!['artistId']));
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
          moreSheetEntryList.add(artistMoreSheet(song.extras!['artistId']));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
    );
  }
  Widget albumMenu(Map<dynamic,dynamic> album) {
    Map actionOrder = settingsControl.loadSetting('albumMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    List<MediaItem> songList = usefulScripts.subsonicSongListToMediaItemList(album['song']);
    for (String action in actionOrder['mainMenu']) {
      switch (action) {
        case 'playNow':
          menuEntryList.add(playNow(songList));
        case 'addNext':
          menuEntryList.add(addNext(songList));
        case 'enqueue':
          menuEntryList.add(enqueue(songList));
        case 'artist':
          menuEntryList.add(artist(album['artistId']));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffled(songList));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffled(songList));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffled(songList));
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
          moreSheetEntryList.add(artistMoreSheet(album['artistId']));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledMoreSheet(songList));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledMoreSheet(songList));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledMoreSheet(songList));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
    );
  }
  Widget albumMenuList(Map<dynamic,dynamic> albumMinimal) {
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
          menuEntryList.add(artist(albumMinimal['artistId']));
        case 'playNowShuffled':
          menuEntryList.add(playNowShuffledByID({'albumID':albumMinimal['id']}));
        case 'addNextShuffled':
          menuEntryList.add(addNextShuffledByID({'albumID':albumMinimal['id']}));
        case 'enqueueShuffled':
          menuEntryList.add(enqueueShuffledByID({'albumID':albumMinimal['id']}));
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
          moreSheetEntryList.add(artistMoreSheet(albumMinimal['artistId']));
        case 'playNowShuffled':
          moreSheetEntryList.add(playNowShuffledByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'addNextShuffled':
          moreSheetEntryList.add(addNextShuffledByIDMoreSheet({'albumID':albumMinimal['id']}));
        case 'enqueueShuffled':
          moreSheetEntryList.add(enqueueShuffledByIDMoreSheet({'albumID':albumMinimal['id']}));
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
    );
  }
  Widget artistMenu(Map<dynamic,dynamic> artist) {
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
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
    );
  }
  Widget playlistMenu(Map<dynamic,dynamic> playlist) {//vlt noch ein show playlists by user, hast du ja im playlist screen an sich auch schon vor glaube ich
    Map actionOrder = settingsControl.loadSetting('playlistMenuActionOrder');
    List<PopupMenuEntry> menuEntryList = [];
    List<ListTile> moreSheetEntryList = [];
    List<MediaItem> songList = usefulScripts.subsonicSongListToMediaItemList(playlist['entry']);
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
      }
    }
    if (actionOrder['moreSheet'].isNotEmpty) {
      menuEntryList.add(PopupMenuItem(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
    );
  }
  Widget playlistMenuList(Map<dynamic,dynamic> playlistMinimal) {
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
              builder: (BuildContext context) {
                return SizedBox(//mal schauen wie du das mit dem grid machst//die gridsize einstellung gibt es schon (also in der settingsmap)
                  child: Column(
                    children: moreSheetEntryList,
                  ),
                );
              }
          );
        },
        child: Text("More"),
      ));
    }
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuEntryList,
      child: Icon(Icons.more_vert),
    );
  }
}