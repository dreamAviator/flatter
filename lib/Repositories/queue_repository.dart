class QueueRepository {
  List queue = [];
  Future<void> addItem(String file,int position) async {
    if (position == -1) {
      queue.add(file);
      print(queue);
      return;
    }
    queue.insert(position, file);
    print(queue);
  }

  String getItemAtPos(int position) {
    return queue[position];
  }
}