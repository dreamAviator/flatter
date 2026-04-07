import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class StartTabSetting extends StatefulWidget {
  const StartTabSetting({super.key});

  @override
  State<StartTabSetting> createState() => _StartTabSettingState();
}

class _StartTabSettingState extends State<StartTabSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: [
        DropdownMenuEntry(value: -1,label: "Last opened"),
        DropdownMenuEntry(value: 0, label: "Library"),
        DropdownMenuEntry(value: 1, label: "Player"),
        DropdownMenuEntry(value: 2, label: "Queue"),
      ],
      initialSelection: settingsControl.settingsMap['startTab'],
      onSelected: (value) {
        settingsControl.changeSetting('startTab', value);
      },
    );
  }
}