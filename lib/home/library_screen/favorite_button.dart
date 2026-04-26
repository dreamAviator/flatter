import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    if (songID == null && albumID == null && artistID == null) {
      return IconButton(
        onPressed: null,
        icon: Icon(Icons.error),
      );
    }
    return Consumer(
      builder: (context,ref,child) {
        final favoriteStatus = ref.watch(riverpodManager.favoriteStatusProvider([songID,albumID,artistID]));
        return IconButton.filled(
          onPressed: () {

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