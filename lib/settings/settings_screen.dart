import 'package:flatter/settings/appearance_settings/appearance_settings_screen.dart';
import 'package:flatter/settings/behaviour_settings/behaviour_settings_screen.dart';
import 'package:flatter/settings/server_settings/server_settings_screen.dart';
import 'package:flatter/settings/settings_screen_ViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'behaviour_settings/behaviour_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key,required this.viewModel});
  final SettingsScreenViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: //vlt hier anstelle der liste die karten nutzen. idk
      /*GridView.count(
        shrinkWrap: true,
        crossAxisCount: (screenSize.width / 100).toInt(),
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServerSettingsScreen()));
              },
              child: Column(
                children: [
                  Icon(Icons.storage),
                  Text("Server"),
                ],
              ),
            ),
          ),
        ],
      ),
      */
      ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(Icons.storage),
            title: Text("Server"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServerSettingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text("Behaviour"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BehaviourSettingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("Appearance"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AppearanceSettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}