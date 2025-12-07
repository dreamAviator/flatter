import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class FoldersTabViewModel extends ChangeNotifier {
  String title = "Folders";
  String directoryString = "no directory selected";
  List<String> folders = [];//mwegen berechtigungen soll man einfach mehrere ordner hinzufügen, auf alle unterordner hat die app dann zugriff; man hat also eine liste mit den hinzugefügten ordnern.
  List<String> toDisplay = [];
  List<String> history = ["start"];

  Future<void> updateList(List<String> whattodisplay) async {
    toDisplay.clear();
    for (String item in whattodisplay) {
      toDisplay.add(item);
    }
    notifyListeners();
  }

  Future<void> addFolder() async {
    title = "yoo it changed";
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      folders.add(selectedDirectory);
    }
    updateList(folders);
  }

  Future<void> removeFolder(String directory) async {
    folders.remove(directory);
    notifyListeners();
  }

  Future<void> openFolder(String directory) async {
    var dir = Directory(directory);
    List<FileSystemEntity> entities = await dir.list().toList();
    List<String> stringEntities = [];
    for (FileSystemEntity item in entities) {
      stringEntities.add(item.path);
    }
    updateList(stringEntities);
  }

  Future<void> goIntoFolder(String directory) async {
    history.add(directory);
    openFolder(directory);
  }

  Future<void> leaveFolder() async {
    if (history.length > 2) {
      history.removeLast();
      openFolder(history.last);
    }
    else if (history.length == 2) {
      updateList(folders);
    }
  }
}