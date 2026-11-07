import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/item_widgets/song_list.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchSongScreen extends StatelessWidget {
  const SearchSongScreen({super.key,required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All songs"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
        future: subsonicService.fullSearch(query),
        builder: (BuildContext context,asyncSnapshot) {
          if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
            return SongList(songListNullable: asyncSnapshot.data?['song'], sliver: false,listView: true,playlistID: null,);
          } else if (asyncSnapshot.hasError && asyncSnapshot.connectionState == ConnectionState.done) {
            return Center(child: Text("Error"));
          } else {
            return LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25);
          }
        },
      )
    );
  }
}