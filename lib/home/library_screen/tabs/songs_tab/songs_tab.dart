import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/library_screen/tabs/songs_tab/songs_tab_viewModel.dart';
import 'package:flatter/home/library_screen/item_widgets/song_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../filter_widgets/search_string_filter_widget.dart';

class SongsTab extends StatefulWidget {
  const SongsTab({super.key,required this.viewModel});
  final SongsTabViewModel viewModel;

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {//TODO:favorite status hier
  bool onlyFavorites = false;
  bool genreFilter = false;

  DropdownMenu<String> buildGenreMenu(context,List<Map<dynamic,dynamic>> genres) {

  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    List<dynamic> filterSortList = [500,null,null,null,onlyFavorites];
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final randomSongList = ref.watch(riverpodManager.randomSongListProvider(filterSortList));
          return IntrinsicSizeBuilder(
            subject: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 8,
                children: [
                  if (genreFilter == false) FilterChip(
                    label: Text("Favorites"),
                    selected: onlyFavorites,
                    onSelected: (bool selected) {
                      setState(() {
                        onlyFavorites = selected;
                      });
                    },
                  ),
                  if (onlyFavorites == false) FilterChip(
                    label: Text("Genre:"),
                    selected: genreFilter,
                    onSelected: (bool selected) {
                      setState(() {
                        genreFilter = selected;
                      });
                    },
                  ),
                  if (genreFilter == true) Consumer(
                    builder: (context, ref, child) {
                      final genres = ref.watch(riverpodManager.genresProvider);
                      return switch (genres) {
                        AsyncValue(:final value?) => buildGenreMenu(context, value),
                        AsyncValue(error: != null) => const SliverToBoxAdapter(child: Center(child: Text("error"),)),
                        AsyncValue() =>SliverToBoxAdapter(child: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),),),
                      };
                    },
                  )
                ],
              ),
            ),
            builder: (context, subjectSize,subject) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    primary: false,
                    floating: true,
                    snap: true,
                    expandedHeight: subjectSize.height,
                    flexibleSpace: Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool visible = true;
                          print(constraints.maxHeight);
                          print(subjectSize.height);
                          if (constraints.heightConstraints().maxHeight < subjectSize.height) {
                            visible = false;
                          }
                          return Visibility(visible: visible,child: subject);
                        },
                      ),
                    ),
                  ),
                  switch (randomSongList) {
                    AsyncValue(:final value?) => SongList(listView: true,sliver: true,songListNullable: value,playlistID: null,),
                    AsyncValue(error: != null) => const SliverToBoxAdapter(child: Center(child: Text("error"),)),
                    AsyncValue() => SliverToBoxAdapter(child: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),),),
                  }
                ],
              );
            }
          );
        },
      ),
    );
  }
}