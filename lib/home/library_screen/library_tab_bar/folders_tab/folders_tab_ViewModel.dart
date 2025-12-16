import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flatter/Repositories/queue_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoldersTabViewModel extends ChangeNotifier {
  FoldersTabViewModel({required QueueRepository queueRepository}) : _queueRepository = queueRepository;
  String title = "Folders";
  String directoryString = "no directory selected";
  List<String> folders = [];//mwegen berechtigungen soll man einfach mehrere ordner hinzufügen, auf alle unterordner hat die app dann zugriff; man hat also eine liste mit den hinzugefügten ordnern.
  List<List<dynamic>> toDisplay = [];
  List<String> history = ["start"];
  final QueueRepository _queueRepository;

  Future<void> updateList(List<String> whattodisplay) async {
    toDisplay.clear();
    for (String item in whattodisplay) {
      Icon iconToDisplay = Icon(Icons.folder);
      if (await FileSystemEntity.isDirectory(item) == false) {
        iconToDisplay = Icon(Icons.audio_file);
      }
      toDisplay.add([item,iconToDisplay]);
    }
    notifyListeners();
  }

  Future<void> addFolder() async {
    title = "yoo it changed";
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      folders.add(selectedDirectory);
      history.clear();
      updateList(folders);
    }
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

  Future<void> openEntry(String path) async {
    if (await FileSystemEntity.isDirectory(path) == true) {
      history.add(path);
      openFolder(path);
    }
    else {
      _queueRepository.addItem(path, -1);
    }
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