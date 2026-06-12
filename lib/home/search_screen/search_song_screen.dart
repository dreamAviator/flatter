import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/library_screen/song_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchSongScreen extends StatelessWidget {
  const SearchSongScreen({super.key,required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    RiverpodManager riverpodManager = RiverpodManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text("All songs"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer(
        builder: (context,ref,child) {
          final fullSearchResults = ref.watch(riverpodManager.fullSearchProvider(query));
          return switch (fullSearchResults) {
            AsyncValue(:final value?) => SongList(songListNullable: value['song'], listView: true,sliver: false),
            AsyncValue(error: != null) => Text("error"),
            AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
          };
        },
      ),
    );
  }
}