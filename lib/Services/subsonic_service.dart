import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flatter/main.dart';

class SubsonicService {
  //authentication
  String generateRandomString(int length) {
    final random = Random();
    const availableChars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length, (index) => availableChars[random.nextInt(availableChars.length)]).join();

    return randomString;
  }

  String getSalt() {
    return generateRandomString(10);
  }

  List<String> getURL(String? baseURL,String? username,String? password) {//returns the part starting from .view? etc
    //if everything is null, gets current server information
    if (baseURL == null || username == null || password == null) {
      final List<String> serverInfo = databaseControl.getCurrentServer();
      baseURL = serverInfo[0];
      username = serverInfo[1];
      password = serverInfo[2];
    }
    final String salt = getSalt();
    final String version = "1.16.1";//irgendwo anders herbekommen
    final String appName = "flatter";//irgendwo anders herbekommen
    final String token = md5.convert(utf8.encode(password + salt)).toString();
    return ["https://$baseURL/rest/",".view?u=$username&t=$token&s=$salt&v=$version&c=$appName&f=json"];
  }

  Future<Map<dynamic,dynamic>> authenticate(String baseURL,String username,String password) async {
    List<String> url = getURL(baseURL, username, password);
    if (baseURL == "" && username == "" && password == "") {
      print("returning didn't even try");
      return {
        "status":"didn't even try",
      };
    }
    final uri = Uri.parse("${url[0]}ping${url[1]}");
    try {
      final data = await http.get(uri);
      print(data.body);
      if (data.statusCode != 200) {
        return {};
      }
      final responseMap = jsonDecode(data.body);
      if (responseMap['subsonic-response'] == null) {
        responseMap['subsonic-response'] = {
          "status":"not subsonic",
        };
      }
      return responseMap['subsonic-response'];
    } catch(error) {
      return {};
    }
  }

  //get things
  Future<List<dynamic>> getAlbums(List<String> filterSortOptions) async {
    List<String> url = getURL(null, null, null);//das offset mit der anzahl der results probably multiplizieren, das muss ma zumindest bei der search machen
    String offset = filterSortOptions[2];//TODO:herausfinden waurm und dann später wegmachen wenn es keinen grung gibt. wenn es einen grund gibt dann grund hier hinschreiben------habe ich mich einfach nur gefragt was das offset ist? die seiten
    final uri = Uri.parse("${url[0]}getAlbumList2${url[1]}&type=${filterSortOptions[0]}&size=${filterSortOptions[1]}&offset=$offset&order=${filterSortOptions[3]}");//from year, to year und genre filtered fehlt da noch
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return [];
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return [];
      }
      return subsonicResponse['albumList2']['album'];
    } catch(error) {
      return [];
    }
  }

  Future<Map<dynamic,dynamic>> getAlbumDetails(String id) async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getAlbum${url[1]}&id=$id");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      return subsonicResponse['album'];
    } catch(error) {
      return {};
    }
  }

  Future<List<dynamic>> getArtists() async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getArtists${url[1]}"); //from year, to year und genre filtered fehlt da noch
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return [];
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return [];
      }
      return subsonicResponse['artists']['index'];
    } catch (error) {
      return [];
    }
  }

  Future<Map<dynamic,dynamic>> getArtistDetails(String id) async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getArtist${url[1]}&id=$id");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      if (subsonicResponse['artist']['starred'] == null) {
        subsonicResponse['artist']['starred'] = "unstarred";
      }
      return subsonicResponse['artist'];
    } catch(error) {
      return {};
    }
  }

  Future<List<dynamic>> getArtistAppearances(String id,String artistName) async {
    List<dynamic> artistAppearances = [];
    int offset = 0;
    Map<dynamic,dynamic> searchResults = await search(artistName, 0, offset, 0);
    while (searchResults['album'] != null) {
      for (Map<dynamic,dynamic> album in searchResults['album']) {
        if (album['artistId'] != id) {
          Map<dynamic,dynamic> albumInfo = await getAlbumDetails(album['id']);
          for (Map<dynamic,dynamic> song in albumInfo['song']) {
            if (song['artistId'] == id) {
              artistAppearances.add(album);
              break;
            } else {
              List<dynamic> songArtists = song['artists'];
              for (Map<dynamic,dynamic> artist in songArtists) {
                if (artist['id'] == id) {
                  artistAppearances.add(album);
                  break;
                }
              }
              if (artistAppearances.contains(album)) {
                break;
              }
            }
          }
        }
      }
      offset = offset + 1;
      searchResults = await search(artistName, 0, offset, 0);
    }
    return artistAppearances;
  }

  Future<List<dynamic>> getRandomSongs(int? size,String? genre,int? fromYear,int? toYear) async {
    List<String> url = getURL(null, null, null);
    String uriString = "${url[0]}getRandomSongs${url[1]}";
    if (size != null) {
      uriString = "$uriString&size=$size";
    }
    if (genre != null) {
      uriString = "$uriString&genre=$genre";
    }
    if (fromYear != null) {
      uriString = "$uriString&fromYear=$fromYear";
    }
    if (toYear != null) {
      uriString = "$uriString&toYear=$toYear";
    }
    final uri = Uri.parse(uriString); //from year, to year und genre filtered fehlt da noch
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return [];
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return [];
      }
      return subsonicResponse['randomSongs'];
    } catch (error) {
      return [];
    }
  }

  Future<Map<dynamic,dynamic>> getSongDetails(String id) async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getSong${url[1]}&id=$id");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      print(subsonicResponse);
      if (subsonicResponse['song']['starred'] == null) {
        subsonicResponse['song']['starred'] = "unstarred";
      }
      return subsonicResponse['song'];
    } catch(error) {
      return {};
    }
  }

  Future<List<dynamic>> getPlaylists() async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getPlaylists${url[1]}"); //from year, to year und genre filtered fehlt da noch
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return [];
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return [];
      }
      return subsonicResponse['playlists']['playlist'];
    } catch (error) {
      print("an error was catched smh idfk what went wrong lolololol");
      return [];
    }
  }

  Future<Map<dynamic,dynamic>> getPlaylistDetails(String id) async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getPlaylist${url[1]}&id=$id");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      if (subsonicResponse['playlist']['comment'] == null) {
        subsonicResponse['playlist']['comment'] = "";
      }
      return subsonicResponse['playlist'];
    } catch(error) {
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> getStarred() async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getStarred2${url[1]}");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      return subsonicResponse['starred2'];
    } catch(error) {
      return {};
    }
  }

  Future<bool> checkStarred(String? songID,String? albumID,String? artistID) async {
    Map<dynamic,dynamic> starred = await getStarred();
    if (albumID != null) {
      for (Map<dynamic,dynamic> album in starred['album']) {
        if (albumID == album['id']) {
          return true;
        }
      }
      return false;
    } else if (artistID != null) {
      for (Map<dynamic,dynamic> artist in starred['artist']) {
        if (artistID == artist['id']) {
          return true;
        }
      }
      return false;
    } else if (songID != null) {
      for (Map<dynamic,dynamic> song in starred['song']) {
        if (songID == song['id']) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  Future<Map<dynamic,dynamic>> search(String query,int artistOffset,int albumOffset,int songOffset) async {//hier search2 machen wenn opensubsonic nicht verfügbar ist
    List<String> url = getURL(null, null, null);
    int searchArtistCount = settingsControl.loadSetting('searchArtistCount');
    int searchAlbumCount = settingsControl.loadSetting('searchAlbumCount');
    int searchSongCount = settingsControl.loadSetting('searchSongCount');
    artistOffset = searchArtistCount * artistOffset;
    albumOffset = searchAlbumCount * albumOffset;
    songOffset = searchSongCount * songOffset;
    final uri = Uri.parse("${url[0]}search3${url[1]}&query=$query&artistOffset=$artistOffset&albumOffset=$albumOffset&songOffset=$songOffset&artistCount=$searchArtistCount&albumCount=$searchAlbumCount&songCount=$searchSongCount");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      print("query");
      print(query);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      return subsonicResponse['searchResult3'];
    } catch(error) {
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> fullSearch(String query) async {
    List<String> url = getURL(null, null, null);
    int iteration = 0;
    int count = 500;//eig egal welche zahl, hauptsache hoch, ich weiß nicht was das maximum ist
    final uri = Uri.parse("${url[0]}search3${url[1]}&query=$query&artistCount=$count&albumCount=$count&songCount=$count&artistOffset=${count * iteration}&albumOffset=${count * iteration}&songOffset=${count * iteration}");
    Map<dynamic,dynamic> fullSearchResults = {};
    List<dynamic> artistResultList = [];
    List<dynamic> albumResultList = [];
    List<dynamic> songResultList = [];
    try {
      var data = await http.get(uri);
      if (data.statusCode != 200) {
        return {};
      }
      Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        return {};
      }
      subsonicResponse = subsonicResponse['searchResult3'];
      print(subsonicResponse);
      print("this were the results for the page");
      while (subsonicResponse['album'] != null && subsonicResponse['artist'] != null && subsonicResponse['song'] != null) {
        if (subsonicResponse['album'] != null) {
          for (Map<dynamic,dynamic> album in subsonicResponse['album']) {
            albumResultList.add(album);
          }
          for (Map<dynamic,dynamic> artist in subsonicResponse['artist']) {
            artistResultList.add(artist);
          }
          for (Map<dynamic,dynamic> song in subsonicResponse['song']) {
            songResultList.add(song);
          }
        }
        iteration = iteration + 1;
        final uri = Uri.parse("${url[0]}search3${url[1]}&query=$query&artistCount=$count&albumCount=$count&songCount=$count&artistOffset=${count * iteration}&albumOffset=${count * iteration}&songOffset=${count * iteration}");
        data = await http.get(uri);
        if (data.statusCode != 200) {
          return {};
        }
        responseMap = jsonDecode(data.body);
        subsonicResponse = responseMap['subsonic-response'];
        if (subsonicResponse['status'] != "ok") {
          return {};
        }
        subsonicResponse = subsonicResponse['searchResult3'];
      }
      fullSearchResults['artist'] = artistResultList;
      fullSearchResults['album'] = albumResultList;
      fullSearchResults['song'] = songResultList;
      return fullSearchResults;
    } catch(error) {
      return {};
    }
  }

  //do something to server
  Future<Map<dynamic,dynamic>> createPlaylist(String name,List<dynamic>? songIDsToAdd) async {
    List<String> url = getURL(null,null,null);
    String request = "${url[0]}createPlaylist${url[1]}&name=$name";
    if (songIDsToAdd != null) {
      songIDsToAdd.forEach((value) {
        request = "$request&songId=${value.toString()}";
      });
    }
    final uri = Uri.parse(request);
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        print("error 4");
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        print(subsonicResponse);
        print("error 3");
        return {};
      }
      print('successfully created playlist');
      return subsonicResponse;
    } catch(error) {
      print("error 2");
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> updatePlaylist(String id,String? name,String? comment,String? public,List<dynamic>? songIDsToAdd,List<int>? indexesToRemove) async {
    List<String> url = getURL(null,null,null);
    String request = "${url[0]}updatePlaylist${url[1]}&playlistId=$id";
    if (name != null) {
      request = "$request&name=$name";
    }
    if (comment != null) {
      request = "$request&comment=$comment";
    }
    if (public != null) {
      request = "$request&public=$public";
    }
    if (songIDsToAdd != null) {
      songIDsToAdd.forEach((value) {
        request = "$request&songIdToAdd=${value.toString()}";
      });
    }
    if (indexesToRemove != null) {
      indexesToRemove.forEach((value) {
        request = "$request&songIndexToRemove=$value";
      });
    }
    final uri = Uri.parse(request);
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        print("error 4");
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        print(subsonicResponse);
        print("error 3");
        return {};
      }
      print('successfully updated playlist');
      return subsonicResponse;
    } catch(error) {
      print("error 2");
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> deletePlaylist(String id) async {
    List<String> url = getURL(null,null,null);
    final uri = Uri.parse("${url[0]}deletePlaylist${url[1]}&id=$id");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        print("error 4");
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        print(subsonicResponse);
        print("error 3");
        return {};
      }
      print('successfully deleted playlist');
      return subsonicResponse;
    } catch(error) {
      print("error 2");
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> starUnstar(bool starred,String? songID,String? albumID,String? artistID) async {
    List<String> url = getURL(null, null, null);
    List<String> request = [];
    if (starred == true) {
      request.add("star");
    } else {
      request.add("unstar");
    }
    if (songID != null) {
      request.add("id=$songID");
    } else if (albumID != null) {
      request.add("albumId=$albumID");
    } else if (artistID != null) {
      request.add("artistId=$artistID");
    } else {
      print("this should not have happened");
      return {};
    }
    final uri = Uri.parse("${url[0]}${request[0]}${url[1]}&${request[1]}");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        print("error 1");
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        print(subsonicResponse);
        print("status not okay");
        return {};
      }
      print("successfully updated star rating");
      return subsonicResponse;
    } catch(error) {
      print("error2");
      print(error);
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> scrobble(String? id,bool submission) async {
    if (id == null) {
      return {};
    }
    List<String> url = getURL(null,null,null);
    final Duration time = DateTime.now().difference(DateTime(1970));
    final uri = Uri.parse("${url[0]}scrobble${url[1]}&id=$id&time=${time.inMilliseconds}&submission=$submission");
    try {
      final data = await http.get(uri);
      if (data.statusCode != 200) {
        print("error 4");
        return {};
      }
      final Map responseMap = jsonDecode(data.body);
      Map subsonicResponse = responseMap['subsonic-response'];
      if (subsonicResponse['status'] != "ok") {
        print(subsonicResponse);
        print("error 3");
        return {};
      }
      print('successfully scrobbled');
      return subsonicResponse;
    } catch(error) {
      print("error 2");
      return {};
    }
  }
}