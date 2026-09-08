import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class SyncQueueWithServerSetting extends StatefulWidget {
  const SyncQueueWithServerSetting({super.key});

  @override
  State<SyncQueueWithServerSetting> createState() => _SyncQueueWithServerSettingState();
}

class _SyncQueueWithServerSettingState extends State<SyncQueueWithServerSetting> {
  @override
  Widget build(BuildContext context) {
    bool syncQueueWithServer = settingsControl.loadSetting('syncQueueWithServer');
    return Switch(
      value: syncQueueWithServer,
      onChanged: (bool value) {

        settingsControl.changeSetting('syncQueueWithServer', value);
        setState(() {
          syncQueueWithServer = value;
        });
      },
    );
  }
}