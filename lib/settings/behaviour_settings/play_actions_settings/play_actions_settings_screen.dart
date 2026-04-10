import 'package:flatter/settings/behaviour_settings/play_actions_settings/album_play_button_setting.dart';
import 'package:flutter/material.dart';

class PlayActionsSettingsScreen extends StatelessWidget {
  const PlayActionsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Action Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text("Album play button action"),
            subtitle: Text("Configure what happens, when you click the play button on the album screen"),
            trailing: AlbumPlayButtonSetting(),
          ),
          ListTile(
            title: Text("Playlist play button action"),
            subtitle: Text("Configure what happens, when you click the play button on the playlist screen"),
            trailing: AlbumPlayButtonSetting(),
          ),
        ],
      ),
    );
  }
}