import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({super.key});


  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {//TODO:hier oder in der progress bar eine ladeanzeige einfügen
  bool playing = playerControl.isPlayerPlaying();

  void togglePlayPause() {
    playerControl.togglePlayPause();
    if (playing == true) {
      setState(() {
        playing = false;
      });
    } else {
      setState(() {
        playing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      icon: (playing
        ? Icon(Icons.pause)
        : Icon(Icons.play_arrow)),
      onPressed: togglePlayPause,
    );
  }
}