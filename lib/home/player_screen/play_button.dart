import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';

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
            if (processingState == AudioProcessingState.error)
              IconButton(onPressed: null, icon: Icon(Icons.error))
            else if (processingState == AudioProcessingState.buffering || processingState == AudioProcessingState.loading)
              IconButton(onPressed: null, icon: CircularProgressIndicator())
            else if (processingState == AudioProcessingState.idle)
              IconButton(onPressed: null, icon: Icon(Icons.stop))
            else
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