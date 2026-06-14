import 'package:flatter/useful_scripts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';

import '../../main.dart';
import 'album_screen/album_screen.dart';
import 'artist_screen/artist_screen.dart';

class SongList extends StatelessWidget {
  const SongList({super.key,required this.songListNullable,required this.listView,required this.sliver, this.filterNotifier});
  final List<dynamic>? songListNullable;
  final bool listView;
  final bool sliver;
  final ValueNotifier<String>? filterNotifier;

  @override
  Widget build(BuildContext context) {
    final SubsonicJustAudioCompatibility usefulScripts = SubsonicJustAudioCompatibility();
    List<dynamic> songList = [];
    if (songListNullable != null && songListNullable?.isEmpty == false) {
      print(songListNullable);
      songList.addAll(songListNullable!);
    } else {
      if (sliver == true) {
        return SliverToBoxAdapter(
          child: Center(child: Text("No songs")),
        );
      } else {
        return Center(child: Text("No songs"));
      }
    }
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
    }
    print("returning a non enmpty song list");
    if (listView == true) {
      if (sliver == true) {
        print("returning a sliverlist.builder");
        if (filterNotifier != null) {
          return ValueListenableBuilder(//vlt einstellen wo der durchsuchen darf
            valueListenable: filterNotifier!,
            builder: (context,String filter,child) {
              List<dynamic> filteredSongList = new List.from(songList);
              if (filter.isNotEmpty) {
                filter.toLowerCase();
                filteredSongList.removeWhere((item) {
                  if (item is Map) {
                    for (var value in item.values) {
                      if (value is String) {
                        if (value.toLowerCase().contains(filter.toLowerCase())) {
                          return false;
                        }
                      } else if (value is List) {
                        for (var underValue in value) {
                          if (underValue is Map) {
                            for (var underUnderValue in underValue.values) {
                              if (underUnderValue is String) {
                                if (underUnderValue.toLowerCase().contains(filter.toLowerCase())) {
                                  return false;
                                }
                              }
                            }
                          } else if (underValue is String) {
                            if (underValue.toLowerCase().contains(filter.toLowerCase())) {
                              return false;
                            }
                          }
                        }
                      }
                    }
                  }
                  return true;
                });
              }
              return SliverList.builder(
                itemCount: filteredSongList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => (playerControl.customAction('addNext',{'addNext': {
                            'tracks':[usefulScripts.subsonicSongToMediaItem(filteredSongList[index])]
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
                          onPressed: (_) => (goToAlbum(context, filteredSongList[index]['albumId'])),
                          icon: Icons.album,
                          label: 'Album',
                        ),
                        SlidableAction(
                          onPressed: (_) => (goToArtist(context, filteredSongList[index]['artistId'])),
                          icon: Icons.person,
                          label: 'Artist',
                        ),
                      ],
                    ),
                    child: ListTile(//evt noch cover hinzufügen oder so idk
                      leading: Text(filteredSongList[index]['duration'].toString()),//hier cover image
                      title: Row(
                        spacing: 8,
                        children: [
                          if (filteredSongList[index]['starred'] != null) Icon(Icons.favorite),
                          Text(filteredSongList[index]['title']),
                        ],
                      ),
                      subtitle: Text(filteredSongList[index]['artist'].toString()),
                      trailing: ItemMenus(context).songMenu(filteredSongList[index]),//artist und playlist geben leider namen und keine ids zurück...👩‍🦲
                      onTap: () {
                        playerControl.addQueueItem(usefulScripts.subsonicSongToMediaItem(filteredSongList[index]));
                      },
                    ),
                  );
                },
              );
            },
          );
        } else {
          return SliverList.builder(
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
        }

      } else {
        print("returning a listview.builder");
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
      }
    } else {
      if (sliver == true) {
        print("returning a  column sliver thing");
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
        return SliverToBoxAdapter(
          child: Column(children: widgetList,),
        );
      } else {
        print("returning a column");
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
}