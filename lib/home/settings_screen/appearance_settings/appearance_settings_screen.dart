import 'package:flatter/home/settings_screen/appearance_settings/accent_color_setting.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

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
          ListTile(
            title: Text("Landscape"),
            subtitle: Text("Changes the look and layout of some things. Needs a restart to take full effect"),
            trailing: AccentColorSetting(),
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