import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player/audio_player.dart';
import 'package:flutter/cupertino.dart';

class PlayerScreenViewModel extends ChangeNotifier {
  PlayerScreenViewModel({required QueueRepository queueRepository}) : _queueRepository = queueRepository;
  final player = MyPlayer();
  final QueueRepository _queueRepository;

  Future<void> setSource() async {
    await player.setSource(queueRepository.getItemAtPos(0));
  }

  Future<void> play() async {
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }
}