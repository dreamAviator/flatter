import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

class RiverpodManager {
  final authenticateProvider = FutureProvider.family<List<String>,List<String>>((ref,List<String> loginInformation) async {
    //mehr statusdinger zurückgeben
    if (loginInformation[0].isEmpty || loginInformation[1].isEmpty || loginInformation[2].isEmpty) {
      print("erevythjing null as it should be");
      return ["","Test connection"];//default value
    }
    bool authenticateResponse = await subsonicService.authenticate(loginInformation[0],loginInformation[1],loginInformation[2]);
    print("this is the response of the function");
    print(authenticateResponse);
    if (authenticateResponse == true) {
      return ["Connection established","Save"];
    } else {
      return ["Connection not working","Test connection"];
    }
  });

  final serverListProvider = FutureProvider<List<Widget>>((ref) async {
    List<List> serverInfos = databaseControl.getServers();
    List<Widget> returnList = [];
    for (List serverInfo in serverInfos) {//hier nicht die widgets direkt reinmachen
      returnList.add(
        Slidable(
          startActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(//farbe noch festlegen
                onPressed: (_) => {databaseControl.deleteServer(serverInfo[0])},//edit server
                icon: Icons.edit,
                label: 'Edit',
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => databaseControl.deleteServer(serverInfo[0]),//delete
                icon: Icons.delete,
                label: 'Delete',
                backgroundColor: Colors.red,
              )
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.storage),
            title: Text(serverInfo[1]),
            subtitle: Text(serverInfo[2]),
            trailing: IconButton(
              onPressed: () {

              },//more options pop up thing like on the folders page
              icon: Icon(Icons.more_horiz),
            ),
            onTap: () {
              //select server
              databaseControl.selectServer(serverInfo[0]);
              //go to page smh
            },
          ),
        ),
      );
    }
    return returnList;
  });

  final albumListProvider = FutureProvider.family<List<dynamic>,List<String>>((ref,List<String> filterSortOptions) async {
    List<dynamic> albumMapList = await subsonicService.getAlbums(filterSortOptions);
    return albumMapList;
  });

  final albumDetailsProvider = FutureProvider.family<Map<dynamic,dynamic>,String>((ref,String id) async {
    Map<dynamic,dynamic> albumDetails = await subsonicService.getAlbumDetails(id);
    return albumDetails;
  });
}