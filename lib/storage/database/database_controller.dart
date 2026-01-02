import 'package:flatter/storage/database/database.dart';

class DatabaseController {
  final db = AppDatabase();

  void readsomething() {
    print(db.readsomething());
  }

  void writesomething() {
    db.writesomething();
  }
}