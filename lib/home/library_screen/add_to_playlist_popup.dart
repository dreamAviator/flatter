import 'package:flatter/home/library_screen/edit_playlist_popup.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddToPlaylistPopup {
  static void showAddToPlaylistPopup(BuildContext context,List<dynamic> songIDs) {
    bool skipDuplicates = settingsControl.settingsMap['addToPlaylistsSkipDuplicates'];
    bool selectMultiple = false;
    Map<dynamic,bool> selectedPlaylistsMap = {};
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            void updatePlaylists(List<String> playlistIDs) {
              print("updating playlist uwu");
              print(playlistIDs);
              print(songIDs);
              print(skipDuplicates);
              print("no for each the subsonic service is called");
              playlistIDs.forEach((value) {
                subsonicService.updatePlaylist(value, null, null, null, songIDs, null);
              });//hier überlegen, ob das ding offen bleiben soll, bis es hinzugefügt wurde
              Navigator.of(context).pop();
            }
            Widget buildPlaylistColumn(context,List<dynamic> playlistList,WidgetRef ref) {//vlt einen schalter machen, dass man mehrere playlists auswählen kann
              List<Widget> widgetList = [];
              if (selectMultiple == false) {
                for (Map<dynamic,dynamic> playlist in playlistList) {
                  if (playlist['owner'] == databaseControl.getCurrentUsername()) {
                    String public = "private";
                    if (playlist['public'] == true) {
                      public = "public";
                    }
                    widgetList.add(
                      ListTile(
                        title: Text(playlist['name']),
                        subtitle: Text(public),
                        onTap: () {
                          updatePlaylists([playlist['id']]);
                        },
                      ),
                    );
                  }
                }
              } else {
                widgetList.add(FilledButton(
                  child: Text("Add to playlist(s)"),
                  onPressed: () {
                    print("addging to playlists now or smth idj bleh");
                    List<String> playlistIDs = [];
                    selectedPlaylistsMap.forEach((key,value) {
                      if (value == true) {
                        playlistIDs.add(key);
                      }
                    });
                    updatePlaylists(playlistIDs);
                  },
                ));
                for (Map<dynamic,dynamic> playlist in playlistList) {
                  if (selectedPlaylistsMap[playlist['id']] == null) {
                    selectedPlaylistsMap[playlist['id']] = false;
                  }
                  if (playlist['owner'] == databaseControl.getCurrentUsername()) {
                    String public = "private";
                    if (playlist['public'] == true) {
                      public = "public";
                    }
                    widgetList.add(
                      ListTile(
                        leading: Checkbox(
                          value: selectedPlaylistsMap[playlist['id']],
                          onChanged: (bool? value) {
                            setState(() {
                              value ??= false;
                              selectedPlaylistsMap[playlist['id']] = value!;
                            });
                            print(selectedPlaylistsMap);
                            ref.invalidate(riverpodManager.playlistListProvider);
                          },
                        ),
                        title: Text(playlist['name']),
                        subtitle: Text(public),
                      ),
                    );
                  }
                }
              }
              return Column(children: widgetList,);
            }

            return AlertDialog(
              title: const Text("Add to playlist"),
              content: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Skip duplicates"),
                        Switch(
                          value: skipDuplicates,
                          onChanged: (bool value) {
                            setState(() {
                              skipDuplicates = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select multiple"),
                        Consumer(
                          builder: (context,ref,child) {
                            return Switch(
                              value: selectMultiple,
                              onChanged: (bool value) {
                                print("hehehehehe");
                                print(value);
                                setState(() {
                                  selectMultiple = value;
                                });
                                ref.invalidate(riverpodManager.playlistListProvider);
                              },
                            );
                          },
                        )
                      ],
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        EditPlaylistPopup.showEditPlaylistPopUp(context, true, null, null, null, null, songIDs);
                      },
                      child: Text("Create new"),
                    ),
                    Consumer(
                      builder: (context,ref,child) {
                        final playlistList = ref.watch(riverpodManager.playlistListProvider);
                        return Container(
                          child: switch (playlistList) {
                            AsyncValue(:final value?) => buildPlaylistColumn(context, value,ref),
                            AsyncValue(error: != null) => const Text("Error"),
                            AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                          }
                        );
                      },
                    )
                  ]
                ),
              ),
            );
          },
        );
      }
    );
  }
}