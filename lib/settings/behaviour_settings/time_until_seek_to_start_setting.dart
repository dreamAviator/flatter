import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeUntilSeekToStartSetting extends StatelessWidget {
  const TimeUntilSeekToStartSetting({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = settingsControl.loadSetting('timeUntilSeekToStart').toString();
    return IntrinsicWidth(
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        maxLines: 1,
        decoration: const InputDecoration(
          hintText: "Seconds",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {//TODO:bad code, barely functional
          if (value.isEmpty) {

          } else {
            try {
              int intvalue = int.parse(value);
              if (intvalue >= -1) {

              }
              settingsControl.changeSetting('timeUntilSeekToStart',int.parse(value));
            } catch (e) {
              
            }
          }
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "Please enter a number";
          } else {
            try {
              int.parse(value);
              return null;
            } catch (e) {
              return "Please enter a number";
            }
          }
        },
      ),
    );
  }
}