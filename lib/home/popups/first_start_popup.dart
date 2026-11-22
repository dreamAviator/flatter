import 'package:flatter/home/settings_screen/info_screen/info_screen.dart';
import 'package:flatter/home/settings_screen/server_settings/server_settings_screen.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class FirstStartPopup {
  static void showFirstStartPopup(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("First start"),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          content: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Welcome to flatter"),
                    Text("To start listening to your music, you can add a server in the server settings."),
                    ElevatedButton(
                      child: Text("Server settings"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServerSettingsScreen()));
                      },
                    ),
                    Text("This app is open source. More info to licenses and the source code is available from here."),
                    ElevatedButton(
                      child: Text("Info screen"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => InfoScreen()));
                      },
                    ),
                    Divider(),
                    ElevatedButton(
                      child: Text("Explore your library"),
                      onPressed: () {
                        settingsControl.changeSetting('firstStart', false);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}