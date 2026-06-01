import 'package:flatter/settings/behaviour_settings/library_start_tab_setting.dart';
import 'package:flatter/settings/behaviour_settings/play_actions_settings/play_actions_settings_screen.dart';
import 'package:flatter/settings/behaviour_settings/start_tab_setting.dart';
import 'package:flatter/settings/behaviour_settings/time_until_seek_to_start_setting.dart';
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
      body: ListView(//hier space zwischen allen items machen
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text("Start tab"),
            trailing: StartTabSetting(),
          ),
          ListTile(
            title: Text("Library start tab"),
            trailing: LibraryStartTabSetting(),
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
          ListTile(
            title: Text("Time until seek to start"),
            trailing: TimeUntilSeekToStartSetting(),
            subtitle: Text("The time that has to be passed, until pressing the rewind key will seek to the start of the current item instead of skipping to the previous one. Put -1 to never seek to the start."),
          )
        ],
      ),
    );
  }
}