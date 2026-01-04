import 'package:flatter/storage/database/folders_database.dart';
import 'package:flatter/storage/database/library_database.dart';

class DatabaseController {
  final LibraryDatabase library_db = LibraryDatabase();
  final FoldersDatabase folder_db = FoldersDatabase();

  DatabaseController() {
    print("boobies hehe");
  }
}