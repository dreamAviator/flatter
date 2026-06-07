import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/settings/server_settings/add_server_popup.dart';
import 'package:flatter/settings/server_settings/server_list.dart';
import 'package:flatter/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';

class ServerSettingsScreen extends StatelessWidget {
  const ServerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RiverpodManager riverpodManager = RiverpodManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Server Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Add Server"),
            onTap: () {
              AddServerPopup.showAddServerPopUp(context,null,null,null,null,null,riverpodManager);
            },
          ),
          Divider(),
          ServerList(riverpodManager: riverpodManager,),
        ],
      ),
    );
  }
}