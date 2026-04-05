import 'dart:collection';

import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/queue_screen/queue_screen_ViewModel.dart';
import 'package:flatter/home/queue_screen/queue_widget/queue_widget.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../library_screen/artist_screen/artist_screen.dart';
import '../library_screen/itemMenus.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {

  Widget buildQueue(WidgetRef ref, BuildContext context, List<List<dynamic>> queue) {

    void removeFromQueue(int index) {
      playerControl.removeItemAt(index);
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
        playerControl.moveItem(oldIndex, newIndex);
        ref.invalidate(riverpodManager.queueProvider);
      },
      itemBuilder: (BuildContext context,int index) {
        if (queue[index][2] == true) {
          return Card.filled(
            key: Key('$index'),
            child: Column(
              children: [
                Slidable(
                  startActionPane: ActionPane(//farben überlegen
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => (goToAlbum(context, queue[index][1][4])),
                        icon: Icons.album,
                        label: 'Album',
                      ),
                      SlidableAction(
                        onPressed: (_) => (goToArtist(context, queue[index][1][2])),
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
                    title: Text(queue[index][1][0]),
                    subtitle: Text(queue[index][1][1]),
                    trailing: ItemMenus(context).songMenu(queue[index][0], queue[index][1][2], queue[index][1][4]),
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
                        onPressed: (_) => (goToAlbum(context, queue[index][1][4])),
                        icon: Icons.album,
                        label: 'Album',
                      ),
                      SlidableAction(
                        onPressed: (_) => (goToArtist(context, queue[index][1][2])),
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
                    title: Text(queue[index][1][0]),
                    subtitle: Text(queue[index][1][1]),
                    trailing: ItemMenus(context).songMenu(queue[index][0], queue[index][1][2], queue[index][1][4]),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue"),
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
              AsyncValue() => CircularProgressIndicator(),
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
                    playerControl.shuffleQueue();
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