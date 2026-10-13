import 'package:flatter/ui/settings_screen/appearance_settings/accent_color_setting.dart';
import 'package:flatter/ui/settings_screen/appearance_settings/automatic_color_override_setting.dart';
import 'package:flatter/ui/settings_screen/appearance_settings/automatic_rotation_override_setting.dart';
import 'package:flatter/ui/settings_screen/appearance_settings/landscape_mode_setting.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:s_packages/s_disabled/s_disabled.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAutomaticColorAvailable = settingsControl.loadSetting('isAutomaticColorAvailable');
    ValueNotifier<bool> automaticRotationOverride = ValueNotifier(settingsControl.loadSetting('automaticRotationOverride'));
    ValueNotifier<bool> automaticColorOverride = ValueNotifier(settingsControl.loadSetting('automaticColorOverride'));
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
          SDisabled(
            isDisabled: isAutomaticColorAvailable.opposite,
            child: ListTile(
              title: Text("Override automatic color"),
              subtitle: Text("If on, the automatic color pulled from your os will be ignored and you can choose a color below."),
              trailing: AutomaticColorOverrideSetting(valueNotifier: automaticColorOverride),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: automaticColorOverride,
            builder: (context, value, child) {
              return SDisabled(
                isDisabled: value.opposite,
                child: ListTile(
                  title: Text("Accent Color"),
                  subtitle: Text("Changes the accent color"),
                  trailing: AccentColorSetting(),
                ),
              );
            }
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