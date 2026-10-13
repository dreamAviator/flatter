import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:s_packages/s_packages_extra1.dart';

class AccentColorSetting extends StatefulWidget {
  const AccentColorSetting({super.key});

  @override
  State<AccentColorSetting> createState() => _AccentColorSettingState();
}

class _AccentColorSettingState extends State<AccentColorSetting> {
  Color accentSeedColor = Color(settingsControl.loadSetting('accentSeedColor'));

  @override
  Widget build(BuildContext context) {
    Future<void> getPickedColor(BuildContext context) async {
      final Color pickedColor = await showColorPickerDialog(
        context,
        accentSeedColor,
        pickersEnabled: {
          ColorPickerType.accent:false,
        },
        title: Text("Pick an accent color"),
        enableShadesSelection: false,
        showMaterialName: true,
      );
      settingsControl.changeSetting('accentSeedColor', pickedColor.toARGB32());
      setState(() {
        accentSeedColor = pickedColor;
      });
      themeUpdateNotifier.notify();
    }
    return Container(
      color: accentSeedColor,
      child: IconButton(
        icon: Icon(Icons.color_lens_outlined,color: accentSeedColor.inverse),
        onPressed: () {
          getPickedColor(context);
        }
      )
    );
  }
}