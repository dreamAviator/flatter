import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class LibraryStartTabSetting extends StatefulWidget {
  const LibraryStartTabSetting({super.key});

  @override
  State<LibraryStartTabSetting> createState() => _LibraryStartTabSettingState();
}

class _LibraryStartTabSettingState extends State<LibraryStartTabSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: -1,label: "Last opened"),
        DropdownMenuEntry(value: 0, label: "Playlists"),
        DropdownMenuEntry(value: 1, label: "Songs"),
        DropdownMenuEntry(value: 2, label: "Albums"),
        DropdownMenuEntry(value: 3, label: "Artists"),
      ],
      initialSelection: settingsControl.settingsMap['libraryTab'],
      onSelected: (value) {
        settingsControl.changeSetting('libraryTab', value);
      },
    );
  }
}