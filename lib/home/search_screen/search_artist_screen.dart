import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/item_widgets/artist_grid.dart';
import 'package:flatter/home/other_screens/artist_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../Riverpod/riverpod_manager.dart';
import '../../main.dart';
import '../item_widgets/item_menus.dart';

class SearchArtistScreen extends StatelessWidget {
  const SearchArtistScreen({super.key,required this.query});

  final String query;

  Widget buildArtistGrid(BuildContext context,List<dynamic>? artistsNullable,double screenWidth) {
    //hier halt das gridview, evt aus diesen imagecards
    //idk ob gridview.builder der call ist oder besser gesagt wann das nicht der call ist :shrug:
    List<dynamic> artists = [];
    if (artistsNullable == null || artistsNullable.isEmpty) {
      return const Text("No artists");
    }
    for (var value in artistsNullable) {
      artists.add(value);
    }
    List<Widget> widgetList = [];
    for (Map<dynamic,dynamic> artist in artists) {
      widgetList.add(
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artist['id'])));
            },
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${artist['coverArt']}",
                    progressIndicatorBuilder: (context, url, downloadProgress) => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    errorWidget: (context,url,error) => IconButton(
                      onPressed: () {
                        //hier retry
                      },
                      icon: const Icon(Icons.error),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(artist['name']),
                  trailing: ItemMenus(context).artistMenu(artist),
                ),
              ],
            ),
          ),
        )
      );
    }
    return MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All artists"),
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
            return ArtistGrid(artistListNullable: asyncSnapshot.data?['artist'], crossAxisCount: (screenSize.width / 175).toInt(), sliver: false,withIndexesGiven: false,);
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