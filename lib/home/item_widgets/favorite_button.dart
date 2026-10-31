import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Riverpod/riverpod_manager.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key,required this.songID,required this.albumID,required this.artistID});
  final String? songID;
  final String? albumID;
  final String? artistID;

  Icon decideIcon(bool? value) {
    if (value == true) {
      return const Icon(Icons.favorite);
    } else {
      return const Icon(Icons.favorite_border);
    }
  }

  @override
  Widget build(BuildContext context) {
    final riverpodManager = RiverpodManager();
    final SubsonicService subsonicService = SubsonicService();
    final UpdateNotifier updateNotifier = UpdateNotifier();
    if (songID == null && albumID == null && artistID == null) {
      return const IconButton(
        onPressed: null,
        icon: Icon(Icons.error),
      );
    }
    List<String?> ids = [songID,albumID,artistID];
    return ListenableBuilder(
      listenable: updateNotifier,
      builder: (context, child) {
        return FutureBuilder(
          future: subsonicService.checkStarred(songID, albumID, artistID),
          builder: (context,asyncSnapshot) {
            if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
              if (asyncSnapshot.data == null) {
                return IconButton(
                  onPressed: () {
                    updateNotifier.notify();
                  },
                  icon: Icon(Icons.error_outline),
                );
              }
              return IconButton(
                onPressed: () {
                  if (asyncSnapshot.data! == true) {
                    print("was unstarred");
                    subsonicService.starUnstar(false, songID, albumID, artistID);
                  } else {
                    print("was starred");
                    subsonicService.starUnstar(true, songID, albumID, artistID);
                  }
                  updateNotifier.notify();
                },
                icon: decideIcon(asyncSnapshot.data!),
              );
            } else if (asyncSnapshot.hasError) {
              return IconButton(
                onPressed: () {
                  updateNotifier.notify();
                },
                icon: Icon(Icons.error_outline),
              );
            } else {
              return IconButton(
                onPressed: () {

                },
                icon: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
              );
            }
          },
        );
      }
    );
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
            AsyncValue(error: != null) => const Icon(Icons.error),
            AsyncValue() => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
          },
        );
      },
    );
  }
}