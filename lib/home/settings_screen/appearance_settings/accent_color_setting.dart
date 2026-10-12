import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:s_packages/s_packages_extra1.dart';

class AccentColorSetting extends StatefulWidget {
  const AccentColorSetting({super.key,required this.valueNotifier});
  final ValueNotifier<bool> valueNotifier;

  @override
  State<AccentColorSetting> createState() => _AccentColorSettingState();
}

class _AccentColorSettingState extends State<AccentColorSetting> {
  @override
  Widget build(BuildContext context) {

    Future<void> getPickedColor(BuildContext context) async {
      final Color pickedColor = await showColorPickerDialog(
        context,
        Color(settingsControl.loadSetting('accentSeedColor')),
        title: Text("Pick an accent color"),
        enableShadesSelection: false,
        showMaterialName: true,

      );
      settingsControl.changeSetting('accentSeedColor', pickedColor.toARGB32());
    }

    return ValueListenableBuilder(
      valueListenable: widget.valueNotifier,
      builder: (BuildContext context,bool value, child) {
        if (value == true) {
          return Container(
              color: Color(settingsControl.loadSetting('accentSeedColor')),
              child: IconButton(
                icon: Icon(Icons.color_lens_outlined,color: Color(settingsControl.loadSetting('accentSeedColor')).inverse,),
                onPressed: () {
                  getPickedColor(context);
                },
              )
          );
        } else {
          return Container(
              color: Color(settingsControl.loadSetting('accentSeedColor')),
              child: IconButton(
                icon: Icon(Icons.color_lens_outlined,color: Color(settingsControl.loadSetting('accentSeedColor')).inverse,),
                onPressed: null,
              )
          );
        }
      }
    );
  }
}