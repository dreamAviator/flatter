import 'package:flatter/settings/server_settings/server_settings_screen.dart';
import 'package:flutter/material.dart';

class FirstStartPopup {
  static void showFirstStartPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              title: const Text("First start"),
              content: Column(
                children: [
                  SingleChildScrollView(
                    child: Text("This is shown on the first start of the app"),
                  ),
                  ListTile(
                    title: Text("Add a server"),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServerSettingsScreen()));
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}