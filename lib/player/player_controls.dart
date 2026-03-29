import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flatter/main.dart';
import 'package:flatter/player/audio_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:saf_util/saf_util_platform_interface.dart';

class PlayerControls extends BaseAudioHandler with QueueHandler, SeekHandler {
  final player = MyPlayer();
  final QueueRepository queueRepository = QueueRepository();

  bool playing = false;


  //player controls
  void setSource(int index) {
    mediaItem.add(MediaItem(id: getQueue()[index][0], title: getQueue()[index][0]));
    player.setSource(getQueue()[index][0]);//sets the source to item at index
  }

  void togglePlayPause() {
    if (isPlayerPlaying() == false) {
      play();
    } else {
      pause();
    }
  }

  bool isPlayerPlaying() {
    return player.playerState().playing;
  }

  @override
  Future<void> play() async {//TODO:das hier besser machen, also so, dass buffering und loading und ready gut reflektiert werden etc (sollte in der progressbar sein)
    if (player.playerState().processingState == ProcessingState.idle) {
      setSource(0);
      player.play();
    } else {
      player.play();
    }
    playbackState.add(PlaybackState(
      playing: playing,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      updatePosition: Duration(seconds: 0),
      speed: 1.0,
      queueIndex: getCurrentIndex(),
    ));
  }

  @override
  Future<void> pause() async {
    player.pause();
    playbackState.add(playbackState.value.copyWith(playing: playing,controls: [MediaControl.skipToPrevious,MediaControl.play,MediaControl.skipToNext]));
  }

  @override
  Future<void> seek(Duration position) async {
    player.seek(position);
  }

  @override
  Future<void> rewind() async {
    //hier seek zum anfang des songs oder vorheriger song
    if (true) {
      makeCurrent(getCurrentIndex() - 1);
    }
    setSource(getCurrentIndex());
    play();
  }

  @override
  Future<void> skipToNext() async {
    makeCurrent(getCurrentIndex() + 1);
    setSource(getCurrentIndex());
    play();
  }//vlt ein skip to oder so einfügen

  //playlist controls
  void clearQueue() {
    queueRepository.clearQueue();
  }

  int getCurrentIndex() {
    List<List<dynamic>> queue = getQueue();
    for (int index = 0; index <= getQueueLength(); index++) {
      if (queue.isNotEmpty) {
        if (queue[index][2] == true) {
          return index;
        }
      }
    }
    return -1;
  }

  void playSpecificFromQueue(int index) {
    player.setSource(queueRepository.getItemAtPos(index)[0]);
  }

  void insertItemAt(int position, String file) async {
    bool current = false;
    if (getQueueLength() == 0) {
      current = true;
      position = 0;
    }
    List<dynamic> item = await getMetadata(file);
    item.add(current);
    print("adding now");
    print(position);
    print(file);
    queueRepository.insertItem(item, position);
  }

  Future<void> addItem(String path) async {
    if (await FileSystemEntity.isDirectory(path) == true) {
      Directory dir = Directory(path);
      List<FileSystemEntity> entries = await dir.list().toList();
      for (FileSystemEntity entryEntity in entries) {
        String entryPath = entryEntity.path;
        if (await FileSystemEntity.isDirectory(entryPath)) {
          await addNext(entryPath);
        } else {
          if (entryPath.endsWith(".mp3") || entryPath.endsWith(".m4a") || entryPath.endsWith(".wav") || entryPath.endsWith(".ogg") || entryPath.endsWith(".opus") || entryPath.endsWith(".aac")) {
            insertItemAt(getQueueLength(), entryPath);
          }
        }
      }
      return;
    } else {
      /*
      if (path.endsWith(".mp3") || path.endsWith(".m4a") || path.endsWith(".wav") || path.endsWith(".ogg") || path.endsWith(".opus") || path.endsWith(".aac")) {
        insertItemAt(getQueueLength(), path);
      }

       */
      insertItemAt(getQueueLength(), path);
    }
    return;
  }

  Future<void> addNext(String path) async {
    if (await FileSystemEntity.isDirectory(path) == true) {
      Directory dir = Directory(path);
      List<FileSystemEntity> entries = await dir.list().toList();
      for (FileSystemEntity entryEntity in entries) {
        String entryPath = entryEntity.path;
        if (await FileSystemEntity.isDirectory(entryPath)) {
          await addNext(entryPath);
        } else {
          if (entryPath.endsWith(".mp3") || entryPath.endsWith(".m4a") || entryPath.endsWith(".wav") || entryPath.endsWith(".ogg") || entryPath.endsWith(".opus") || entryPath.endsWith(".aac")) {
            insertItemAt(getCurrentIndex() + 1, entryPath);
          }
        }
      }
      return;
    } else {
      if (path.endsWith(".mp3") || path.endsWith(".m4a") || path.endsWith(".wav") || path.endsWith(".ogg") || path.endsWith(".opus") || path.endsWith(".aac")) {
        insertItemAt(getCurrentIndex() + 1, path);
      }
    }
    return;
  }

  List<List<dynamic>> getQueue() {
    return queueRepository.getQueue();
  }

  int getQueueLength() {
    return queueRepository.getQueueLength();
  }

  void moveItem(int oldIndex,int newIndex) {
    final List<dynamic> item = queueRepository.getItemAtPos(oldIndex);
    queueRepository.removeItem(oldIndex);
    queueRepository.insertItem(item, newIndex);
  }

  void makeCurrent(int index) {
    queueRepository.makeCurrent(index);
  }

  //metadata
  Future<List<dynamic>> getMetadata(String path) async {
    String name = "";
    String artist = "";
    if (true == false) {
      //halt checken, ob es eine lokale datei ist
      if (Platform.isAndroid == false) {
        int lastSlash = path.lastIndexOf("/");
        name = path.substring(lastSlash + 1);
      }
    } else {
      Map<dynamic,dynamic> metadata = await subsonicService.getSongDetails(path);
      name = metadata['title'];
      artist = metadata['artist'];
    }
    return [path,[name,artist]];
  }
}