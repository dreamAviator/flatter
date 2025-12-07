class QueueRepository {
  List queue = [];
  Future<void> addItem(String file,int position) async {
    queue.insert(position, file);
  }
}