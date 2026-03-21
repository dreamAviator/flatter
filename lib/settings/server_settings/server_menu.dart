import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerMenu {
  final BuildContext context;
  ServerMenu(this.context);

  Widget serverMenu(int id) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        PopupMenuItem(
          child: Text("Edit"),
          onTap: () {
            //hier edit somehow
          },
        ),
        PopupMenuItem(
          child: Text("Remove/Delete"),//entscheiden
          onTap: () {
            //hier irgendwie löschen und dann den ref invalidieren, idk wie
          },
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}