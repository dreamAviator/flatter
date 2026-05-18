/*
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: addNext,
          child: Text("Add next"),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: goToAlbum,
          child: Text("Album"),
        ),
        PopupMenuItem(
          onTap: goToArtist,
          child: Text("Artist"),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {
            showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (BuildContext context) {
                  return SizedBox(
                    child: Center(
                      child: Text("More options"),
                    ),
                  );
                }
            );
          },
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
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {
            showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (BuildContext context) {
                  return SizedBox(
                    child: Center(
                      child: Text("More options"),
                    ),
                  );
                }
            );
          },
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
    databaseControl.changeFolderFavouriteStatus(path);
  }

  void remove() {
    databaseControl.removeFolder(path);
  }

  void changeName(String name) {

    databaseControl.changeFolderName(path, name);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
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
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: addToFavorites,
          child: Text("Add/Remove favorite"),
        ),
        PopupMenuItem(
          onTap: remove,
          child: Text("Remove"),
        ),
        PopupMenuItem(
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name (leave empty to reset)",
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            changeName(controller.text);
                            Navigator.pop(context);
                          },
                          child: Text("Confirm"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
          child: Text("Rename"),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return SizedBox(
                  child: Center(
                    child: Text("More options"),
                  ),
                );
              }
            );
          },
          child: Text("More options"),
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}

 */