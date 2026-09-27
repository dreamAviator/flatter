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
  String? genre = null;

  DropdownMenu<String> buildGenreMenu(BuildContext context,List<dynamic> genres) {
    List<DropdownMenuEntry<String>> entryList = [];
    for (Map genre in genres) {
      entryList.add(
        DropdownMenuEntry(
          value: genre['value'],
          label: genre['value'],
        )
      );
    }
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: entryList,
      onSelected: (String? value) {
        setState(() {
          genre = value;
        });
      },
    );
  }

  Future<List<DropdownMenuEntry<String>>> buildGenreEntries(List<dynamic> genres) async {
    List<DropdownMenuEntry<String>> entryList = [];
    for (Map genre in genres) {
      entryList.add(
          DropdownMenuEntry(
            value: genre['value'],
            label: genre['value'],
          )
      );
    }
    return entryList;
  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    List<dynamic> filterSortList = [500,genre,null,null,onlyFavorites];
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
                      String genreName = genre ?? "Genre";
                      final genres = ref.watch(riverpodManager.genresProvider);
                      return switch (genres) {
                        AsyncValue(:final value?) => FilledButton(
                          child: Text(genreName),
                          onPressed: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (BuildContext context) {
                                ValueNotifier<String> filterNotifier = ValueNotifier("");
                                return Column(
                                  children: [
                                    SearchStringFilterWidget(filterNotifier: filterNotifier),
                                    ValueListenableBuilder(
                                      valueListenable: filterNotifier,
                                      builder: (context, String filter, child) {
                                        List<dynamic> filteredSongList = new List.from(value);
                                        if (filter.isNotEmpty) {
                                          filter.toLowerCase();
                                          filteredSongList.removeWhere((item) {
                                            if (item is Map) {
                                              for (var value in item.values) {
                                                if (value is String) {
                                                  if (value.toLowerCase().contains(filter.toLowerCase())) {
                                                    return false;
                                                  }
                                                } else if (value is List) {
                                                  for (var underValue in value) {
                                                    if (underValue is Map) {
                                                      for (var underUnderValue in underValue.values) {
                                                        if (underUnderValue is String) {
                                                          if (underUnderValue.toLowerCase().contains(filter.toLowerCase())) {
                                                            return false;
                                                          }
                                                        }
                                                      }
                                                    } else if (underValue is String) {
                                                      if (underValue.toLowerCase().contains(filter.toLowerCase())) {
                                                        return false;
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                            return true;
                                          });
                                        }
                                        return Expanded(
                                          child: ListView.builder(
                                            itemCount: filteredSongList.length,
                                            itemBuilder: (BuildContext context,int index) {
                                              return ListTile(
                                                title: Text(filteredSongList[index]['value']),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    genre = filteredSongList[index]['value'];
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                        ),//ich muss es in lazy loading umwandeln irgendwie, auf pub.dev suchen/auf linux tabs geöffnet
                        AsyncValue(error: != null) => Center(child: Text("error"),),
                        AsyncValue() => Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),),
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