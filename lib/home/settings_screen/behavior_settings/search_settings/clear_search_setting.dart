import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClearSearchSetting extends StatefulWidget {
  const ClearSearchSetting({super.key});

  @override
  State<ClearSearchSetting> createState() => _ClearSearchSettingState();
}

class _ClearSearchSettingState extends State<ClearSearchSetting> {
  @override
  Widget build(BuildContext context) {
    bool clearSearch = settingsControl.loadSetting('clearSearchOnExit');
    return Switch(
      value: clearSearch,
      onChanged: (bool value) {
        settingsControl.changeSetting('clearSearchOnExit', value);
        setState(() {
          clearSearch = value;
        });
      },
    );
  }

}