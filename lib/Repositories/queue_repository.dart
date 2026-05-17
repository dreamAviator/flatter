import 'package:flatter/main.dart';

class QueueRepository {
  final List<Map<dynamic,dynamic>> _queue = []; //[path or id or link,{metadata},current]

  void insertItem(Map<dynamic,dynamic> item,int position) {
    _queue.insert(position, item);
  }

  void addItem(Map<dynamic,dynamic> item) {
    _queue.add(item);
  }

  Future<void> removeItem(int position) async {
    if (_queue[position][2] == true) {
      await playerControl.skipToNext();
    }
    _queue.removeAt(position);
    return;
  }

  void clearQueue() {
    _queue.clear();
  }

  Map<dynamic,dynamic> getItemAtPos(int position) {
    return _queue[position];
  }

  List<Map<dynamic,dynamic>> getQueue() {
    return _queue;
  }

  int getQueueLength() {
    return _queue.length;
  }

  void makeCurrent(int index) {
    for (Map<dynamic,dynamic> item in _queue) {
      item[2] = false;
    }
    _queue[index][2] = true;
  }

  void shuffleQueue() {
    if (_queue.isEmpty) {
      return;
    }
    List<Map<dynamic,dynamic>> preQueue = [];
    Map<dynamic,dynamic> currentItem = {};
    List<Map<dynamic,dynamic>> endQueue = [];
    for (Map<dynamic,dynamic> item in _queue) {
      if (item[2] == true) {
        break;
      } else {
        preQueue.add(item);
      }
    }
    for (Map<dynamic,dynamic> item in preQueue) {
      _queue.remove(item);
    }
    currentItem = _queue[0];
    _queue.removeAt(0);
    for (Map<dynamic,dynamic> item in _queue) {
      if (item[2] == true) {
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