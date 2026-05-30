import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class ProgressSlider extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangedEnd;
  ProgressSlider({
    super.key,
    required this.duration,
    required this.position,
    this.bufferedPosition = Duration.zero,
    this.onChanged,
    this.onChangedEnd,
  });

  @override
  ProgressSliderState createState() => ProgressSliderState();
}

class ProgressSliderState extends State<ProgressSlider> {
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
            value: value,
            max: widget.duration.inSeconds.toDouble(),
            onChanged: (value) {

            },
          ),
          Text(widget.duration.toString())
        ],
      ),
    );
  }
}