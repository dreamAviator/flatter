import 'package:flatter/main.dart';
import 'package:flatter/settings/server_settings/server_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'add_server_popup.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final serverWidgetList = ref.watch(riverpodManager.serverListProvider);
        return Center(
          child: Row(
            children: [
              switch (serverWidgetList) {
                AsyncValue(:final value?) => Expanded(//primary false, shrinkwrap true, scrolldirection axis.vertical
                  child: ListView.builder(
                    itemCount: value.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      void deleteServer(int id) {
                        databaseControl.deleteServer(id);
                        ref.invalidate(riverpodManager.serverListProvider);
                      }
                      void editServer(int id) {
                        List<String> serverInfo = databaseControl.getServerByID(id);
                        AddServerPopup.showAddServerPopUp(context, serverInfo[3], serverInfo[0], serverInfo[1], serverInfo[2], id);
                      }

                      return Slidable(
                        startActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(//farbe noch festlegen
                              onPressed: (_) => (editServer(value[index][0])),
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(//stattdessen vielleicht dismissible machen und nicht mit bestätigung. oder aber in den einstellungen festlegen lassen
                              onPressed: (_) => (deleteServer(value[index][0])),
                              icon: Icons.delete,
                              label: 'Delete',
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(Icons.storage),
                          title: Text(value[index][1]),
                          subtitle: Text(value[index][2]),
                          trailing: ServerMenu(context,ref,value[index][0]).serverMenu(value[index][0]),
                          onTap: () {
                            databaseControl.selectServer(value[index][0]);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
                AsyncValue(error: != null) => const Text("Error"),
                AsyncValue() => const CircularProgressIndicator(),
              }
            ],
          ),
        );
      },
    );
  }
}