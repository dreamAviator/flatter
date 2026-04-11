import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class SongsTabTapActionSetting extends StatefulWidget {
  const SongsTabTapActionSetting({super.key});

  @override
  State<SongsTabTapActionSetting> createState() => _SongsTabTapActionSetting();
}

class _SongsTabTapActionSetting extends State<SongsTabTapActionSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'playNow',label: "Play now"),
        DropdownMenuEntry(value: 'playNext', label: "Play next"),
        DropdownMenuEntry(value: 'enqueue', label: "Enqueue"),
      ],
      initialSelection: settingsControl.settingsMap['songsTabTapAction'],
      onSelected: (value) {
        settingsControl.changeSetting('songsTabTapAction', value);
      },
    );
  }
}