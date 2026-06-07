import 'package:flatter/main.dart';
import 'package:flatter/settings/server_settings/add_server_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Riverpod/riverpod_manager.dart';

class ServerMenu {
  final BuildContext context;
  final WidgetRef ref;
  final int id;
  final RiverpodManager riverpodManager;
  ServerMenu(this.context,this.ref,this.id, this.riverpodManager);

  Widget serverMenu() {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry> [
        PopupMenuItem(
          child: Text("Edit"),
          onTap: () {
            List<String> serverInfo = databaseControl.getServerByID(id);
            AddServerPopup.showAddServerPopUp(context, serverInfo[3], serverInfo[0], serverInfo[1], serverInfo[2], id, riverpodManager);
          },
        ),
        PopupMenuItem(
          child: Text("Remove/Delete"),//entscheiden
          onTap: () {
            databaseControl.deleteServer(id);
            ref.invalidate(riverpodManager.serverListProvider);
          },
        )
      ],
      child: Icon(Icons.more_vert),
    );
  }
}