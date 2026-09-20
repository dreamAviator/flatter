import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/library_screen/library_tab_bar/songs_tab/songs_tab_viewModel.dart';
import 'package:flatter/home/library_screen/item_widgets/song_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../filter_widgets/search_string_filter_widget.dart';

class SongsTab extends StatefulWidget {
  const SongsTab({super.key,required this.viewModel});
  final SongsTabViewModel viewModel;

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {//TODO:favorite status hier
  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    bool ascending = true;
    List<dynamic> filterSortList = [500,null,null,null];
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final randomSongList = ref.watch(riverpodManager.randomSongListProvider(filterSortList));
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text("hier drop down menü"),
                    IconButton(
                      onPressed: () {
                      },
                      icon: (ascending
                          ? Icon(Icons.arrow_upward)
                          : Icon(Icons.arrow_downward)),
                    )
                  ],
                ),
              ),
              switch (randomSongList) {
                AsyncValue(:final value?) => SongList(listView: true,sliver: true,songListNullable: value,playlistID: null,),
                AsyncValue(error: != null) => const SliverToBoxAdapter(child: Center(child: Text("error"),)),
                AsyncValue() => SliverToBoxAdapter(child: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),),),
              }
            ],
          );
        },
      ),
    );
  }
}