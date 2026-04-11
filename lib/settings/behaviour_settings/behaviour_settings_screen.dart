import 'package:flatter/settings/behaviour_settings/play_actions_settings/play_actions_settings_screen.dart';
import 'package:flatter/settings/behaviour_settings/start_tab_setting.dart';
import 'package:flutter/material.dart';

class BehaviourSettingsScreen extends StatelessWidget {
  const BehaviourSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Behaviour Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text("Start tab"),
            trailing: StartTabSetting(),
          ),
          ListTile(
            leading: Icon(Icons.play_arrow),
            title: Text("Play actions"),
            subtitle: Text("Configure the play button and swipe actions on various screens."),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayActionsSettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}