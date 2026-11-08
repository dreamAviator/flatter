import 'package:flutter/cupertino.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

import '../../../../main.dart';

class PlaylistSearchResultCountSetting extends StatelessWidget {
  const PlaylistSearchResultCountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomNumberPicker<num>(
      initialValue: settingsControl.loadSetting('playlistSearchResultsCount'),
      minValue: 1,
      step: 1,
      maxValue: 999,
      onValue: (num value) {
        if (value.runtimeType == int) {
          settingsControl.changeSetting('playlistSearchResultsCount', value);
        }
      },
    );
  }
}