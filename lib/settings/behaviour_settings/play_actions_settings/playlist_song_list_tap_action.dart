import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class PlaylistSongListTapActionSetting extends StatefulWidget {
  const PlaylistSongListTapActionSetting({super.key});

  @override
  State<PlaylistSongListTapActionSetting> createState() => _PlaylistSongListTapActionSetting();
}

class _PlaylistSongListTapActionSetting extends State<PlaylistSongListTapActionSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'playNow',label: "Play now"),
        DropdownMenuEntry(value: 'playNext', label: "Play next"),
        DropdownMenuEntry(value: 'enqueue', label: "Enqueue"),
      ],
      initialSelection: settingsControl.settingsMap['playlistSongListTapAction'],
      onSelected: (value) {
        settingsControl.changeSetting('PlaylistSongListTapAction', value);
      },
    );
  }
}