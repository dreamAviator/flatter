import 'package:flatter/home/item_widgets/subsonic_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../main.dart';
import '../other_screens/artist_screen.dart';

class ArtistSelectWindow {
  static void showArtistSelectWindow(BuildContext context,List<dynamic> artistInfosLite) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          constraints: BoxConstraints(maxWidth: 560),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select artist"),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return MasonryGridView.count(
                  crossAxisCount: (constraints.maxWidth / 150).toInt(),
                  itemCount: artistInfosLite.length,
                  itemBuilder: (context,index) {
                    Map item = artistInfosLite[index];
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          debugPrint('Card tapped.');
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: item['id'])));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: FutureBuilder(
                                future: subsonicService.getArtistDetails(item['id']),
                                builder: (context, asyncSnapshot) {
                                  if (asyncSnapshot.hasData) {
                                    if (asyncSnapshot.data != null) {
                                      return SubsonicImage(coverArtID: asyncSnapshot.data!['coverArt'],type: "artist",prohibitLongPress: true,);
                                    } else {
                                      return Text("Error");
                                    }
                                  } else if (asyncSnapshot.hasError) {
                                    return Text("Error");
                                  } else {
                                    return LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 25);
                                  }
                                }
                              ),
                            ),
                            Text(item['name']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          )
          /*
          content: MasonryGridView.count(
            crossAxisCount: (screenSize.width / 200).toInt(),
            itemCount: artistInfosLite.length,
            itemBuilder: (context,index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistInfosLite[index]['id'])));
                  },
                  child: Column(
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final artistDetails = ref.watch(riverpodManager.artistDetailsProvider(artistInfosLite[index]['id']));
                          return AspectRatio(
                            aspectRatio: 1,
                            child: switch (artistDetails) {
                              AsyncValue(:final value?) => CachedNetworkImage(
                                imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${value['coverArt']}",
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 25),
                                errorWidget: (context, url, error) => IconButton(
                                  onPressed: () {
                                    //hier retry
                                  },
                                  icon: Icon(Icons.error),
                                ),
                              ),
                              AsyncValue(error: != null) => const Text("error"),
                              AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 25),
                            }
                          );
                        },
                      ),
                      Text(artistInfosLite[index]['name']),
                    ],
                  ),
                ),
              );
            },
          )

           */
        );
      }
    );
  }
}