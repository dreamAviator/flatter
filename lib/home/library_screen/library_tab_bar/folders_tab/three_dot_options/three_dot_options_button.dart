import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
class SongOptionsButton extends StatefulWidget {
  const SongOptionsButton({super.key});

  @override
  State<SongOptionsButton> createState() => _SongOptionsButtonState();
}

 */

class SongOptionsButton extends StatelessWidget {

  void playNext() {
    print("play next");
    print(path);
  }

  void goToAlbum() {

  }

  void goToArtist() {

  }

  void moreOptions() {

  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: playNext,
          child: Text("Play next"),
        ),
        PopupMenuItem(
          onTap: goToAlbum,
          child: Text("Album"),
        ),
        PopupMenuItem(
          onTap: goToArtist,
          child: Text("Artist"),
        ),
        PopupMenuItem(
          onTap: moreOptions,
          child: Text("More options"),
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}