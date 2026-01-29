import 'dart:io';
import 'dart:core';

import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/three_dot_options/three_dot_options_buttons.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:saf_util/saf_util_platform_interface.dart';

class FoldersTabViewModel extends ChangeNotifier {
  String title = "Folders";
  List<List<dynamic>> startFolders = databaseControl.getFolders();//[[path,name,isFavorited]]
  List<List<dynamic>> toDisplay = [];//[[path,name,icontodisplay,threedotmenu]]
  List<String> pathway = ["startfolders"];//[startfolders,
  FoldersTabViewModel() {
    openDefaultFolders();
  }

  void updateList() {
    notifyListeners();
  }

  Future<void> addFolder() async {
    String? path = await directoryControl.openDirectory();
    if (path != null) {
      if (Platform.isAndroid) {
        SafDocumentFile? folder = await directoryControl.getDocumentDirectoryFromUri(path);
        if (folder != null) {
          String name = folder.name;
          databaseControl.addFolder(path, name);
        }
      } else {
        int lastSlash = path.lastIndexOf("/");
        String name = path.substring(lastSlash + 1);
        databaseControl.addFolder(path, name);
      }
    }
    while (pathway.length > 1) {
      pathway.removeLast();
    }
    openEntry(pathway[0]);
  }

  void leaveFolder() {
    if (pathway.length > 2) {
      pathway.removeLast();
    } else if (pathway.length == 2) {
      pathway.removeLast();
      openDefaultFolders();
      return;
    } else if (pathway.length == 1) {
      openDefaultFolders();
    }
    openFolder(pathway.last);
  }

  Future<void> openEntry(String path) async {
    if (path == pathway[0]) {
      openDefaultFolders();
      return;
    } else {
      if (Platform.isAndroid == true) {
        if (path.endsWith(".mp3") || path.endsWith(".m4a") || path.endsWith(".wav") || path.endsWith(".ogg") || path.endsWith(".opus") || path.endsWith(".aac")) {
          //metadataControl.loadFile(path);
          print(directoryControl.createTempFile(path));
          playerControl.addItem(path);
        } else {
          pathway.add(path);
          openFolder(path);
        }
      } else {
        if (await FileSystemEntity.isDirectory(path) == true) {
          pathway.add(path);
          openFolder(path);
        } else {
          playerControl.addItem(path);
        }
      }
    }
  }

  void openFolder(String path) async {
    if (path == pathway[0]) {
      openDefaultFolders();
      return;
    }
    toDisplay.clear();
    var entries = await directoryControl.getDirectoryContents(path);
    List<List<dynamic>> folders = [];
    List<List<dynamic>> files = [];
    if (Platform.isAndroid == false) {
      for (FileSystemEntity entryEntity in entries) {
        String entry = entryEntity.path;
        int lastSlash = entry.lastIndexOf("/");
        String name = entry.substring(lastSlash + 1);
        if (await FileSystemEntity.isDirectory(entry)) {
          folders.add(
              [entry, name, Icons.folder, FolderOptionsButton(path: entry)]
          );
        } else {
          if (entry.endsWith(".mp3") || entry.endsWith(".m4a") ||
              entry.endsWith(".wav") || entry.endsWith(".ogg") ||
              entry.endsWith(".opus") || entry.endsWith(".aac")) {
            files.add([
              entry,
              name,
              Icons.audio_file,
              SongOptionsButton(path: entry)
            ]);
          }
        }
      }
    } else {
      for (SafDocumentFile entryEntity in entries) {
        String path = entryEntity.uri;
        String name = entryEntity.name;
        bool isDir = entryEntity.isDir;
        if (isDir == true) {
          folders.add(
            [path,name,Icons.folder,FolderOptionsButton(path: path)]
          );
        } else {
          if (path.endsWith(".mp3") || path.endsWith(".m4a") ||
              path.endsWith(".wav") || path.endsWith(".ogg") ||
              path.endsWith(".opus") || path.endsWith(".aac")) {
            files.add([
              path,
              name,
              Icons.audio_file,
              SongOptionsButton(path: path)
            ]);
          }
        }
      }
    }
    for (List<dynamic> item in folders) {
      toDisplay.add(item);
    }
    for (List<dynamic> item in files) {
      toDisplay.add(item);
    }
    if (Platform.isAndroid == true) {
      SafDocumentFile? documentDirectory = await directoryControl.getDocumentDirectoryFromUri(pathway.last);
      if (documentDirectory != null) {
        title = documentDirectory.name;
      }
    } else {
      int lastSlash = pathway.last.lastIndexOf("/");
      String name = pathway.last.substring(lastSlash + 1);
      title = name;
    }
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
      toDisplay.add([folder[0],folder[1],Icons.favorite,DefaultFolderOptionsButton(path: folder[0])]);
    }
    for (List<dynamic> folder in normalFolders) {
      toDisplay.add([folder[0],folder[1],Icons.folder,DefaultFolderOptionsButton(path: folder[0])]);
    }
    title = "Folders";
    updateList();
  }
}