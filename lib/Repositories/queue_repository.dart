class QueueRepository {
  final List<List<dynamic>> _queue = [];//[path,[metadata],current]

  void insertItem(List<dynamic> item,int position) {
    _queue.insert(position, item);
  }

  void addItem(List<dynamic> item) {
    _queue.add(item);
  }

  void removeItem(int position) {
    _queue.removeAt(position);
  }

  void clearQueue() {
    _queue.clear();
  }

  List<dynamic> getItemAtPos(int position) {
    return _queue[position];
  }

  List<List<dynamic>> getQueue() {
    return _queue;
  }

  int getQueueLength() {
    return _queue.length;
  }

  void makeCurrent(int index) {
    for (List<dynamic> item in _queue) {
      item[2] = false;
    }
    _queue[index][2] = true;
  }

  void shuffleQueue() {
    if (_queue.isEmpty) {
      return;
    }
    List<List<dynamic>> preQueue = [];
    List<dynamic> currentItem = [];
    List<List<dynamic>> endQueue = [];
    for (List<dynamic> item in _queue) {
      if (item[2] == true) {
        break;
      } else {
        preQueue.add(item);
        _queue.remove(item);
      }
    }
    currentItem = _queue[0];
    _queue.removeAt(0);
    for (List<dynamic> item in _queue) {
      if (item[2] == true) {
        break;
      } else {
        endQueue.add(item);
        _queue.remove(item);
      }
    }
    preQueue.shuffle();
    endQueue.shuffle();
    _queue.addAll(preQueue);
    _queue.add(currentItem);
    _queue.addAll(endQueue);
  }
}