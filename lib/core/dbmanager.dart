import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tirthankar/models/music.dart';
import 'package:synchronized/synchronized.dart';

class sqllitedb {
  static final String DBNAME = "tirthankar.db";
  static final int VERSION = 1;
  static int dataversion = 0;
  static Database _database;
  final _lock = new Lock();
  Batch batch;
  int ID;
  int PDFPAGE;
  int LINKID;
  String TITLE = 'title';
  String ALBUM = 'album';
  String SONGURL = 'songURL';
  String HINDINAME = 'hindiName';
  String MNAME = 'mname';
  String MSIGN = 'msign';
  String OTHER1 = 'other1';
  String OTHER2 = 'other2';
  String ENAME = 'ename';
  String ESIGN = 'esign';
  String LANGUAGE = 'language';
  String SONGTEXT = 'songtext';
  int FAVORITE;  
  Database _db;
  

  openDb() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), "tirthankar.db"),
        version: VERSION,
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE SONGS (id INTEGER,pdfpage INTEGER,linkid INTEGER, title TEXT, album TEXT, songURL TEXT, hindiName TEXT,mname TEXT, msign TEXT, other1 TEXT,other2 TEXT, ename TEXT, esign TEXT, language TEXT, songtext TEXT, isfave INTEGER)",
          );
        },
      );
    }
  }

  Future<Database> getDb() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          _db = await openDatabase(join(await getDatabasesPath(), "tirthankar.db"));
        }
      });
    }
    return _db;
  }

  Future<void> buildDB(List<MusicData> _list, int version) async {
    await openDb();
    batch = _database.batch();

    try {
      for (var i = 0; i < _list.length; i++) {
        // buildBatch(_list[i]);
        MusicData musicData = _list[i];
        int id = musicData.id;
        Future<List<MusicData>> list1 =
            getSongList("select * from songs where id=$id");
        List<MusicData> list = await list1;
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
          print("Record updated in db $id");
          // _database.close();
        } else {
          batch.insert('SONGS', musicData.toMap());
          print("Record inserted in db $id");
        }
      }
      // var return = batch.commit(noResult: true);
      Future<List> result = batch.commit();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dbversion', version);
    } catch (e) {
      print(e);
    }
  }
  bool itemCheck(List<MusicData> list, int id){
    // bool idfound = false;
    for (int i=0;i<list.length;i++){
      MusicData musicData = list[i];
      if (musicData.id == id){
        return true;  
      }
    }
    return false;
  }
  

  buildDB1(List<MusicData> _list, int version) async {
    await openDb();    
    try {              
      // _database.transaction((txn) async {
        // Batch batch = txn.batch();
        Future<List<MusicData>> list1 =
              getSongList("select * from songs");
        List<MusicData> list = await list1;
        for (var i = 0; i < _list.length; i++) {
          // buildBatch(_list[i]);
          MusicData musicData = _list[i];
          ID = musicData.id;                
          
          if (itemCheck(list,ID) == true) {
            String updateSQL =
                "UPDATE SONGS SET pdfpage = ${musicData.pdfpage}, linkid = ${musicData.linkid}, title = '${musicData.title}', album = '${musicData.album}', songURL = '${musicData.songURL}', hindiName = '${musicData.hindiName}', mname = '${musicData.mname}', msign = '${musicData.msign}', other1 = '${musicData.other1}', other2 = '${musicData.other2}', ename = '${musicData.ename}', esign = '${musicData.esign}', language = '${musicData.language}',songtext = '${musicData.songtext}' WHERE id = ${musicData.id}";            
            // var status = await updateSongs(updateSQL);
            // batch.rawUpdate(updateSQL);
            var output = _database.rawUpdate(updateSQL);
            // _database.rawUpdate(
            //     "UPDATE SONGS SET pdfpage = ?, linkid = ?, title = ?, album = ?, songURL = ?, hindiName = ?, mname = ?, msign = ?, other1 = ?, other2 = ?, ename = ?, esign = ?, language = ?,songtext = ? WHERE id = ?",
            //     [ musicData.id,musicData.pdfpage,musicData.linkid,musicData.title,musicData.album,musicData.songURL,musicData.hindiName,musicData.mname,musicData.msign,musicData.other1,musicData.other2,musicData.ename,musicData.esign,musicData.language,musicData.songtext]);
            print("Record updated in db $ID");
            // _database.close();
          } else {
            String insertSQL =
                "INSERT INTO SONGS (id,pdfpage, linkid, title,album,songURL,hindiName,mname,msign,other1,other2,ename,esign,language,songtext,isfave) VALUES (${musicData.id},${musicData.pdfpage},${musicData.linkid},'${musicData.title}','${musicData.album}','${musicData.songURL}','${musicData.hindiName}','${musicData.mname}','${musicData.msign}', '${musicData.other1}','${musicData.other2}','${musicData.ename}','${musicData.esign}','${musicData.language}','${musicData.songtext}',0)";
            // var status = await insertSongs(insertSQL);
            // batchd = batchd + " ..$insertSQL";
            // batch.rawInsert(insertSQL);
            var output = _database.rawInsert(insertSQL);
            // _database.insert('SONGS', musicData.toMap());
            print("Record inserted in db $ID");
          }
        }
        
        // _database.batch()  ..commit() .then(print);
        // var results = batch.commit();
      // });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dbversion', version);
    } catch (e) {
      print(e);
    }
  }

  List<MusicData> getSong(String sql) {
    openDb();
    
    List<MusicData> list = [];
    // _db.transaction((txn) async {
    List<Map> map = _database.rawQuery(sql) as List<Map>;     
        
    // });      
    for (int i = 0; i < map.length; i++) {
      MusicData data = new MusicData(
          map[i]['id'],
          map[i]['pdfpage'],
          map[i]['linkid'],
          map[i]['title'],
          map[i]['album'],
          map[i]['songURL'],
          map[i]['hindiName'],
          map[i]['mname'],
          map[i]['msign'],
          map[i]['other1'],
          map[i]['other2'],
          map[i]['ename'],
          map[i]['esign'],
          map[i]['language'],
          map[i]['songtext'],
          map[i]['isfave']);

      list.add(data);
    }
    // List<MusicData> list = await list1;
    return list;
  }

  
  Future<List<MusicData>> getSongList(String sql) async {
    await openDb();
    List<Map> map;
    List<MusicData> list = [];
    // _db.transaction((txn) async {
        map = await _database.rawQuery(sql);     
        
    // });      
    for (int i = 0; i < map.length; i++) {
      MusicData data = new MusicData(
          map[i]['id'],
          map[i]['pdfpage'],
          map[i]['linkid'],
          map[i]['title'],
          map[i]['album'],
          map[i]['songURL'],
          map[i]['hindiName'],
          map[i]['mname'],
          map[i]['msign'],
          map[i]['other1'],
          map[i]['other2'],
          map[i]['ename'],
          map[i]['esign'],
          map[i]['language'],
          map[i]['songtext'],
          map[i]['isfave']);

      list.add(data);
    }
    // List<MusicData> list = await list1;
    return list;
  }
  


  List<MusicData> maptolist(List<Map> map) {
    List<MusicData> list = [];

    for (int i = 0; i < map.length; i++) {
      MusicData data = new MusicData(
          map[i]['id'],
          map[i]['pdfpage'],
          map[i]['linkid'],
          map[i]['title'],
          map[i]['album'],
          map[i]['songURL'],
          map[i]['hindiName'],
          map[i]['isfave'],
          map[i]['ename'],
          map[i]['esign'],
          map[i]['mname'],
          map[i]['msign'],
          map[i]['other1'],
          map[i]['other2'],
          map[i]['language'],
          map[i]['songtext']);
      // data.id = map[i]['id'];
      // data.pdfpage = map[i]['pdfpage'];
      // data.linkid = map[i]['linkid'];
      // data.title = map[i]['title'];
      // data.album = map[i]['album'];
      // data.songURL = map[i]['songURL'];
      // data.hindiName = map[i]['hindiName'];
      // data.mname = map[i]['mname'];
      // data.msign = map[i]['msign'];
      // data.other1 = map[i]['other1'];
      // data.other2 = map[i]['other2'];
      // data.ename = map[i]['ename'];
      // data.esign = map[i]['esign'];
      // data.language = map[i]['language'];
      // data.songtext = map[i]['songtext'];
      // data.isfave = map[i]['isfave'];
      list.add(data);
    }
  }

  Future<int> updateStudent(MusicData musicData) async {
    await openDb();
    return await _database.update('SONGS', musicData.toMap(),
        where: "id = ?", whereArgs: [musicData.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDb();
    await _database.delete('SONGS', where: "id = ?", whereArgs: [id]);
  }

  Future<void> updateFavorite(int intex,int value) async {
    await openDb();
    String updatefav = "UPDATE SONGS SET isfave = ${value} WHERE id = ${intex}";
    var output = _database.rawUpdate(updatefav); 
    return output;  // return await _database.update('SONGS', musicData.toMap(),
    //     where: "id = ?", whereArgs: [musicData.id]);

  }
}

// class Student {
//   int id;
//   String name;
//   String course;
//   Student({@required this.name, @required this.course, this.id});
//   Map<String, dynamic> toMap() {
//     return {'name': name, 'course': course};
//   }
// }
