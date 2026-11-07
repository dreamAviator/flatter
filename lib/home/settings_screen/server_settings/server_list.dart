import 'package:flatter/main.dart';
import 'package:flatter/home/settings_screen/server_settings/server_menu.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Riverpod/riverpod_manager.dart';
import 'add_server_popup.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key, required this.updateNotifier});
  final UpdateNotifier updateNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: updateNotifier,
      builder: (context, child) {
        List<List> serverList = databaseControl.getServers();
        return ListView.builder(
          itemCount: serverList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (BuildContext context, int index) {
            void deleteServer(int id) {
              databaseControl.deleteServer(id);
              updateNotifier.notify();
            }
            void editServer(int id) {
              List<String> serverInfo = databaseControl.getServerByID(id);
              AddServerPopup.showAddServerPopUp(context, serverInfo[3], serverInfo[0], serverInfo[1], serverInfo[2], id, updateNotifier);
            }
            int currentlySelectedServer = settingsControl.loadSetting('selectedServer');
            if (currentlySelectedServer == serverList[index][0]) {
              return Slidable(
                startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(//farbe noch festlegen
                      onPressed: (_) => (editServer(serverList[index][0])),
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(//stattdessen vielleicht dismissible machen und nicht mit bestätigung. oder aber in den einstellungen festlegen lassen
                      onPressed: (_) => (deleteServer(serverList[index][0])),
                      icon: Icons.delete,
                      label: 'Delete',
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(serverList[index][1]),
                  subtitle: Text(serverList[index][2]),
                  trailing: ServerMenu(context,serverList[index][0],updateNotifier).serverMenu(),
                  onTap: () {
                    databaseControl.selectServer(serverList[index][0]);
                    Navigator.of(context).pop();
                  },
                ),
              );
            } else {
              return Slidable(
                startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(//farbe noch festlegen
                      onPressed: (_) => (editServer(serverList[index][0])),
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(//stattdessen vielleicht dismissible machen und nicht mit bestätigung. oder aber in den einstellungen festlegen lassen
                      onPressed: (_) => (deleteServer(serverList[index][0])),
                      icon: Icons.delete,
                      label: 'Delete',
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.storage),
                  title: Text(serverList[index][1]),
                  subtitle: Text(serverList[index][2]),
                  trailing: ServerMenu(context,serverList[index][0],updateNotifier).serverMenu(),
                  onTap: () {
                    databaseControl.selectServer(serverList[index][0]);
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
          },
        );
      }
    );
  }
}