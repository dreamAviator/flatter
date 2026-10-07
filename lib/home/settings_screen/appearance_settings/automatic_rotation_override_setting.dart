import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class AutomaticRotationOverrideSetting extends StatefulWidget {
  const AutomaticRotationOverrideSetting({super.key,required this.valueNotifier});
  final ValueNotifier<bool> valueNotifier;

  @override
  State<AutomaticRotationOverrideSetting> createState() => _AutomaticRotationOverrideSettingState();
}

class _AutomaticRotationOverrideSettingState extends State<AutomaticRotationOverrideSetting> {
  @override
  Widget build(BuildContext context) {
    bool automaticRotationOverride = settingsControl.loadSetting('automaticRotationOverride');
    return Switch(
      value: automaticRotationOverride,
      onChanged: (bool value) {
        settingsControl.changeSetting('automaticRotationOverride', value);
        setState(() {
          automaticRotationOverride = value;
          widget.valueNotifier.value = value;
        });
      },
    );
  }
}