import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProgressSlider extends StatelessWidget {
  const ProgressSlider({super.key});

  Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          playerControl.mediaItem,
          AudioService.position,
              (mediaItem, position) => MediaState(mediaItem, position));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaState>(
      stream: mediaStateStream,
      builder: (context, snapshot) {
        final Duration duration = snapshot.data?.mediaItem?.duration ?? playerControl.getDuration() ?? Duration.zero;
        final Duration position = snapshot.data?.position ?? playerControl.getPosition();
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
  const ActualSlider({
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
      dragValue ?? widget.position.inSeconds.toDouble(),
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
          if (Duration(seconds: value.toInt()).toString().startsWith("0"))
            Text(Duration(seconds: value.toInt()).toString().split('.')[0].substring(2))
          else
            Text(Duration(seconds: value.toInt()).toString().split('.')[0]),
          Expanded(
            child: Slider(
              year2023: false,//wenn das zu false defaultet wegmachen
              value: value,
              max: widget.duration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  dragging = true;
                  dragValue = value;
                });
              },
              onChangeEnd: (value) {
                dragging = false;
                playerControl.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          if (widget.duration.toString().startsWith("0"))
            Text(widget.duration.toString().split('.')[0].substring(2))
          else

            Text(widget.duration.toString().split('.')[0]),
        ],
      ),
    );
  }
}