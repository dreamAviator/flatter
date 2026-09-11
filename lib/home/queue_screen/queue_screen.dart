import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/home/library_screen/popups/add_to_playlist_popup.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/queue_screen/confirm_delete_queue_popup.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:s_disabled/s_disabled.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../settings_screen/settings_screen.dart';
import '../settings_screen/settings_screen_ViewModel.dart';
import '../library_screen/artist_screen/artist_screen.dart';
import '../library_screen/item_widgets/per_item/item_menus.dart';

class QueueScreen extends StatefulWidget {//TODO:queue screen rework, so dass der screen aktualisiert wird wenn ein element entfernt wird oder zum nächsten element gegangen wird
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {

  Widget buildQueue(BuildContext context, List<MediaItem> queue) {
    SubsonicJustAudioCompatibility usefulScripts = SubsonicJustAudioCompatibility();

    if (queue.isEmpty) {
      return const Text("Queue empty");
    }

    void removeFromQueue(int index) {
      playerControl.removeQueueItemAt(index);
    }
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
    }

    return ReorderableListView.builder(
      itemCount: queue.length,
      onReorder: (int oldIndex,int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        playerControl.customAction("moveQueueItem",{'moveQueueItem':{'oldIndex':oldIndex,'newIndex':newIndex}});
      },
      itemBuilder: (BuildContext context,int index) {
        if (queue[index].extras!['current'] == true) {
          return Card.filled(
            key: Key('$index'),
            child: Column(
              children: [
                Slidable(
                  startActionPane: ActionPane(//farben überlegen
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => (goToAlbum(context, queue[index].extras!['albumID'])),
                        icon: Icons.album,
                        label: 'Album',
                      ),
                      SlidableAction(
                        onPressed: (_) => (goToArtist(context, queue[index].extras!['artistID'])),
                        icon: Icons.person,
                        label: 'Artist',
                      )
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => (removeFromQueue(index)),
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(queue[index].title),
                    subtitle: Text(queue[index].artist!),
                    trailing: ItemMenus(context).songMenuQueue(queue[index]),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            key: Key('$index'),
            child: Column(
              children: [
                Slidable(
                  startActionPane: ActionPane(//farben überlegen
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => (goToAlbum(context, queue[index].extras!['albumID'])),
                        icon: Icons.album,
                        label: 'Album',
                      ),
                      SlidableAction(
                        onPressed: (_) => (goToArtist(context, queue[index].extras!['artistID'])),
                        icon: Icons.person,
                        label: 'Artist',
                      )
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    /*
                    dismissible: DismissiblePane(
                      onDismissed: () {
                        removeFromQueue(index);
                      },
                    ),
                    benötigt einen key um dismissable zu sein
                     */
                    children: [
                      SlidableAction(
                        onPressed: (_) => (removeFromQueue(index)),
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),

                  child: ListTile(
                    title: Text(queue[index].title),
                    subtitle: Text(queue[index].artist!),
                    trailing: ItemMenus(context).songMenuQueue(queue[index]),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue"),
        actions: [
          if (settingsControl.loadSetting('landscapeMode') == false) IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(viewModel: SettingsScreenViewmodel())));
              },
              icon: const Icon(Icons.settings)
          ),
        ],
      ),
      body: StreamBuilder(
        stream: playerControl.queueStream,
        builder: (context, snapshot) {
          bool queueEmpty = false;
          final queue = snapshot.data ?? [];
          if (queue.isEmpty) {
            queueEmpty = true;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: buildQueue(context,queue),
              ),
              const Divider(),
              SDisabled(
                isDisabled: queueEmpty,
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,//farbe auswählen (generell halt wenn du dich um die farben kümmerst
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,//ig besser als space around
                    children: [
                      IconButton(
                        onPressed: () {
                          List<String> songIDlist = [];
                          for (MediaItem mediaItem in queue) {
                            songIDlist.add(mediaItem.id);
                          }
                          AddToPlaylistPopup.showAddToPlaylistPopup(context, songIDlist);
                        },
                        icon: const Icon(Icons.playlist_add_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          playerControl.customAction('shuffleQueue');
                        },
                        icon: const Icon(Icons.shuffle_outlined),
                      ),
                      IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.loop_outlined),//hier halt single und ganze queue
                      ),
                      IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.search_outlined),//search und evt animation selbst bauen qwq
                      ),
                      IconButton(
                        onPressed: () {
                          ConfirmDeleteQueuePopup.showConfirmDeleteQueuePopup(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}