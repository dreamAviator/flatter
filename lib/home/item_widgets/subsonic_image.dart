import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SubsonicImage extends StatelessWidget {
  const SubsonicImage({super.key,required this.coverArtID,this.height,this.width});
  final String coverArtID;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    SubsonicService subsonicService = SubsonicService();
    int serverID = settingsControl.loadSetting('selectedServer');
    return CachedNetworkImage(
      imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=$coverArtID}",
      progressIndicatorBuilder: (context,url,downloadProgress) {
        return LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25);
      },
      errorBuilder: (contetx,url,error) {
        return Icon(Icons.error);//TODO:retry
      },
      cacheKey:"${serverID}_$coverArtID",
      //TODO:height und width und so müssen da sein können
    );
  }
}