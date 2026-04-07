import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_card/image_card.dart';

class ArtistSelectWindow {
  static void showArtistSelectWindow(BuildContext context,List<String> artistIDs) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            Size screenSize = MediaQuery.sizeOf(context);
            return Consumer(
              builder: (context, ref, child) {
                final artistDetails = ref.watch()
                return CarouselView(
                  itemExtent: double.infinity,
                  children: [
                    TransparentImageCard(
                      imageProvider: CachedNetworkImageProvider(url),
                    )
                  ],
                );
              },
            )
          },
        );
      }
    );
  }
}