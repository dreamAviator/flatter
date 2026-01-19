import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class SongOptionsButton extends StatelessWidget {
  const SongOptionsButton({super.key,required this.path});
  final String path;

  void addNext() {
    playerControl.addNext(path);
  }

  void goToAlbum() {

  }

  void goToArtist() {

  }

  void moreOptions() {

  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: addNext,
          child: Text("Add next"),
        ),
        PopupMenuItem(
          onTap: goToAlbum,
          child: Text("Album"),
        ),
        PopupMenuItem(
          onTap: goToArtist,
          child: Text("Artist"),
        ),
        PopupMenuItem(
          onTap: moreOptions,
          child: Text("More options"),
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}

class FolderOptionsButton extends StatelessWidget {
  const FolderOptionsButton({super.key,required this.path});
  final String path;

  void addNext() {
    playerControl.addNext(path);
  }

  void enqueue() {
    playerControl.addItem(path);
  }

  void addToFavorites() {
    databaseControl.changeFavouriteStatus(path);
  }

  void changeName() {

  }

  void moreOptions() {

  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: addNext,
          child: Text("Add next"),
        ),
        PopupMenuItem(
          onTap: addNext,
          child: Text("Enqueue"),
        ),
        PopupMenuItem(
          onTap: moreOptions,
          child: Text("More options"),
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}

class DefaultFolderOptionsButton extends StatelessWidget {
  const DefaultFolderOptionsButton({super.key,required this.path});
  final String path;

  void addNext() {
    playerControl.addNext(path);
  }

  void enqueue() {
    playerControl.addItem(path);
  }

  void addToFavorites() {
    databaseControl.changeFavouriteStatus(path);
  }

  void changeName() {

  }

  void moreOptions() {

  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: addNext,
          child: Text("Add next"),
        ),
        PopupMenuItem(
          onTap: addNext,
          child: Text("Enqueue"),
        ),
        PopupMenuItem(
          onTap: addToFavorites,
          child: Text("Add/Remove favorite"),
        ),
        PopupMenuItem(
          onTap: addToFavorites,
          child: Text("change Name"),
        ),
        PopupMenuItem(
          onTap: moreOptions,
          child: Text("More options"),
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}