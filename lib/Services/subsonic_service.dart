import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flatter/main.dart';

class SubsonicService {
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
    //passwort und username und baseURL woanders herbekommen
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

  Future<List<Map<String,dynamic>>> getAlbums(List<String> filterSortOptions) async {
    List<String> url = getURL(null, null, null);
    String offset = filterSortOptions[2];
    final uri = Uri.parse("${url[0]}getAlbumList2${url[1]}&type=${filterSortOptions[0]}&size=${filterSortOptions[1]}&offset=$offset");//from year, to year und genre filtered fehlt da noch
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
      print("got executed now (shouldn't have been an error there");
      print(subsonicResponse['albumList2']['album']);
      return subsonicResponse['albumList2']['album'];
    } catch(error) {
      return [];
    }
  }
}