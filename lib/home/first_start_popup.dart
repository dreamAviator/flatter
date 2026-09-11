import 'package:flatter/home/settings_screen/server_settings/server_settings_screen.dart';
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
                    title: const Text("Add a server"),
                    onTap: () {
                      Navigator.of(context).pop();//idk, wenn da noch mehr kommt dann soll das obvs nicht weg
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