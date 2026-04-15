import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToPlaylistPopup {
  static void showAddToPlaylistPopup(BuildContext context,List<dynamic> songIDs) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            bool skipDuplicates = settingsControl.settingsMap['addToPlaylistsSkipDuplicates'];
            void updatePlaylists(List<String> playlistIDs,List<String> songIDs) {
              print("updating playlist uwu");
            }
            Widget buildPlaylistColumn(context,List<dynamic> playlistList) {//vlt einen schalter machen, dass man mehrere playlists auswählen kann
              List<Widget> widgetList = [];
              for (Map<dynamic,dynamic> playlist in playlistList) {
                if (playlist['owner'] == databaseControl.getCurrentUsername()) {
                  String public = "private";
                  if (playlist['public'] = true) {
                    public = "public";
                  }
                  widgetList.add(
                    ListTile(
                      title: Text(playlist['name']),
                      subtitle: Text(public),
                    ),
                  );
                }
              }
              return Column(children: widgetList,);
            }

            return AlertDialog(
              title: const Text("Add to playlist"),
              content: SingleChildScrollView(
                child: Column(
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
                    Consumer(
                      builder: (context,ref,child) {
                        final playlistList = ref.watch(riverpodManager.playlistListProvider);
                        return Container(
                          child: switch (playlistList) {
                            AsyncValue(:final value?) => buildPlaylistColumn(context, value),
                            AsyncValue(error: != null) => const Text("Error"),
                            AsyncValue() => CircularProgressIndicator(),
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