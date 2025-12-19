class QueueRepository {
  List<String> _queue = [];
  int currentIndex = 0;
  Future<void> addItem(String file,int position) async {
    if (position == -1) {
      _queue.add(file);
      print(_queue);
      return;
    }
    _queue.insert(position, file);
    print(_queue);
  }

  String getItemAtPos(int position) {
    return _queue[position];
  }

  String getCurrentItem() {
    return _queue[currentIndex];
  }
}