import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

class ArtistSearchResultCountSetting extends StatelessWidget {
  const ArtistSearchResultCountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomNumberPicker(
      initialValue: settingsControl.loadSetting('artistSearchResultsCount'),
      minValue: 1,
      step: 1,
      maxValue: 999,
      onValue: (int value) {
        settingsControl.changeSetting('artistSearchResultsCount', value);
      },
    );
  }
}