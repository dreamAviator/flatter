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

  final serverListProvider = FutureProvider<List<List>>((ref) async {
    return databaseControl.getServers();
  });

  final albumListProvider = FutureProvider.family<List<dynamic>,List<String>>((ref,List<String> filterSortOptions) async {
    List<dynamic> albumMapList = await subsonicService.getAlbums(filterSortOptions);
    return albumMapList;
  });

  final albumDetailsProvider = FutureProvider.family<Map<dynamic,dynamic>,String>((ref,String id) async {
    Map<dynamic,dynamic> albumDetails = await subsonicService.getAlbumDetails(id);
    print(albumDetails);
    print(id);
    print("this was album details and id");
    return albumDetails;
  });

  final artistListProvider = FutureProvider<List<dynamic>>((ref) async {
    List<dynamic> albumMapList = await subsonicService.getArtists();
    return albumMapList;
  });

  final artistDetailsProvider = FutureProvider.family<Map<dynamic,dynamic>,String>((ref,String id) async {
    Map<dynamic,dynamic> artistDetails = await subsonicService.getArtistDetails(id);
    print(artistDetails);
    return artistDetails;
  });

  final queueProvider = FutureProvider<List<List<dynamic>>>((ref) async {
    List<List<dynamic>> queue = playerControl.getQueue();
    return queue;
  });

  final playlistListProvider = FutureProvider<List<dynamic>>((ref) async {
    List<dynamic> playlistList = await subsonicService.getPlaylists();
    print('riverpod thingy here');
    print(playlistList);
    return playlistList;
  });
}