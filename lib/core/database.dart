import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tirthankar/models/music.dart';
// / import 'employee.dart';
 
class database {
  static Database _db;  
  final String TABLE = 'SONGS';  
  final String DB_NAME = 'tirthankar.db';
  final String ID = 'id';
  final String PDFPAGE = 'pdfpage';
  final String LINKID = 'linkid';
  final String TITLE = 'title';
  final String ALBUM = 'album';
  final String SONGURL = 'songURL';
  final String HINDINAME = 'hindiName';
  final String MNAME = 'mname';
  final String MSIGN = 'msign';
  final String OTHER1 = 'other1';
  final String OTHER2 = 'other2';
  final String ENAME = 'ename';
  final String ESIGN = 'esign';
  final String LANGUAGE = 'language';
  final String SONGTEXT = 'songtext';
  final String FAVORITE = 'favorite';
  Batch batch;
  
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  _onCreate(Database db, int version) async {
    // await db
    //     .execute("CREATE TABLE $TABLE_AARTI ($ID INTEGER PRIMARY KEY, $TITLE TEXT)");
    await db
        .execute("CREATE TABLE SONGS (id INTEGER PRIMARY KEY,pdfpage INTEGER,linkid INTEGER, title TEXT, album TEXT, songURL TEXT, hindiName TEXT,mname TEXT, msign TEXT, other1 TEXT,other2 TEXT, ename TEXT, esign TEXT, language TEXT, songtext TEXT, isfave INTEGER");    
  }
 
  Future<MusicData> save(MusicData musicData) async {
    var dbClient = await db;
    musicData.id = await dbClient.insert(TABLE, musicData.toMap());
    return musicData;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

   Future<void> buildDB(List<MusicData> _list, int version) async {
    // batch = db.batch();
    try {
      for (var i = 0; i < _list.length; i++) {
        buildBatch(_list[i]);
      }
      await batch.commit(noResult: true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dbversion', version);
    } catch (e) {
      print(e);
    }
  }

  Future<Batch> buildBatch(MusicData musicData) async {
    // await openDb();        
    int id = musicData.id;
    Future<List<MusicData>> list1 = getSongs(id);
    List list = await list1 ;
    // Future<bool> songexist = findSong(musicData.id);
    if (list.length != 0) {
      batch.rawUpdate(
          "UPDATE SONGS SET pdfpage = ?, linkid = ?, title = ?, album = ?, songURL = ?, hindiName = ?, mname = ?, msign = ?, other1 = ?, other2 = ?, ename = ?, esign = ?, language = ?,songtext = ? WHERE id = ?",
          [
            musicData.id,
            musicData.pdfpage,
            musicData.linkid,
            musicData.title,
            musicData.album,
            musicData.songURL,
            musicData.hindiName,
            musicData.mname,
            musicData.msign,
            musicData.other1,
            musicData.other2,
            musicData.ename,
            musicData.esign,
            musicData.language,
            musicData.songtext
          ]);
      print("record updated in db");
      // _database.close();
    } else {
      batch.insert('SONGS', musicData.toMap());
      print("record inserted in db");
    }
    // List<Map> map = await _database.rawQuery("select * from SONGS where id = '++'");
  }
 
  Future<List<MusicData>> getSongs(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID],where:'${ID} = ?',whereArgs: [id]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<MusicData> musicData = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        musicData.add(MusicData.fromJson(maps[i]));
      }
    }
    return musicData;
  }
 
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
 
  Future<int> update(MusicData musicData) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, musicData.toMap(),
        where: '$ID = ?', whereArgs: [musicData.id]);
  }
 
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}