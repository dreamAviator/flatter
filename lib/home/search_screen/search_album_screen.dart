import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/item_widgets/album_grid.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../../main.dart';
import '../other_screens/album_screen.dart';
import '../item_widgets/item_menus.dart';

class SearchAlbumScreen extends StatelessWidget {
  const SearchAlbumScreen({super.key,required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All albums"),
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
            return AlbumGrid(albumListNullable: asyncSnapshot.data?['album'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: false);
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