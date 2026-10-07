import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/settings_screen/server_settings/add_server_popup.dart';
import 'package:flatter/home/settings_screen/server_settings/server_list.dart';
import 'package:material_ui/material_ui.dart';

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
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Server"),
            onTap: () {
              AddServerPopup.showAddServerPopUp(context,null,null,null,null,null,riverpodManager);
            },
          ),
          const Divider(),
          ServerList(riverpodManager: riverpodManager,),
        ],
      ),
    );
  }
}