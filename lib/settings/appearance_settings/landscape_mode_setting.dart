import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class LandscapeModeSetting extends StatefulWidget {
  const LandscapeModeSetting({super.key});

  @override
  State<LandscapeModeSetting> createState() => _LandscapeModeSettingState();
}

class _LandscapeModeSettingState extends State<LandscapeModeSetting> {
  @override
  Widget build(BuildContext context) {
    bool landscapeMode = settingsControl.settingsMap['landscapeMode'];
    return Switch(
      value: landscapeMode,
      onChanged: (bool value) {
        settingsControl.changeSetting('landscapeMode', value);
        setState(() {
          landscapeMode = value;
        });
      },
    );
  }
}