import 'package:flatter/main.dart';
import 'package:sqlite3/sqlite3.dart';

class ServersDatabase {
  late Database db;

  Future<void> initialize() async {
    await openDatabase();
    return;
  }

  Future<void> openDatabase() async {
    String path = pathProvider.dataDirectory;//passwort später irgendwie sicher speichern
    path = "${path}/flatter_servers.sqlite";
    print("path");
    db = sqlite3.open(path);
    createTables();
    return;
  }

  void closeDatabase() {
    db.close();
  }

  void createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS servers (
        id INTEGER NOT NULL UNIQUE,
        url TEXT NOT NULL,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        PRIMARY KEY (id AUTOINCREMENT)
      )
    ''');
  }

  void addServer(String name,String url,String username,String password) {
    db.execute('''
      INSERT INTO servers (url,name,username,password)
      VALUES
      ('$url','$name','$username','$password')
    ''');
  }

  void deleteServer(int id) {
    db.execute('''
      DELETE FROM servers WHERE id = $id
    ''');
  }

  List<List> getServers() {
    ResultSet serverInfosMap = db.select('''
      SELECT id,name,url FROM servers
    ''');
    print(serverInfosMap);
    List<List> returnList = [];
    for (Map server in serverInfosMap) {
      returnList.add([server['id'],server['name'],server['url']]);
    }
    return returnList;
  }

  List<String> getServerInfo(int id) {
    ResultSet result = db.select('''
      SELECT url,username,password,name FROM servers WHERE id = $id
    ''');
    List<String> resultList = [];
    for (Map resultMap in result) {
      resultList.addAll([resultMap['url'],resultMap['username'],resultMap['password'],resultMap['name']]);
    }
    return resultList;
  }
}