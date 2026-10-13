import 'package:material_ui/material_ui.dart';

import '../../../../main.dart';

class UseMaterial3Setting extends StatelessWidget {
  const UseMaterial3Setting({super.key});

  @override
  Widget build(BuildContext context) {
    bool syncQueueWithServer = settingsControl.loadSetting('useMaterial3');
    return Switch(
      value: syncQueueWithServer,
      onChanged: (bool value) {
        settingsControl.changeSetting('useMaterial3', value);
        themeUpdateNotifier.notify();
      },
    );
  }
}