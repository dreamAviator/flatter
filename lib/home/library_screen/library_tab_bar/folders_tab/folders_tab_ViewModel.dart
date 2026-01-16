import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ci.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';

class FoldersTabViewModel extends ChangeNotifier {
  String title = "Folders";
  List<List<dynamic>> startFolders = databaseControl.getFolders();//[[path,name,isFavorited]]
  List<List<dynamic>> toDisplay = [];//[[path,name,icontodisplay]]
  List<String> pathway = ["startfolders"];//[startfolders,

  FoldersTabViewModel() {
    openDefaultFolders();
  }

  void updateList() {
    notifyListeners();
  }

  Future<void> addFolder() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      databaseControl.addFolder(path);
    }
    while (pathway.length > 1) {
      pathway.removeLast();
    }
    openEntry(pathway[0]);
  }

  void leaveFolder() {
    print(pathway);
    print(pathway.length);
    if (pathway.length > 2) {
      pathway.removeLast();
      print(pathway);
    } else if (pathway.length == 2) {
      pathway.removeLast();
      openDefaultFolders();
      return;
    }
    openFolder(pathway.last);
  }

  Future<void> openEntry(String path) async {
    if (path == pathway[0]) {
      openDefaultFolders();
      return;
    } else if (await FileSystemEntity.isDirectory(path) == true) {
      pathway.add(path);
      openFolder(path);
    } else {
      playerControl.addItemAt(-1, path);
    }
  }

  void openFolder(String path) async {
    toDisplay.clear();
    Directory dir = Directory(path);
    List<FileSystemEntity> entries = await dir.list().toList();
    List<List<dynamic>> folders = [];
    List<List<dynamic>> files = [];
    for (FileSystemEntity entryEntity in entries) {
      String entry = entryEntity.path;
      int lastSlash = entry.lastIndexOf("/");
      String name = entry.substring(lastSlash + 1);
      if (await FileSystemEntity.isDirectory(entry)) {
        folders.add([entry,name,Icons.folder]);
      } else {
        if (entry.endsWith(".mp3") || entry.endsWith(".m4a") || entry.endsWith(".wav") || entry.endsWith(".ogg") || entry.endsWith(".opus") || entry.endsWith(".aac")) {
          files.add([entry, name, Icons.audio_file]);
        }
      }
    }
    for (List<dynamic> item in folders) {
      toDisplay.add(item);
    }
    for (List<dynamic> item in files) {
      toDisplay.add(item);
    }
    title = pathway.last;
    updateList();
  }

  void openDefaultFolders() {
    toDisplay.clear();
    List<List<dynamic>> favoriteFolders = [];
    List<List<dynamic>> normalFolders = [];
    for (List<dynamic> folder in startFolders) {
      if (folder[2] == true) {
        favoriteFolders.add(folder);
      } else {
        normalFolders.add(folder);
      }
    }
    favoriteFolders.sort((a,b) => a[0][1].compareTo(b[0][1]));
    normalFolders.sort((a,b) => a[0][1].compareTo(b[0][1]));
    for (List<dynamic> folder in favoriteFolders) {
      toDisplay.add([folder[0],folder[1],Icons.favorite]);
    }
    for (List<dynamic> folder in normalFolders) {
      toDisplay.add([folder[0],folder[1],Icons.folder]);
    }
    title = "Folders";
    updateList();
  }

  void threePoint(String path) {

  }
}