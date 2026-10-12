import 'package:flatter/home/settings_screen/appearance_settings/accent_color_setting.dart';
import 'package:flatter/home/settings_screen/appearance_settings/automatic_rotation_override_setting.dart';
import 'package:flatter/home/settings_screen/appearance_settings/landscape_mode_setting.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:s_packages/s_disabled/s_disabled.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> automaticRotationOverride = ValueNotifier(settingsControl.loadSetting('automaticRotationOverride'));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SDisabled(
            isDisabled: true,
            child: ListTile(
              title: Text("Automatic rotation override"),
              subtitle: Text("Changes the look and layout of some things. Needs a restart to take full effect"),
              trailing: AutomaticRotationOverrideSetting(valueNotifier: automaticRotationOverride),
            ),
          ),
          SDisabled(
            isDisabled: true,
            child: ListTile(
              title: Text("Landscape"),
              subtitle: Text("Changes the look and layout of some things. Needs a restart to take full effect"),
              trailing: LandscapeModeSetting(valueNotifier: automaticRotationOverride),
            ),
          ),
          ListTile(
            title: Text("Accent Color"),
            subtitle: Text("Changes the accent color"),
            trailing: AccentColorSetting(),
          ),
          MaterialColorPicker(
            onColorChange: (Color color) {

            },
            selectedColor: Colors.red,
          ),
//hier jtz bspw wie viele spalten das album gridview haben soll
        /*//landscape
          ListTile(
            title: Text("Landscape"),
            subtitle: Text("Changes the look and layout of some things. Needs a restart to take full effect"),
            trailing: LandscapeModeSetting(valueNotifier: automaticRotationOverride,),
          ),
          ListTile(
            title: Text("Automatic rotation override"),
            subtitle: Text("Toggles if the layout should automatically change if you change the aspect ratio of the app"),
            trailing: AutomaticRotationOverrideSetting(valueNotifier: automaticRotationOverride,),
          )

         */
        ],
      ),
    );
  }
}