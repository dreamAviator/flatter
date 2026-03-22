import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/library_tab_bar/artists_tab/artists_tab_ViewModel.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masonry_grid/masonry_grid.dart';

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
                  CachedNetworkImage(
                    imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${item['coverArt']}",
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => IconButton(
                      onPressed: () {
                        //hier retry
                      },
                      icon: Icon(Icons.error),
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
      print("inner widget list");
      print(innerWidgetList);
      outerWidgetList.add(MasonryGrid(column: (screenWidth / 150).toInt(),children: innerWidgetList,),);
      innerWidgetList.clear();//irgendwie wird das masonry grid dadurch unsichtbar klein
      index = index + 1;
    }
    print(outerWidgetList);
    return Expanded(child: SingleChildScrollView(child: Column(children: outerWidgetList,)));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final artistList = ref.watch(riverpodManager.artistListProvider);
          return Column(
            children: [
              ListTile(
                title: Text("uh"),
                subtitle: Text("hier suchleiste und filter stuff"),
              ),
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
              Expanded(
                child: switch (artistList) {
                  AsyncValue(:final value?) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(riverpodManager.artistListProvider);
                        },
                        child: Text("invalidate"),
                      ),
                      buildListView(value,context,screenSize.width),
                    ],
                  ),
                  AsyncValue(error: != null) => Center(child: const Text("Error")),
                  AsyncValue() => Center(child: const CircularProgressIndicator()),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}