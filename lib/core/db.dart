import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tirthankar/models/music.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tirthankar.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
    "CREATE TABLE SONGS (id INTEGER,pdfpage INTEGER,linkid INTEGER, title TEXT, album TEXT, songURL TEXT, hindiName TEXT,mname TEXT, msign TEXT, other1 TEXT,other2 TEXT, ename TEXT, esign TEXT, language TEXT, songtext TEXT, isfave INTEGER)",);
    print("Created tables");
  }
  
  // Retrieving employees from Employee Tables
  Future<List<MusicData>> getSongList(String sql) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(sql);
    List<MusicData> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(new MusicData(
          list[i]['id'],
          list[i]['pdfpage'],
          list[i]['linkid'],
          list[i]['title'],
          list[i]['album'],
          list[i]['songURL'],
          list[i]['hindiName'],
          list[i]['mname'],
          list[i]['msign'],
          list[i]['other1'],
          list[i]['other2'],
          list[i]['ename'],
          list[i]['esign'],
          list[i]['language'],
          list[i]['songtext'],
          list[i]['isfave']));
    }
    print(employees.length);
    return employees;
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

  void buildDB1(List<MusicData> _list, int version) async {
    var dbClient = await db;
    try {              
      dbClient.transaction((txn) async {
        // Batch batch = txn.batch();
        Future<List<MusicData>> list1 =
              getSongList("select * from songs");
        List<MusicData> list = await list1;
        for (var i = 0; i < _list.length; i++) {
          // buildBatch(_list[i]);
          MusicData musicData = _list[i];
          int ID = musicData.id;                  
          
          if (itemCheck(list,ID) == true) {

            
            String updateSQL =
                "UPDATE SONGS SET pdfpage = ${musicData.id}, linkid = ${musicData.linkid}, title = '${musicData.title}', album = '${musicData.album}', songURL = '${musicData.songURL}', hindiName = '${musicData.hindiName}', mname = '${musicData.mname}', msign = '${musicData.msign}', other1 = '${musicData.other1}', other2 = '${musicData.other2}', ename = '${musicData.ename}', esign = '${musicData.esign}', language = '${musicData.language}',songtext = '${musicData.songtext}' WHERE id = ${musicData.id}";            
            var status = await updateSongs(updateSQL);
            // await batch.rawUpdate(updateSQL);
            // _database.rawUpdate(
            //     "UPDATE SONGS SET pdfpage = ?, linkid = ?, title = ?, album = ?, songURL = ?, hindiName = ?, mname = ?, msign = ?, other1 = ?, other2 = ?, ename = ?, esign = ?, language = ?,songtext = ? WHERE id = ?",
            //     [ musicData.id,musicData.pdfpage,musicData.linkid,musicData.title,musicData.album,musicData.songURL,musicData.hindiName,musicData.mname,musicData.msign,musicData.other1,musicData.other2,musicData.ename,musicData.esign,musicData.language,musicData.songtext]);
            // print("Record updated in db $ID");
            // _database.close();
          } else {
            String insertSQL =
                "INSERT INTO SONGS (id,pdfpage, linkid, title,album,songURL,hindiName,mname,msign,other1,other2,ename,esign,language,songtext,isfave) VALUES (${musicData.id},${musicData.pdfpage},${musicData.linkid},'${musicData.title}','${musicData.album}','${musicData.songURL}','${musicData.hindiName}','${musicData.mname}','${musicData.msign}', '${musicData.other1}','${musicData.other2}','${musicData.ename}','${musicData.esign}','${musicData.language}','${musicData.songtext}',0)";
            var status = await insertSongs(insertSQL);
            // batchd = batchd + " ..$insertSQL";
            // await batch.rawInsert(insertSQL);
            // _database.insert('SONGS', musicData.toMap());
            print("Record inserted in db $ID");
          }
        }

        // _db.batch()  ..{id} ..commit() .then(print);
        // var result = await batch.commit();
        
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dbversion', version);
    } catch (e) {
      print(e);
    }
  }
  

  void updateSongs(String sql) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      // await txn.rawUpdate(sql);      
      return await txn.rawUpdate(sql);
    });
  }

  void insertSongs(String sql) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(sql);
    });
  }
  
  void saveEmployee(MusicData employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee(firstname, lastname, mobileno, emailid ) VALUES(' +
              '\'' +
              employee.title +
              '\'' +
              ',' +
              '\'' +
              employee.album +
              '\'' +
              ',' +
              '\'' +
              employee.ename +
              '\'' +
              ',' +
              '\'' +
              employee.esign +
              '\'' +
              ')');
    });
  }


}