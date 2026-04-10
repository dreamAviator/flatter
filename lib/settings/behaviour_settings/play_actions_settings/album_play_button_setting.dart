import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class AlbumPlayButtonSetting extends StatefulWidget {
  const AlbumPlayButtonSetting({super.key});

  @override
  State<AlbumPlayButtonSetting> createState() => _AlbumPlayButtonSettingState();
}

class _AlbumPlayButtonSettingState extends State<AlbumPlayButtonSetting> {
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
      initialSelection: settingsControl.settingsMap['albumPlayButtonAction'],
      onSelected: (value) {
        settingsControl.changeSetting('albumPlayButtonAction', value);
      },
    );
  }
}