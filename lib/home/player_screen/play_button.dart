import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: playerControl.playbackState,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final processingState = snapshot.data?.processingState ?? AudioProcessingState.idle;
        //print("processing state and then playing yes no");
        //print(processingState);
        //print(playing);
        //print("done");
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (processingState == AudioProcessingState.error)
              IconButton(onPressed: null, icon: Icon(Icons.error))
            else if (processingState == AudioProcessingState.loading)//etwas für buffering hinzugügen, beim buffering kann es ja durchaus noch abspielen
              IconButton(onPressed: null, icon: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25))
            //else if (processingState == AudioProcessingState.idle)
              //IconButton(onPressed: null, icon: Icon(Icons.stop))
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