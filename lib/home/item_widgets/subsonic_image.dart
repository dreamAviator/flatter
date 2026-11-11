import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SubsonicImage extends StatelessWidget {
  const SubsonicImage({super.key,required this.coverArtID,this.height,this.width,this.type});
  final String? coverArtID;
  final double? height;
  final double? width;
  final String? type;

  @override
  Widget build(BuildContext context) {
    SubsonicService subsonicService = SubsonicService();
    int serverID = settingsControl.loadSetting('selectedServer');
    if (coverArtID == null) {
      if (type == "album") {
        return Image.asset("lib/assets/images/navidrome-album-placeholder.webp",height: height,width: width,);
      } else if (type == "artist") {
        return Image.asset("lib/assets/images/navidrome-artist-placeholder.webp",height: height,width: width,);
      }
      return Image.asset("lib/assets/images/navidrome-album-placeholder.webp",height: height,width: width,);
    }
    return CachedNetworkImage(
      imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=$coverArtID}",
      progressIndicatorBuilder: (context,url,downloadProgress) {
        return LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25);
      },
      errorBuilder: (contetx,url,error) {
        return Icon(Icons.error);//TODO:retry
      },
      cacheKey:"${serverID}_$coverArtID",
//TODO:wie lange es gespeichert werden soll, man soll den cache leeren können, vielleicht auch für einzelne items
      height: height,
      width: width,
    );
  }
}