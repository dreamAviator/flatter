import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/item_widgets/playlist_grid.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchPlaylistScreen extends StatelessWidget {
  const SearchPlaylistScreen({super.key,required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    OtherScripts usefulScripts = OtherScripts();
    final Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All playlists"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
        future: subsonicService.getPlaylists(),
        builder: (BuildContext context, asyncSnapshot) {
          if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
            List<dynamic> filteredPlaylistList = [];
            if (asyncSnapshot.data != null) {
              filteredPlaylistList = List.from(asyncSnapshot.data!);
              if (query.isNotEmpty) {
                filteredPlaylistList.removeWhere((item) {
                  if (item is Map) {
                    for (var value in item.values) {
                      if (value is String) {
                        if (value.toLowerCase().contains(query.toLowerCase())) {
                          return false;
                        }
                      }
                    }
                  }
                  return true;
                });
              }
              filteredPlaylistList = usefulScripts.favoriteCheckAndSortPlaylistList(filteredPlaylistList);
            }
            return PlaylistGrid(playlistListNullable: filteredPlaylistList, crossAxisCount: (screenSize.width / 175).toInt(), sliver: false);
          } else if (asyncSnapshot.hasError && asyncSnapshot.connectionState == ConnectionState.done) {
            return Center(child: Text("Error"));
          } else {
            return LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25);
          }
        },
      ),
    );
  }
}