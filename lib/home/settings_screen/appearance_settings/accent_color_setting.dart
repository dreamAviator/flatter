import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';

class AccentColorSetting extends StatefulWidget {
  const AccentColorSetting({super.key});

  @override
  State<AccentColorSetting> createState() => _AccentColorSettingState();
}

class _AccentColorSettingState extends State<AccentColorSetting> {
  @override
  Widget build(BuildContext context) {
    return Expanded(//TODO:naja
      child: Container(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}