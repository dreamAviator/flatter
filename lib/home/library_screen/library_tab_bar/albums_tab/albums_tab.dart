import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab_ViewModel.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key,required this.viewModel});
  final AlbumsTabViewModel viewModel;

  Widget buildListView(List<Map<String,dynamic>> items) {
    print("buildListView gets executed");
    print(items);
    List<Widget> widgetList = [];
    for (Map<String,dynamic> albumMap in items) {
      widgetList.add(
        Card(
          // clipBehavior is necessary because, without it, the InkWell's animation
          // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
          // This comes with a small performance cost, and you should not set [clipBehavior]
          // unless you need it.
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');//hier album öffnen, wäre cool wenn du diese card wird größer animation hinbekommst
            },
            child: Column(
              children: [
                Text(albumMap['id']),
                Text(albumMap['name']),
              ],
            )
          ),
        ),
      );
    }
    return ListView(shrinkWrap: true,children: widgetList,);
  }
  //später diese liste aus drop down menüs und den einstellungen kriegen und so
  static const List<String> filterSortList = ["random","10","0"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("uh"),
          subtitle: Text("hier sorting stuff und so, probably nd im listtile"),
        ),
        Consumer(
          builder: (context,ref,child) {
            final albumList = ref.watch(riverpodManager.albumListProvider(filterSortList));
            return Center(
              child: switch (albumList) {
                AsyncValue(:final value?) => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(riverpodManager.albumListProvider);
                      },
                      child: Text("invalidate"),
                    ),
                    buildListView(value),
                  ],
                ),
                AsyncValue(error: != null) => const Text("Error"),
                AsyncValue() => const CircularProgressIndicator(),
              },
            );
          },
        )
      ],
    );
  }
}