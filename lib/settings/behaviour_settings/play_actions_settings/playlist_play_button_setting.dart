import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class PlaylistPlayButtonSetting extends StatefulWidget {
  const PlaylistPlayButtonSetting({super.key});

  @override
  State<PlaylistPlayButtonSetting> createState() => _PlaylistPlayButtonSettingState();
}

class _PlaylistPlayButtonSettingState extends State<PlaylistPlayButtonSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'playNow',label: "Play now"),
        DropdownMenuEntry(value: 'playNext', label: "Play next"),
        DropdownMenuEntry(value: 'enqueue', label: "Enqueue"),
        DropdownMenuEntry(value: 'playNowShuffled', label: "Play now shuffled"),
        DropdownMenuEntry(value: 'playNextShuffled', label: "Play next shuffled"),
        DropdownMenuEntry(value: 'enqueueShuffled', label: "Enqueue shuffled"),
      ],
      initialSelection: settingsControl.settingsMap['playlistPlayButtonAction'],
      onSelected: (value) {
        settingsControl.changeSetting('playlistPlayButtonAction', value);
      },
    );
  }
}