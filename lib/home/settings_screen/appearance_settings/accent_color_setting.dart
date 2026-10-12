import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:s_packages/s_packages_extra1.dart';

class AccentColorSetting extends StatelessWidget {
  const AccentColorSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: IconButton(onPressed: () {}, icon: Icon(Icons.colorize)
      ),
    );
  }
}