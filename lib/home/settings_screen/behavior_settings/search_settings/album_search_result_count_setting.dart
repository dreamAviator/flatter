import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

class AlbumSearchResultCountSetting extends StatelessWidget {
  const AlbumSearchResultCountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomNumberPicker(
      initialValue: settingsControl.loadSetting('albumSearchResultsCount'),
      minValue: 1,
      step: 1,
      maxValue: 999,
      onValue: (num value) {
        if (value.runtimeType == int) {
          settingsControl.changeSetting('albumSearchResultsCount', value);
        }
      },
    );
  }
}