import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/home/library_screen/popups/add_to_playlist_popup.dart';
import 'package:flatter/home/library_screen/screens/album_screen.dart';
import 'package:flatter/home/queue_screen/confirm_delete_queue_popup.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:s_packages/s_disabled/s_disabled.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../settings_screen/settings_screen.dart';
import '../settings_screen/settings_screen_ViewModel.dart';
import '../library_screen/screens/artist_screen.dart';
import '../library_screen/item_widgets/per_item/item_menus.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  //ScrollPosController scrollController = ScrollPosController(itemCount: 0);
  ScrollController scrollController = ScrollController();
  double scrollOffset = 0;
  bool hasRun = false;
  bool dontScroll = false;//soll umegelgt werden, wenn vom nutzer gescrollt wurde oder die queue irgendwie verändert wurde
  bool dontScrollOverride = false;//so that if the ui scrolls automatically, it does not count as scrolling

  Widget buildQueue(BuildContext context, List<MediaItem> queue,ListObserverController observerController) {

    if (queue.isNotEmpty) {
      hasRun = true;
    }
    void removeFromQueue(int index) {
      dontScroll = true;
      playerControl.removeQueueItemAt(index);
    }
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
    }

    return Column(
      children: [
        if (queue.isEmpty) const Text("Queue empty"),
        Expanded(
          child: ListViewObserver(
            controller: observerController,
            child: ReorderableListView.builder(
              scrollController: scrollController,
              itemCount: queue.length,
              onReorder: (int oldIndex,int newIndex) {
                dontScroll = true;
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
                            onTap: () {
                              playerControl.skipToQueueItem(index);
                            },
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
                            onTap: () {
                              playerControl.skipToQueueItem(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ListObserverController observerController = ListObserverController(controller: scrollController);
    print("widget build executed");
    print(dontScroll);
    print("this was dontScroll from start of widget build");
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification && dontScrollOverride == false) {
            dontScroll = true;
          } else if (notification is ScrollEndNotification) {
            dontScrollOverride = false;
          }
          return true;
        },
        child: StreamBuilder(
          stream: playerControl.queueStream,
          builder: (context, snapshot) {
            print("streambuilder executed");
            bool queueEmpty = false;
            final queue = snapshot.data ?? [];
            if (queue.isEmpty) {
              queueEmpty = true;
            }
            if (dontScroll == false) {
              if (queueEmpty != true && hasRun == true) {
                dontScrollOverride = true;
                observerController.animateTo(index: playerControl.getCurrentIndex(), duration: Duration(seconds: 1), curve: Curves.ease);
              }
              if (hasRun == false && queueEmpty == false) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  dontScrollOverride = true;
                  observerController.jumpTo(index: playerControl.getCurrentIndex());});
              }
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: buildQueue(context,queue,observerController),
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
                        StreamBuilder(
                          stream: playerControl.playbackState,
                          builder: (context, asyncSnapshot) {//TODO:eigenen button dafür
                            if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                              if (asyncSnapshot.data?.repeatMode == AudioServiceRepeatMode.none) {
                                return IconButton(
                                  onPressed: () {
                                    playerControl.setRepeatMode(AudioServiceRepeatMode.all);
                                  },
                                  icon: const Icon(Icons.start_outlined),//hier halt single und ganze queue
                                );
                              } else if (asyncSnapshot.data?.repeatMode == AudioServiceRepeatMode.all) {
                                return IconButton(
                                  onPressed: () {
                                    playerControl.setRepeatMode(AudioServiceRepeatMode.one);
                                  },
                                  icon: const Icon(Icons.repeat_outlined),//hier halt single und ganze queue
                                );
                              } else if (asyncSnapshot.data?.repeatMode == AudioServiceRepeatMode.one) {
                                return IconButton(
                                  onPressed: () {
                                    playerControl.setRepeatMode(AudioServiceRepeatMode.one);
                                  },
                                  icon: const Icon(Icons.repeat_one_outlined),//hier halt single und ganze queue
                                );
                              } else {
                                return IconButton(
                                  onPressed: () {

                                  },
                                  icon: const Icon(Icons.error_outline_outlined),//hier halt single und ganze queue
                                );
                              }

                            } else {
                              return IconButton(
                                onPressed: null,
                                icon: const Icon(Icons.pending_outlined),//hier halt single und ganze queue
                              );
                            }
                          }
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO:search
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
      ),
    );
  }
}