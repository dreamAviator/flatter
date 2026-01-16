import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';

class SettingsListViewmodel extends ChangeNotifier {
  List<Widget> settingsList = settingsControl.getSettingsOptions();
}