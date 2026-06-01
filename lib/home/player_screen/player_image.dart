import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rxdart/rxdart.dart';

class PlayerImage extends StatelessWidget {
  const PlayerImage({super.key,required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: playerControl.mediaItem,
      builder: (context, snapshot) {
        final coverID = snapshot.data?.extras?['coverArt'];
        if (coverID == null) {
          return Image.asset("lib/assets/images/empty_player.png",height: height,);
        } else {
          return CachedNetworkImage(
            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=$coverID",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            errorWidget: (context, url, error) => IconButton(
              onPressed: () {
                //hier retry
              },
              icon: Icon(Icons.error),
            ),
            height: height,
            width: height,
          );
        }
      },
    );
  }
}