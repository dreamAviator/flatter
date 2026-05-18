import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';

class QueueRepository {
  final List<MediaItem> _queue = [];

  void insertItem(MediaItem item,int position) {
    _queue.insert(position, item);
  }

  void addItem(MediaItem item) {
    _queue.add(item);
  }

  Future<void> removeItem(int position) async {
    if (_queue[position].extras!['current'] == true) {
      await playerControl.skipToNext();
    }
    _queue.removeAt(position);
    return;
  }

  void clearQueue() {
    _queue.clear();
  }

  MediaItem getItemAtPos(int position) {
    return _queue[position];
  }

  List<MediaItem> getQueue() {
    return _queue;
  }

  int getQueueLength() {
    return _queue.length;
  }

  void makeCurrent(int index) {
    for (MediaItem item in _queue) {
      item.extras!['current'] = false;
    }
    _queue[index].extras!['current'] = true;
  }

  void shuffleQueue() {
    if (_queue.isEmpty) {
      return;
    }
    List<MediaItem> preQueue = [];
    MediaItem currentItem = MediaItem(id: "", title: "");
    List<MediaItem> endQueue = [];
    for (MediaItem item in _queue) {
      if (item.extras!['current'] == true) {
        break;
      } else {
        preQueue.add(item);
      }
    }
    for (MediaItem item in preQueue) {
      _queue.remove(item);
    }
    currentItem = _queue[0];
    _queue.removeAt(0);
    for (MediaItem item in _queue) {
      if (item.extras!['current'] == true) {
        break;
      } else {
        endQueue.add(item);
      }
    }
    _queue.clear();
    preQueue.shuffle();
    endQueue.shuffle();
    _queue.addAll(preQueue);
    _queue.add(currentItem);
    _queue.addAll(endQueue);
  }
}