import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_card/image_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../main.dart';
import 'artist_screen/artist_screen.dart';

class ArtistSelectWindow {//TODO:joa das hier machen nh :P
  static void showArtistSelectWindow(BuildContext context,List<dynamic> artistInfosLite) {
    final riverpodManager = RiverpodManager();
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              title: Text("Select artist"),
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
                                        LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                                    errorWidget: (context, url, error) => IconButton(
                                      onPressed: () {
                                        //hier retry
                                      },
                                      icon: Icon(Icons.error),
                                    ),
                                  ),
                                  AsyncValue(error: != null) => const Text("error"),
                                  AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
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
            );
          },
        );
      }
    );
  }
}