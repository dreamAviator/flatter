import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../../settings/settings_screen.dart';
import '../../settings/settings_screen_ViewModel.dart';
import '../library_screen/artist_screen/artist_screen.dart';
import '../library_screen/itemMenus.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {

  Widget buildQueue(WidgetRef ref, BuildContext context, List<MediaItem> queue) {
    final riverpodManager = RiverpodManager();

    void removeFromQueue(int index) {
      playerControl.removeQueueItemAt(index);
      ref.invalidate(riverpodManager.queueProvider);
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
        ref.invalidate(riverpodManager.queueProvider);
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
              icon: Icon(Icons.settings)
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        final queue = ref.watch(riverpodManager.queueProvider);
        return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: switch (queue) {
              AsyncValue(:final value?) => buildQueue(ref,context,value),
              AsyncValue(error: != null) => const Text("error"),
              AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            },
          ),
          Divider(),
          Container(
            color: Theme.of(context).colorScheme.surfaceContainer,//farbe auswählen (generell halt wenn du dich um die farben kümmerst
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,//ig besser als space around
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.playlist_add),
                ),
                IconButton(
                  onPressed: () {
                    playerControl.customAction('shuffleQueue');
                    ref.invalidate(riverpodManager.queueProvider);
                  },
                  icon: Icon(Icons.shuffle),
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.loop),//hier halt single und ganze queue
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.search),//search und evt animation selbst bauen qwq
                ),
              ],
            ),
          ),
        ],
      ); },),
    );
  }
}