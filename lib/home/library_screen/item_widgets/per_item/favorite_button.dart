import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Riverpod/riverpod_manager.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key,required this.songID,required this.albumID,required this.artistID});
  final String? songID;
  final String? albumID;
  final String? artistID;

  Icon decideIcon(bool? value) {
    if (value == true) {
      return Icon(Icons.favorite);
    } else {
      return Icon(Icons.favorite_border);
    }
  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    if (songID == null && albumID == null && artistID == null) {
      return IconButton(
        onPressed: null,
        icon: Icon(Icons.error),
      );
    }
    List<String?> ids = [songID,albumID,artistID];
    return Consumer(
      builder: (context,ref,child) {
        final favoriteStatus = ref.watch(riverpodManager.favoriteStatusProvider(ids));
        return IconButton(
          onPressed: () {
            switch (favoriteStatus) {
              case(AsyncValue(:final value?)):
                if (value == true) {
                  print("was unstarred");
                  subsonicService.starUnstar(false, songID, albumID, artistID);
                } else {
                  print("was starred");
                  subsonicService.starUnstar(true, songID, albumID, artistID);
                }
                ref.invalidate(riverpodManager.favoriteStatusProvider(ids));
              case(AsyncValue(error: != null)):
                print("hier sollte eig eine richtige fehlermeldung kommen");
              case(AsyncValue()):
                //hier so eine toast notification
                print("boah mach mal nicht so schnell, wir sind noch nicht so weit");
            }
          },
          icon: switch (favoriteStatus) {
            AsyncValue(:final value?) => decideIcon(value),
            AsyncValue(error: != null) => Icon(Icons.error),
            AsyncValue() => Icon(Icons.pending),
          },
        );
      },
    );
  }
}