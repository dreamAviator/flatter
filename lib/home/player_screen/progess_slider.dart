import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class ProgressSlider extends StatelessWidget {
  ProgressSlider({super.key});

  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, snapshot) {
        final int positionSeconds = snapshot.data?.inSeconds ?? 0;
        final int lengthSeconds = 0;
        return Slider(
          year2023: false,
          value: positionSeconds.toDouble(),
          onChanged: (value) {

          },
        );
      },
    );
  }
}