import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../main.dart';

class ImageCacheStalePeriodSetting extends StatelessWidget {
  const ImageCacheStalePeriodSetting({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomNumberPicker<num>(//TODO:überarbeiten glaube ich
      initialValue: Duration(seconds: settingsControl.loadSetting('cacheStalePeriod')).inDays,
      minValue: 0,
      step: 1,
      maxValue: 999,
      onValue: (num value) {
        if (value.runtimeType == int) {
          settingsControl.changeSetting('cacheStalePeriod', Duration(days: int.parse(value.toString())).inSeconds);
        }
      },
    );
  }
}