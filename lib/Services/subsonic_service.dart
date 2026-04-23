import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flatter/main.dart';

class SubsonicService {
  //authentication
  String generateRandomString(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)]).join();

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

  Future<bool> authenticate(String baseURL,String username,String password) async {
    List<String> url = getURL(baseURL, username, password);
    final uri = Uri.parse("${url[0]}ping${url[1]}");
    try {
      final data = await http.get(uri);
      print(data.body);
      if (data.statusCode != 200) {
        return false;
      }
      final responseMap = jsonDecode(data.body);
      print(responseMap);
      print(responseMap["subsonic-response"]["status"]);
      bool ok = false;
      if (responseMap["subsonic-response"]["status"] == "ok") {
        ok = true;
      }
      return ok;
    } catch(error) {
      return false;
    }
  }

  //get things
  Future<List<dynamic>> getAlbums(List<String> filterSortOptions) async {
    List<String> url = getURL(null, null, null);
    print("here");
    print(filterSortOptions[3]);
    String offset = filterSortOptions[2];//TODO:herausfinden waurm und dann später wegmachen wenn es keinen grung gibt. wenn es einen grund gibt dann grund hier hinschreiben
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
      print(subsonicResponse['album']);
      return subsonicResponse['album'];
    } catch(error) {
      return {};
    }
  }

  Future<List<dynamic>> getArtists() async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse(
        "${url[0]}getArtists${url[1]}"); //from year, to year und genre filtered fehlt da noch
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
        return subsonicResponse['artist'];
      } catch(error) {
        return {};
      }
    } catch(error) {
      return {};
    }
  }

  Future<Map<dynamic,dynamic>> getSongDetails(String id) async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse("${url[0]}getSong${url[1]}&id=$id");
    try {
      final data = await http.get(uri);
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
        return subsonicResponse['song'];
      } catch(error) {
        return {};
      }
    } catch(error) {
      return {};
    }
  }

  Future<List<dynamic>> getPlaylists() async {
    List<String> url = getURL(null, null, null);
    final uri = Uri.parse(
        "${url[0]}getPlaylists${url[1]}"); //from year, to year und genre filtered fehlt da noch
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
        return subsonicResponse['playlist'];
      } catch(error) {
        return {};
      }
    } catch(error) {
      return {};
    }
  }

  //do something to server
  Future<Map<dynamic,dynamic>> updatePlaylist(String id,String? name,String? comment,String? public,List<dynamic>? songIDsToAdd,List<int>? indexesToRemove) async {
    List<String> url = getURL(null,null,null);
    String request = "${url[0]}updatePlaylist${url[1]}&id=$id";
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
    print("now here comes the qrequest");
    print(request);
    print("hello hello this is the request");
    try {
      final data = await http.get(uri);
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
        print('successfully updated playlist');
        return subsonicResponse;
      } catch(error) {
        return {};
      }
    } catch(error) {
      return {};
    }
  }
}