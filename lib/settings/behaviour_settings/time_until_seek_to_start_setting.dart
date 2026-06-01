import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeUntilSeekToStartSetting extends StatelessWidget {
  const TimeUntilSeekToStartSetting({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        maxLines: 1,
        decoration: const InputDecoration(
          hintText: "Seconds",
        ),
        onChanged: (value) {
          settingsControl.changeSetting('timeUntilSeekToStart',int.parse(value));
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
          return null;
        },
      ),
    );
  }
}