import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProgressSlider extends StatelessWidget {
  ProgressSlider({super.key});


  Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          playerControl.mediaItem,
          AudioService.position,
              (mediaItem, position) => MediaState(mediaItem, position));

  @override
  Widget build(BuildContext context) {
    AudioService.position.listen((pos) {
      print("Neue Position: $pos");
    });
    playerControl.mediaItem.listen((data) {
      int duration = data?.duration?.inSeconds ?? 0;
      print("duration: $duration");
    });
    return StreamBuilder<MediaState>(
      stream: mediaStateStream,
      builder: (context, snapshot) {
        final Duration duration = snapshot.data?.mediaItem?.duration ?? Duration.zero;
        final Duration position = snapshot.data?.position ?? Duration.zero;
        return ActualSlider(duration: duration, position: position);
      },
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class ActualSlider extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  ActualSlider({
    super.key,
    required this.duration,
    required this.position,
    this.bufferedPosition = Duration.zero,
  });

  @override
  ActualSliderState createState() => ActualSliderState();
}

class ActualSliderState extends State<ActualSlider> {
  double? dragValue;
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    final value = min(
      dragValue ?? widget.position.inMilliseconds.toDouble(),
      widget.duration.inMilliseconds.toDouble(),
    );
    if (dragValue != null && !dragging) {
      dragValue = null;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(value.toInt().toString()),
          Slider(
            year2023: false,
            value: value,
            max: widget.duration.inSeconds.toDouble(),
            onChanged: (value) {

            },
            onChangeEnd: (value) {
              playerControl.seek(Duration(seconds: value.toInt()));
            },
          ),
          Text(widget.duration.toString())
        ],
      ),
    );
  }
}