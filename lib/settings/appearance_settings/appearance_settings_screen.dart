import 'package:flatter/settings/appearance_settings/landscape_mode_setting.dart';
import 'package:flutter/material.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance Settings"),
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
//hier jtz bspw wie viele spalten das album gridview haben soll
          ListTile(
            title: Text("Landscape"),
            subtitle: Text("Changes the look and layout of some things."),
            trailing: LandscapeModeSetting(),
          )
        ],
      ),
    );
  }
}