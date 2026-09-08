import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class PersistentQueueSetting extends StatefulWidget {
  const PersistentQueueSetting({super.key,this.widgetDisabledNotifier});
  final ValueNotifier<bool>? widgetDisabledNotifier;

  @override
  State<PersistentQueueSetting> createState() => _PersistentQueueSettingState();
}

class _PersistentQueueSettingState extends State<PersistentQueueSetting> {
  @override
  Widget build(BuildContext context) {
    bool persistentQueue = settingsControl.loadSetting('persistentQueue');
    return Switch(
      value: persistentQueue,
      onChanged: (bool value) {
        widget.widgetDisabledNotifier!.value = value;
        settingsControl.changeSetting('persistentQueue', value);
        setState(() {
          persistentQueue = value;
        });
      },
    );
  }
}