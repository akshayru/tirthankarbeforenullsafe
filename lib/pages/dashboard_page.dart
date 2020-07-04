import 'dart:async';
import 'dart:ffi';
import 'dart:convert';
import 'dart:wasm';
import 'package:flutter/services.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tirthankar/core/const.dart';
import 'package:tirthankar/core/database.dart';
import 'package:tirthankar/core/db.dart';
import 'package:tirthankar/core/dbmanager.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:tirthankar/core/language.dart';
import 'package:tirthankar/models/listdata.dart';
import 'package:tirthankar/models/music.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as eos;
import 'package:tirthankar/pages/list_page.dart';
import 'package:tirthankar/pages/settings.dart';
import 'package:tirthankar/pages/youtube.dart';
import 'package:tirthankar/widgets/custome_grid_widget.dart';
import 'package:tirthankar/widgets/tirthankarIcon.dart';
// import 'package:youtube_api/youtube_api.dart';

class Dashboard extends StatefulWidget {
  // int playingId;
  Data data;
  String appname;

  // List<MusicData> list;
  Dashboard({this.appname, this.data});
  @override
  _DashboardState createState() => _DashboardState(appname, data);
}

class _DashboardState extends State<Dashboard> {
  String appname;
  Data data;
  int lang_index;
  bool isUpdating;
  List<MusicData> _list;
  final sqllitedb dbHelper = new sqllitedb();
  final languageSelector selectlang = new languageSelector();
  // final DBHelper dbHelper = new DBHelper();
  // int playingId = 0;

  // List<MusicData> list;
  _DashboardState(this.appname, this.data);
  // print('${playingId}');

  @override
  void initState() {
    appname = "";
    getLanguage();
    downloadSongList(appname);
  }

  Future<void> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lang_index = prefs.getInt('language') ?? 0;
    setState(() {
      lang_index = lang_index;
    });
  }

  refreshList() {
    setState(() {
      // MusicData songlist = dbHelper.getSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      // DeviceOrientation.portraitDown,
      // DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.darkBlue,
          centerTitle: true,
          title: Text(
            selectlang.getAlbum("Tirthankar", lang_index),
            style: TextStyle(color: AppColors.white),
          ),
        ),
        backgroundColor: AppColors.mainColor,
        body: Column(children: <Widget>[
          // SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                border: Border.all(color: AppColors.styleColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              child: Icon(
                                Icons.file_download,
                                size: 100,
                                color: AppColors.styleColor,
                              ),

                              image: 'assets/diya.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ListPage(appname: "Aarti", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Aarti", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              child: Icon(
                                Icons.file_download,
                                size: 100,
                                color: AppColors.styleColor,
                              ),

                              image: 'assets/bhakt.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ListPage(
                                        appname: "Bhaktambar", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Bhaktambar", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              child: Icon(
                                Icons.file_download,
                                size: 100,
                                color: AppColors.styleColor,
                              ),

                              image: 'assets/story.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ListPage(appname: "Kids", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Kids", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                border: Border.all(color: AppColors.styleColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              // child: Icon(
                              //   Icons.favorite,
                              //   size: 90,
                              //   color: AppColors.red200,
                              // ),

                              image: 'assets/bhajan.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ListPage(appname: "Bhajan", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Bhajan", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              // child: Icon(
                              //   Icons.settings_applications,
                              //   size: 90,
                              //   color: AppColors.styleColor,
                              // ),

                              image: 'assets/namokar.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ListPage(
                                        appname: "Namokar", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Namokar", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              child: Icon(
                                Icons.file_download,
                                size: 100,
                                color: AppColors.styleColor,
                              ),

                              image: 'assets/vidyasagar.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    // builder: (_) => YoutubePlay(appname: "Pravchan",data: data,),
                                    builder: (_) =>
                                        ListPage(appname: "Pravchan"),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Pravchan", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                border: Border.all(color: AppColors.styleColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              // child: Icon(
                              //   Icons.favorite,
                              //   size: 90,
                              //   color: AppColors.red200,
                              // ),

                              image: 'assets/puja_new.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ListPage(appname: "Stuti", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Stuti", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              child: Icon(
                                Icons.settings_applications,
                                size: 90,
                                color: AppColors.styleColor,
                              ),

                              image: 'assets/favorite.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ListPage(
                                        appname: "Favorite", data: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Favorite", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomGridWidget(
                              child: Icon(
                                Icons.file_download,
                                size: 100,
                                color: AppColors.styleColor,
                              ),

                              image: 'assets/settings.png',
                              sizew: MediaQuery.of(context).size.width * .26,
                              sizeh: MediaQuery.of(context).size.width * .26,
                              borderWidth: 2,
                              // label: "Bhajan",
                              onTap: () {
                                Data ndata;
                                if (data != null) {
                                  ndata = data;
                                } else {
                                  ndata = buildData();
                                }
                                // Future<List<MusicData>> dbList = dbHelper.getSongList("select * from SONGS where album='Bhajan'");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        Settings(appname: "Settings"),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            selectlang.getAlbum("Setting", lang_index),
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  Data buildData() {
    return Data(
        playId: null,
        songId: null,
        audioPlayer: null,
        isPlaying: null,
        isRepeat: null,
        isShuffle: null,
        duration: null,
        position: null,
        list: null,
        appname: appname);
  }

  Material boxTiles(IconData icon, String name) {
    return Material(
        color: AppColors.mainColor,
        elevation: 14.0,
        shadowColor: AppColors.styleColor,
        borderRadius: BorderRadius.circular(24.0),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          print("tapped");
                          /*  or any action you want */
                        },
                        child: Container(
                          width: 130.0,
                          height: 10.0,
                          color: Colors.transparent,
                        ), // container
                      ), //
                      //Text
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(name,
                            style: TextStyle(
                              color: AppColors.styleColor,
                              fontSize: 20.0,
                            )),
                      ),
                      //Icon
                      Material(
                        color: AppColors.styleColor,
                        borderRadius: BorderRadius.circular(50.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            icon,
                            color: AppColors.lightBlue,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  Future<void> downloadSongList(String appname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var version = prefs.getInt('dbversion');
    // version = 0;
    eos.Response response;
    String url =
        "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/input.json";
    String arrayObjsText = "";
    // '{ "version":1, "tags": [ { "id": 1, "title": "Namp 1", "album": "Flume", "songURL": "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/Namokar/Namokaar+Mantra+by+Lata+Mangeshkar.mp3", "hindiName": "Testing 1", "favorite": false }, { "id": 2, "title": "Namp 2", "album": "Flume", "songURL": "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/Namokar/Namokar+Mantra+by+Anurasdha+Paudwal.mp3", "hindiName": "Testing 1", "favorite": false }, { "id": 3, "title": "Namp 3", "album": "Flume", "songURL": "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/Namokar/Namokaar+Mantra+by+Lata+Mangeshkar.mp3", "hindiName": "Testing 1", "favorite": false } ] }';
    // '{"tags": [{"name": "dart", "quantity": 12}, {"name": "flutter", "quantity": 25}, {"name": "json", "quantity": 8}]}';
    try {
      Dio dio = new Dio();
      response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );
      arrayObjsText = response.data;
      // print(response.data.toString());
      if (response != null) {
        final body = json.decode(response.data);
        var tagObjsJson = jsonDecode(arrayObjsText)['tags'] as List;
        this.setState(() {
          _list = tagObjsJson
              .map((tagJson) => MusicData.fromJson(tagJson))
              .toList();
        });
        if (version == body['version']) {
          print("No DB update");
        } else {
          // dbHelper.batchInsertEventSongAsync(_list, body['version']);
          dbHelper.buildDB1(_list, body['version']);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
