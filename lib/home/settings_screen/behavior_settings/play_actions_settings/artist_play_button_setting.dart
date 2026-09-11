import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class ArtistPlayButtonSetting extends StatefulWidget {
  const ArtistPlayButtonSetting({super.key});

  @override
  State<ArtistPlayButtonSetting> createState() => _ArtistPlayButtonSettingState();
}

class _ArtistPlayButtonSettingState extends State<ArtistPlayButtonSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 'playNow',label: "Play now"),
        DropdownMenuEntry(value: 'playNext', label: "Play next"),
        DropdownMenuEntry(value: 'enqueue', label: "Enqueue"),
        DropdownMenuEntry(value: 'playNowShuffled', label: "Play now shuffled"),
        DropdownMenuEntry(value: 'playNextShuffled', label: "Play next shuffled"),
        DropdownMenuEntry(value: 'enqueueShuffled', label: "Enqueue shuffled"),
      ],
      initialSelection: settingsControl.settingsMap['artistPlayButtonAction'],
      onSelected: (value) {
        settingsControl.changeSetting('artistPlayButtonAction', value);
      },
    );
  }
}