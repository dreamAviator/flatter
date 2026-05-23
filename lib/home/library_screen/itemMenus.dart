import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class ItemMenus {
  ItemMenus(this.context);
  final BuildContext context;

  Widget songMenu(Map<dynamic,dynamic> song) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [

      ],
      child: Icon(Icons.more_vert),
    );
  }
  Widget albumMenu(Map<dynamic,dynamic> album) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [

      ],
      child: Icon(Icons.more_vert),
    );
  }
  Widget albumMenuList(Map<dynamic,dynamic> albumID) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [

      ],
      child: Icon(Icons.more_vert),
    );
  }
  Widget artistMenu(Map<dynamic,dynamic> artist) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [

      ],
      child: Icon(Icons.more_vert),
    );
  }
  Widget playlistMenu(Map<dynamic,dynamic> playlist) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [

      ],
      child: Icon(Icons.more_vert),
    );
  }
  Widget playlistMenuList(Map<dynamic,dynamic> playistID) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [

      ],
      child: Icon(Icons.more_vert),
    );
  }
}