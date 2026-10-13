import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class LandscapeModeSetting extends StatefulWidget {
  const LandscapeModeSetting({super.key,required this.valueNotifier});
  final ValueNotifier<bool> valueNotifier;

  @override
  State<LandscapeModeSetting> createState() => _LandscapeModeSettingState();
}

class _LandscapeModeSettingState extends State<LandscapeModeSetting> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.valueNotifier,
      builder: (BuildContext context,bool value,child) {
        bool landscapeMode = settingsControl.loadSetting('landscapeMode');
        if (value == true) {
          return Switch(
            value: landscapeMode,
            onChanged: (bool value) {
              settingsControl.changeSetting('landscapeMode', value);
              setState(() {
                landscapeMode = value;
              });
            },
          );
        } else {
          return Switch(
            value: landscapeMode,
            onChanged: null,
          );
        }
      },
    );
    bool landscapeMode = settingsControl.loadSetting('landscapeMode');
    if (settingsControl.loadSetting('automaticRotationOverride') == false) {
      return Switch(
        value: landscapeMode,
        onChanged: null,
      );
    } else {
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
}