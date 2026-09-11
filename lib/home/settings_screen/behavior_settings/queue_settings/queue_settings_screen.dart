import 'package:flatter/main.dart';
import 'package:flatter/home/settings_screen/behavior_settings/queue_settings/persistent_queue_setting.dart';
import 'package:flatter/home/settings_screen/behavior_settings/queue_settings/sync_with_server_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_disabled/s_disabled.dart';
import 'package:flatter/useful_scripts.dart';

class QueueSettingsScreen extends StatefulWidget {
  const QueueSettingsScreen({super.key});

  @override
  State<QueueSettingsScreen> createState() => _QueueSettingsScreenState();
}

class _QueueSettingsScreenState extends State<QueueSettingsScreen> {
  final ValueNotifier<bool> widgetDisabledNotifier = ValueNotifier(settingsControl.loadSetting('persistentQueue'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(//hier space zwischen allen items machen
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text("Persistent queue"),
            trailing: PersistentQueueSetting(widgetDisabledNotifier: widgetDisabledNotifier,),
            subtitle: const Text("Reopen the last queue when exiting the app"),
          ),
          ValueListenableBuilder(
            valueListenable: widgetDisabledNotifier,
            builder: (BuildContext context,bool value,Widget? child) {
              return SDisabled(
                isDisabled: value.opposite(),
                child: ListTile(
                  title: const Text("Sync queue with server"),
                  trailing: SyncQueueWithServerSetting(),
                  subtitle: const Text("Save and load the queue to and from the server"),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}