import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class RiverpodManager {
  final authenticateProvider = FutureProvider.family<List<String>,List<String>>((ref,List<String> loginInformation) async {
    //mehr statusdinger zurückgeben
    if (loginInformation[0].isEmpty || loginInformation[1].isEmpty || loginInformation[2].isEmpty) {
      print("erevythjing null as it should be");
      return ["","Test connection"];//default value
    }
    bool authenticateResponse = await subsonicService.authenticate(loginInformation[0]!,loginInformation[1]!,loginInformation[2]!);
    print("this is the response of the function");
    print(authenticateResponse);
    if (authenticateResponse == true) {
      return ["Connection established","Save"];
    } else {
      return ["Connection not working","Test connection"];
    }
  });

  final serverListProvider = FutureProvider<List<Widget>>((ref) async {
    // Using the fetchRandomJoke function to get a random joke
    List<List> serverInfos = databaseControl.getServers();
    List<Widget> returnList = [];
    for (List serverInfo in serverInfos) {
      returnList.add(
        ListTile(
          leading: Icon(Icons.storage),
          title: Text(serverInfo[1]),
          subtitle: Text(serverInfo[2]),
          onTap: () {
            //select server
            //go to page smh
          },
        )
      );
    }
    return returnList;
  });
}