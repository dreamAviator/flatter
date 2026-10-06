import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/Services/subsonic_service.dart';
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

class _SongsTabState extends State<SongsTab> {
  bool onlyFavorites = false;
  bool genreFilter = false;
  String? genre;
  final SubsonicService subsonicService = SubsonicService();

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

  Future<List> getSongs(int size, String? genre, int? fromYear, int? toYear,bool onlyFavorites) async {
    List<dynamic> randomSongList = [];
    if (onlyFavorites == true) {
      Map<dynamic,dynamic> starred = await subsonicService.getStarred();
      randomSongList = starred['song'];
    } else {
      randomSongList = await subsonicService.getRandomSongs(size, genre, fromYear, toYear);
    }
    return randomSongList;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IntrinsicSizeBuilder(
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
                    if (selected == false) {
                      genre = null;
                    }
                    genreFilter = selected;
                  });
                },
              ),
              if (genreFilter == true) FutureBuilder(
                  future: subsonicService.getGenres(),
                  builder: (context, asyncSnapshot) {
                    String genreName = genre ?? "Genre";
                    if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                      return FilledButton(
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
                                          List<dynamic> filteredSongList = new List.from(asyncSnapshot.data!);
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
                      );
                    } else if (asyncSnapshot.hasError) {
                      return Text("Error");
                    } else {
                      return LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25);
                    }
                  }
              ),
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
              FutureBuilder(
                  future: getSongs(500, genre, null, null,onlyFavorites),//TODO:favorites (in riverpod provider gucken)
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                      return SongList(listView: true,sliver: true,songListNullable: asyncSnapshot.data,playlistID: null,);
                    } else if (asyncSnapshot.hasError) {
                      return SliverToBoxAdapter(child: Text("Error"),);
                    } else {
                      return SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),);
                    }
                  }
              ),
            ],
          );
        }
      ),
    );
  }
}