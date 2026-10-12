import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class AutomaticColorOverrideSetting extends StatefulWidget {
  const AutomaticColorOverrideSetting({super.key,required this.valueNotifier});
  final ValueNotifier<bool> valueNotifier;

  @override
  State<AutomaticColorOverrideSetting> createState() => _AutomaticColorOverrideSettingState();
}

class _AutomaticColorOverrideSettingState extends State<AutomaticColorOverrideSetting> {
  @override
  Widget build(BuildContext context) {
    bool automaticColorOveride = settingsControl.loadSetting('automaticColorOverride');
    return Switch(
      value: automaticColorOveride,
      onChanged: (bool value) {
        settingsControl.changeSetting('automaticColorOverride', value);
        setState(() {
          automaticColorOveride = value;
          widget.valueNotifier.value = value;
        });
      },
    );
  }
}