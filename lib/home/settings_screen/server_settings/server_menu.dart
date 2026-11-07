import 'package:flatter/main.dart';
import 'package:flatter/home/settings_screen/server_settings/add_server_popup.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Riverpod/riverpod_manager.dart';

class ServerMenu {
  final BuildContext context;
  final int id;
  final UpdateNotifier updateNotifier;
  ServerMenu(this.context,this.id,this.updateNotifier);

  Widget serverMenu() {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        PopupMenuItem(
          child: const Text("Edit"),
          onTap: () {
            List<String> serverInfo = databaseControl.getServerByID(id);
            AddServerPopup.showAddServerPopUp(context, serverInfo[3], serverInfo[0], serverInfo[1], serverInfo[2], id, updateNotifier);
          },
        ),
        PopupMenuItem(
          child: const Text("Remove/Delete"),//entscheiden
          onTap: () {
            databaseControl.deleteServer(id);
            updateNotifier.notify();
          },
        )
      ],
      child: const Icon(Icons.more_vert),
    );
  }
}