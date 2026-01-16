import 'package:flatter/main.dart';
import 'package:flatter/settings/settings_screen.dart';
import 'package:flatter/settings/settings_screen_ViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerScreenViewModel extends ChangeNotifier {

  Future<void> setSource() async {
    playerControl.playSpecificFromQueue(0);
  }

  Future<void> play() async {
    playerControl.play();
  }

  Future<void> pause() async {
    playerControl.pause();
  }

  Future<void> togglePlayPause() async {
    playerControl.togglePlayPause();
  }

  Future<void> rewind() async {
    playerControl.rewind();
  }

  Future<void> skip() async {
    playerControl.skip();
  }
}