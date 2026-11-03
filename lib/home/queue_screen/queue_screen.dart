import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/home/item_widgets/loop_button.dart';
import 'package:flatter/home/popups/add_to_playlist_popup.dart';
import 'package:flatter/home/other_screens/album_screen.dart';
import 'package:flatter/home/queue_screen/confirm_delete_queue_popup.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:s_packages/s_disabled/s_disabled.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../settings_screen/settings_screen.dart';
import '../settings_screen/settings_screen_ViewModel.dart';
import '../other_screens/artist_screen.dart';
import '../item_widgets/item_menus.dart';

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
  bool showSearchBar = false;
  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchNotifier = ValueNotifier<String>("");

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
          child: ValueListenableBuilder(
            valueListenable: searchNotifier,
            builder: (context, filter, child) {
              List<MediaItem> filteredQueue = List.from(queue);
              if (filter.isNotEmpty) {
                filteredQueue.removeWhere((item) {
                  if (item.title.toLowerCase().contains(filter.toLowerCase())) {
                    return false;
                  } else if ((item.album ?? "").toLowerCase().contains(filter.toLowerCase())) {
                    return false;
                  } else if ((item.artist ?? "").toLowerCase().contains(filter.toLowerCase())) {
                    return false;
                  } else if (item.id.contains(filter.toLowerCase())) {
                    return false;
                  }
                  return true;
                });
              }
              print(showSearchBar);
              print("printed showsearchbar");
              return IntrinsicSizeBuilder(
                subject: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 5,
                              blurRadius: 7,
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SearchBar(
                              shadowColor: WidgetStateColor.transparent,
                              leading: const Icon(Icons.search),
                              controller: searchController,
                              onChanged: (String value) {
                                searchNotifier.value = value;
                              },
                              autoFocus: true,
                              trailing: [
                                IconButton(
                                  icon: const Icon(Icons.backspace_outlined),
                                  onPressed: () {
                                    searchController.clear();
                                  },
                                )
                              ],
                            ),
                          ),
                          Row(
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
                              LoopButton(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (showSearchBar == true) {
                                      showSearchBar = false;
                                    } else {
                                      showSearchBar = true;
                                    }
                                  });
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
                        ],
                      ),
                    ),
                  ],
                ),
                builder: (context, subjectSize,subject) {
                  return ListViewObserver(
                    controller: observerController,
                    child: ReorderableListView.builder(
                      scrollController: scrollController,
                      itemCount: filteredQueue.length,
                      onReorder: (int oldIndex,int newIndex) {
                        dontScroll = true;
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        playerControl.customAction("moveQueueItem",{'moveQueueItem':{'oldIndex':oldIndex,'newIndex':newIndex}});
                      },
                      footer: Padding(
                        padding: EdgeInsets.only(top: subjectSize.height / 3, bottom: subjectSize.height / 3 * 2),
                        child: Center(child: Text("Queue end")),
                      ),
                      itemBuilder: (BuildContext context,int index) {
                        if (filteredQueue[index].extras!['current'] == true) {
                          return Card.filled(
                            key: Key('$index'),
                            child: Column(
                              children: [
                                Slidable(
                                  startActionPane: ActionPane(//farben überlegen
                                    motion: DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) => (goToAlbum(context, filteredQueue[index].extras!['albumID'])),
                                        icon: Icons.album,
                                        label: 'Album',
                                      ),
                                      SlidableAction(
                                        onPressed: (_) => (goToArtist(context, filteredQueue[index].extras!['artistID'])),
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
                                    title: Text(filteredQueue[index].title),
                                    subtitle: Text(filteredQueue[index].artist!),
                                    trailing: ItemMenus(context).songMenuQueue(filteredQueue[index]),
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
                                        onPressed: (_) => (goToAlbum(context, filteredQueue[index].extras!['albumID'])),
                                        icon: Icons.album,
                                        label: 'Album',
                                      ),
                                      SlidableAction(
                                        onPressed: (_) => (goToArtist(context, filteredQueue[index].extras!['artistID'])),
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
                                    title: Text(filteredQueue[index].title),
                                    subtitle: Text(filteredQueue[index].artist!),
                                    trailing: ItemMenus(context).songMenuQueue(filteredQueue[index]),
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
                  );
                }
              );
            }
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
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: buildQueue(context,queue,observerController),
                    ),
                  ],
                ),
                Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SDisabled(
                      isDisabled: queueEmpty,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 5,
                              blurRadius: 7,
                            )
                          ]
                        ),
                        //color: Theme.of(context).colorScheme.surfaceContainer,//farbe auswählen (generell halt wenn du dich um die farben kümmerst
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showSearchBar == true ) Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SearchBar(
                                shadowColor: WidgetStateColor.transparent,
                                leading: const Icon(Icons.search),
                                controller: searchController,
                                onChanged: (String value) {
                                  searchNotifier.value = value;
                                },
                                autoFocus: true,
                                trailing: [
                                  IconButton(
                                    icon: const Icon(Icons.backspace_outlined),
                                    onPressed: () {
                                      searchController.clear();
                                    },
                                  )
                                ],
                              ),
                            ),
                            Row(
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
                                LoopButton(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (showSearchBar == true) {
                                        showSearchBar = false;
                                      } else {
                                        showSearchBar = true;
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.search_outlined),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ConfirmDeleteQueuePopup.showConfirmDeleteQueuePopup(context);
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        ),
      ),
    );
  }
}