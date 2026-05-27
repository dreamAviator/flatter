import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  PlayButton({super.key});

  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: playerControl.playbackState,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final processingState = snapshot.data?.processingState ?? AudioProcessingState.idle;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (playing)
              IconButton(onPressed: playerControl.pause, icon: Icon(Icons.pause))
            else
              IconButton(onPressed: playerControl.play, icon: Icon(Icons.play_arrow))
          ],
        );
      }
    );
  }
}