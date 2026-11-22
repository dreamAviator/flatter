import 'package:flatter/home/item_widgets/search_string_filter_widget.dart';
import 'package:flatter/home/popups/edit_playlist_popup.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddToPlaylistPopup {
  static void showAddToPlaylistPopup(BuildContext context,List<String> songIDs) {
    OtherScripts usefulScripts = OtherScripts();
    bool skipDuplicates = settingsControl.loadSetting('addToPlaylistsSkipDuplicates');//TODO: noch implementieren
    bool selectMultiple = settingsControl.loadSetting('addToPlaylistSelectMultiple');
    ValueNotifier<String> filterNotifier = ValueNotifier("");
    List<dynamic>? playlistList;
    Map<dynamic,bool> selectedPlaylistsMap = {};
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {

            void updatePlaylists(List<String> playlistIDs) {
              for (String playlistID in playlistIDs) {
                subsonicService.updatePlaylist(playlistID, null, null, null, songIDs, null);
              }
              Navigator.of(context).pop();
            }

            return AlertDialog(
              constraints: BoxConstraints(maxWidth: 560),
              title: const Text("Add to playlist(s)"),
              content: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          title: const Text("Skip duplicates"),
                          trailing: Switch(
                            value: skipDuplicates,
                            onChanged: (bool value) {
                              settingsControl.changeSetting('addToPlaylistsSkipDuplicates', value);
                              setState(() {
                                skipDuplicates = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Select multiple"),
                          trailing: Switch(
                            value: selectMultiple,
                            onChanged: (bool value) {
                              settingsControl.changeSetting('addToPlaylistSelectMultiple', value);
                              setState(() {
                                selectMultiple = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: subsonicService.getPlaylists(),
                            builder: (BuildContext context,asyncSnapshot) {
                              if (asyncSnapshot.hasData || playlistList != null) {
                                if (asyncSnapshot.data != null) {
                                  playlistList = usefulScripts.favoriteCheckAndSortPlaylistList(asyncSnapshot.data!);
                                } else {
                                  playlistList = [];
                                }
                                if (playlistList != null) {
                                  if (playlistList!.isNotEmpty) {
                                    String owner = databaseControl.getCurrentUsername();
                                    playlistList!.removeWhere((item) {
                                      if (item['owner'] == owner) {
                                        return false;
                                      }
                                      return true;
                                    });
                                    return Column(
                                      children: [
                                        SearchStringFilterWidget(filterNotifier: filterNotifier),
                                        ValueListenableBuilder(
                                          valueListenable: filterNotifier,
                                          builder: (context, String filter, child) {
                                            List<dynamic> filteredPlaylistList = List.from(playlistList!);
                                            if (filter.isNotEmpty) {
                                              filteredPlaylistList.removeWhere((item) {
                                                if (item is Map) {
                                                  for (var value in item.values) {
                                                    if (value is String) {
                                                      if (value.toLowerCase().contains(filter.toLowerCase())) {
                                                        return false;
                                                      }
                                                    }
                                                  }
                                                }
                                                return true;
                                              });
                                            }
                                            if (filteredPlaylistList.isEmpty) {
                                              return Center(child: Text("No playlists"));
                                            }
                                            return Expanded(
                                              child: ListView.builder(
                                                itemCount: filteredPlaylistList.length,
                                                itemBuilder: (BuildContext context,int index) {
                                                  String publicStatus = "private";
                                                  if (filteredPlaylistList[index]['public'] == true) {
                                                    publicStatus = "public";
                                                  }
                                                  if (selectMultiple == false) {
                                                    return ListTile(
                                                      title: Text(filteredPlaylistList[index]['name']),
                                                      subtitle: Text("${filteredPlaylistList[index]['songCount']} | $publicStatus"),
                                                      onTap: () {
                                                        updatePlaylists([filteredPlaylistList[index]['id']]);
                                                      },
                                                    );
                                                  } else {
                                                    return ListTile(
                                                      title: Text(filteredPlaylistList[index]['name']),
                                                      subtitle: Text("${filteredPlaylistList[index]['songCount']} | $publicStatus"),
                                                      trailing: Checkbox(
                                                        value: selectedPlaylistsMap[filteredPlaylistList[index]['id']] ?? false,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            value ??= false;
                                                            selectedPlaylistsMap[filteredPlaylistList[index]['id']] = value!;
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          }
                                        )
                                      ],
                                    );
                                  } else {
                                    return const Text("No playlists, create a new one");
                                  }
                                } else {
                                  return Text("No playlists, create a new one");
                                }
                              } else if (asyncSnapshot.hasError) {
                                return const Text("Error");
                              } else {
                                return LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 25);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (selectMultiple == false) Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context).pop();
                            EditPlaylistPopup.showEditPlaylistPopUp(context, true, null, null, null, null, songIDs);
                          },
                        ),
                      ),
                    ),
                    if (selectMultiple == true) Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: const Icon(Icons.check),
                          onPressed: () {
                            List<String> playlistIDs = [];
                            selectedPlaylistsMap.forEach((key,value) {
                              if (value == true) {
                                playlistIDs.add(key);
                              }
                            });
                            updatePlaylists(playlistIDs);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}