import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';

class RiverpodManager {
  final authenticateProvider = FutureProvider.family<Map<dynamic,dynamic>,List<String>>((ref,List<String> loginInformation) async {
    //mehr statusdinger zurückgeben
    if (loginInformation[0].isEmpty || loginInformation[1].isEmpty || loginInformation[2].isEmpty) {
      print("erevythjing null as it should be");
      return {"status":"didn't even try"};//default value
    }
    Map<dynamic,dynamic> authenticateResponse = await subsonicService.authenticate(loginInformation[0],loginInformation[1],loginInformation[2]);
    return authenticateResponse;
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
    return albumDetails;
  });

  final artistListProvider = FutureProvider<List<dynamic>>((ref) async {
    List<dynamic> albumMapList = await subsonicService.getArtists();
    return albumMapList;
  });

  final artistDetailsProvider = FutureProvider.family<Map<dynamic,dynamic>,String>((ref,String id) async {
    Map<dynamic,dynamic> artistDetails = await subsonicService.getArtistDetails(id);
    return artistDetails;
  });

  final queueProvider = FutureProvider<List<List<dynamic>>>((ref) async {
    List<List<dynamic>> queue = playerControl.getQueue();
    return queue;
  });

  final playlistListProvider = FutureProvider<List<dynamic>>((ref) async {
    List<dynamic> playlistList = await subsonicService.getPlaylists();
    return playlistList;
  });

  final playlistDetailsProvider = FutureProvider.family<Map<dynamic,dynamic>,String>((ref,String id) async {
    Map<dynamic,dynamic> playlistDetails = await subsonicService.getPlaylistDetails(id);
    return playlistDetails;
  });

  final favoriteStatusProvider = FutureProvider.family<bool,List<String?>>((ref,List<String?> ids) async {
    print("provider (favorite status)");
    bool favoriteStatus = await subsonicService.checkStarred(ids[0], ids[1], ids[2]);
    return favoriteStatus;
  });

  final searchProvider = FutureProvider.family<Map<dynamic,dynamic>,List<dynamic>>((ref,List<dynamic> searchParams) async {
    print("search privder exyecuted");
    Map<dynamic,dynamic> searchResultsMap = await subsonicService.search(searchParams[0], searchParams[1], searchParams[2], searchParams[3]);
    return searchResultsMap;
  });
}