import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/library_screen/item_widgets/artist_grid.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/library_tab_bar/artists_tab/artists_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/search_filter_widget.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../../../Riverpod/riverpod_manager.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({super.key,required this.viewModel});
  final ArtistsTabViewModel viewModel;

  @override
  State<ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab> {
  String type = "random";
  bool ascending = true;
  int elementCount = 10;
  int offset = 0;
  List<String> filterSortList = ["random","50","0","ASC"];

  void reverseSort() {
    if (ascending == true) {
      setState(() {
        filterSortList = [type,elementCount.toString(),offset.toString(),"DESC"];
        ascending = false;
      });
    } else {
      setState(() {
        filterSortList = [type,elementCount.toString(),offset.toString(),"ASC"];
        ascending = true;
      });
    }
  }

  Widget buildListView(List<dynamic> items,BuildContext context,double screenWidth) {
    List<Widget> outerWidgetList = [];
    List<Widget> innerWidgetList = [];
    print(items.length);
    int index = 0;
    while (index < items.length) {
      outerWidgetList.add(Text(items[index]['name']));
      outerWidgetList.add(Divider());
      for (Map item in items[index]['artist']) {
        innerWidgetList.add(
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                debugPrint('Card tapped.');
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: item['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${item['coverArt']}",
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                      errorWidget: (context, url, error) => IconButton(
                        onPressed: () {
                          //hier retry
                        },
                        icon: Icon(Icons.error),
                      ),
                    ),
                  ),
                  Text(item['name']),
                  Text(item['id']),
                ],
              ),
            ),
          ),
        );
      }
      outerWidgetList.add(MasonryGrid(column: (screenWidth / 175).toInt(),children: new List.from(innerWidgetList),),);
      innerWidgetList.clear();//irgendwie wird das masonry grid dadurch unsichtbar klein
      index = index + 1;
    }
    print(outerWidgetList);
    return Expanded(child: SingleChildScrollView(child: Column(children: outerWidgetList,)));
  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    final Size screenSize = MediaQuery.sizeOf(context);
    final ValueNotifier<String> filterNotifier = ValueNotifier('');
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final artistList = ref.watch(riverpodManager.artistListProvider);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SearchFilterWidget(filterNotifier: filterNotifier),
                    Row(
                      children: [
                        Text("hier drop down menü"),
                        IconButton(
                          onPressed: () {
                            reverseSort();
                            ref.invalidate(riverpodManager.artistListProvider);
                          },
                          icon: (ascending
                              ? Icon(Icons.arrow_upward)
                              : Icon(Icons.arrow_downward)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              switch (artistList) {
                AsyncValue(:final value?) => ArtistGrid(artistListNullable: value,crossAxisCount: (screenSize.width / 175).toInt(),sliver: true, filterNotifier: filterNotifier,withIndexesGiven: true,),//noch schauen wie ich die index buchstaben einfügen kann
                //AsyncValue(:final value?) => SliverToBoxAdapter(child: buildListView(value, context, screenSize.width)),
                AsyncValue(error: != null) => SliverToBoxAdapter(child: Center(child: const Text("Error"))),
                AsyncValue() => SliverToBoxAdapter(child: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25))),
              },
            ],
          );
        },
      ),
    );
  }
}