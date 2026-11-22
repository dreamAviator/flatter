import 'dart:developer';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';//TODO:regel um überall material_ui und nicht aterila von flutter oder cupertino zu importieren
import 'package:loading_animation_widget/loading_animation_widget.dart';//TODO:option um den ganzen cache zu leeren oder so irgendwo in den einstellungen. udn halt generell image cache manager einstellungen

class SubsonicImage extends StatelessWidget {
  const SubsonicImage({super.key,required this.coverArtID,this.height,this.width,this.type,this.prohibitLongPress});
  final String? coverArtID;
  final double? height;
  final double? width;
  final String? type;
  final bool? prohibitLongPress;

  @override
  Widget build(BuildContext context) {
    //log("building for the firstv tie");
    ////print(MaterialLocalizations.of(context));
    ////print(context.widget.runtimeType);
    ////print("subsonic image");
    UpdateNotifier updateNotifier = UpdateNotifier();
    SubsonicService subsonicService = SubsonicService();
    final int serverID = settingsControl.loadSetting('selectedServer');
    final String url = "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=$coverArtID}";
    final String cacheKey = "${serverID}_$coverArtID";

    Future<void> showImageDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete cache"),//TODO:hier auch andere actions, also zum ändern des bildes bspw
            content: SingleChildScrollView(
              child: Text('''
Delete the Cache for this image?
The image will have to be redownloaded.
Use this if the image is not up to date.
          '''),
            ),
            actions: [
              TextButton(
                child: Text("Delete cache"),
                onPressed: () {
                  cacheManager.removeFile("${serverID}_$coverArtID");
                  CachedNetworkImage.evictFromCache(url,cacheKey: cacheKey);
                  updateNotifier.notify();//does not work, vlt kompletter page rebuild? auch wenn das eigentlich unnötig viel arbeit ist
                  //log("should have rebuilt");
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Keep cache"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }

    Widget actualImage() {
      return CachedNetworkImage(
        imageUrl: url,
        progressIndicatorBuilder: (context,url,downloadProgress) {
          return LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 25);
        },
        errorBuilder: (contetx,url,error) {
          return Icon(Icons.error);//TODO:retry
        },
        cacheManager: cacheManager,
        cacheKey:cacheKey,
        //TODO:wie lange es gespeichert werden soll, man soll den cache leeren können, vielleicht auch für einzelne items
        height: height,
        width: width,
      );
    }

    if (coverArtID == null) {
      if (type == "album") {
        return Image.asset("lib/assets/images/navidrome-album-placeholder.webp",height: height,width: width,);
      } else if (type == "artist") {
        return Image.asset("lib/assets/images/navidrome-artist-placeholder.webp",height: height,width: width,);
      }
      return Image.asset("lib/assets/images/navidrome-album-placeholder.webp",height: height,width: width,);
    }
    if (prohibitLongPress == true) {
      return actualImage();
    } else {
      return ListenableBuilder(
        listenable: updateNotifier,
        builder: (BuildContext context, child) {
          //log("being rebuilt");
          ////print(context.widget.runtimeType);
          ////print("context was brlp");
          return Material(
            child: InkWell(//gesture detector funktioniert, aber dann gibt es halt keinen inkwell
              onLongPress: () {
                showImageDialog(context);
              },
              child: actualImage()
            ),
          );
        }
      );
    }

  }
}