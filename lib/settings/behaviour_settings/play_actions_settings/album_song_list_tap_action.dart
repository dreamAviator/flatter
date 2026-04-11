import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class AlbumSongListTapActionSetting extends StatefulWidget {
  const AlbumSongListTapActionSetting({super.key});

  @override
  State<AlbumSongListTapActionSetting> createState() => _AlbumSongListTapActionSetting();
}

class _AlbumSongListTapActionSetting extends State<AlbumSongListTapActionSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'playNow',label: "Play now"),
        DropdownMenuEntry(value: 'playNext', label: "Play next"),
        DropdownMenuEntry(value: 'enqueue', label: "Enqueue"),
      ],
      initialSelection: settingsControl.settingsMap['albumSongListTapAction'],
      onSelected: (value) {
        settingsControl.changeSetting('albumSongListTapAction', value);
      },
    );
  }
}