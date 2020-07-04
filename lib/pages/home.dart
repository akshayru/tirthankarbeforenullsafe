import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tirthankar/core/const.dart';
import 'package:tirthankar/core/dbmanager.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:tirthankar/core/language.dart';
import 'package:tirthankar/models/listdata.dart';
import 'package:tirthankar/models/music.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

import 'package:tirthankar/pages/list_page.dart';
import 'package:tirthankar/pages/settings.dart';
import 'package:tirthankar/pages/muni.dart';
import 'package:tirthankar/widgets/common_methods.dart';
import 'package:tirthankar/widgets/custom_button_widget.dart';
import 'package:tirthankar/widgets/custome_grid_widget.dart';
// import 'package:youtube_api/youtube_api.dart';

class HomePage extends StatefulWidget {
  // int playingId;
  // Data data;
  String appname;

  // List<MusicData> list;
  // HomePage({this.appname, this.data});
  HomePage({this.appname});
  @override
  _HomePageState createState() => _HomePageState(appname);
}

class _HomePageState extends State<HomePage> {
  String appname;
  Data data;
  int lang_index;
  bool isUpdating;
  List<MusicData> _list;
  final sqllitedb dbHelper = new sqllitedb();
  final languageSelector selectlang = new languageSelector();
  final common_methods commonmethod = new common_methods();
  bool isLoaded = false;

  // final DBHelper dbHelper = new DBHelper();
  // int playingId = 0;

  // List<MusicData> list;
  _HomePageState(this.appname);
  // print('${playingId}');

  @override
  void initState() {
    appname = "";
    // commonmethod.isInternet(context);
    // // isInternet();
    // commonmethod.downloadSongList(context, appname);
    // commonmethod.getSharedPref("").whenComplete(() => setState(() {
    //       lang_selection = lang_selection;
    //       downloadDate = downloadDate;
    //     }));
    WidgetsBinding.instance.addPostFrameCallback((_) => setup());
  }

  setup() {
    commonmethod.getSharedPref("").whenComplete(() => setState(() {
          lang_selection = lang_selection;
          downloadDate = downloadDate;
        }));
    commonmethod.isInternet(context);
    // isInternet();
    commonmethod.downloadSongList(context, appname);
  }

  @override
  void setState(fn) {
    // commonmethod.getSharedPref("").whenComplete(() => setState(() {
    //       lang_selection = lang_selection;
    //       downloadDate = downloadDate;
    //     }));
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final myImageAndCaption = [
      ["assets/diya.png", "Aarti"],
      ["assets/bhakt.png", "Bhaktambar"],
      ["assets/story.png", "Kids"],
      ["assets/bhajan.png", "Bhajan"],
      ["assets/namokar.png", "Namokar"],
      ["assets/vidyasagar.png", "Pravchan"],
      ["assets/vidyasagar.png", "Chalisa"],
      ["assets/puja_new.png", "Stuti"],
      ["assets/favorite.png", "Favorite"],
      ["assets/settings.png", "Setting"]
    ];
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.styleColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    appname: appname,
                  ),
                ),
              );
            },
          ),
          title: Text(
            selectlang.getAlbum("Tirthankar", lang_selection),
            style: TextStyle(color: AppColors.white),
          ),
        ),
        backgroundColor: AppColors.mainColor,
        body: GridView.count(
          crossAxisCount: 3,
          children: [
            ...myImageAndCaption.map(
              (i) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: AppColors.mainColor,
                    child: CustomButtonWidget(
                      image: i.first,
                      size: 100,
                      borderWidth: 5,
                      onTap: () {
                        commonmethod.isInternet(context);
                        Route route;
                        switch (i.last) {
                          case "Pravchan":
                            route = MaterialPageRoute(
                              builder: (_) => MuniPage(appname: i.last),
                            );
                            break;
                          case "Setting":
                            route = MaterialPageRoute(
                              builder: (_) => Settings(appname: i.last),
                            );
                            break;
                          default:
                            route = MaterialPageRoute(
                              builder: (_) => ListPage(appname: i.last),
                            );
                        }
                        Navigator.of(context).push(route);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(2),
                      child: Text(
                          "${selectlang.getAlbum(i.last, lang_selection)}"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   SystemChrome.setPreferredOrientations([
  //     // DeviceOrientation.landscapeLeft,
  //     // DeviceOrientation.landscapeRight,
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.portraitUp,
  //   ]);
  //   return Scaffold(
  //       // appBar: commonmethod.buildAppBar(),
  //       appBar: AppBar(
  //         elevation: 0,
  //         backgroundColor: AppColors.styleColor,
  //         centerTitle: true,
  //         title: Text(
  //           selectlang.getAlbum("Tirthankar", lang_selection),
  //           style: TextStyle(color: AppColors.white),
  //         ),
  //       ),
  //       backgroundColor: AppColors.mainColor,
  //       body: Container(
  //           // padding: EdgeInsets.all(16.0),
  //           child: GridView.count(
  //               scrollDirection: Axis.vertical,
  //               crossAxisCount: 3,
  //               // crossAxisSpacing: 3.0,
  //               // mainAxisSpacing: 3.0,
  //               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //               children: <Widget>[
  //             buildItem(context, 'assets/diya.png', 'Aarti'),
  //             buildItem(context, 'assets/bhakt.png', 'Bhaktambar'),
  //             buildItem(context, 'assets/story.png', 'Kids'),
  //             buildItem(context, 'assets/bhajan.png', 'Bhajan'),
  //             buildItem(context, 'assets/namokar.png', 'Namokar'),
  //             buildItem(context, 'assets/vidyasagar.png', 'Pravchan'),
  //             buildItem(context, 'assets/puja_new.png', 'Stuti'),
  //             buildItem(context, 'assets/favorite.png', 'Favorite'),
  //             buildItem(context, 'assets/settings.png', 'Setting'),
  //           ])));
  // }

  Column buildItem(BuildContext context, String impagepath, String modulename) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomGridWidget(
                // child: Icon(
                //   Icons.file_download,
                //   size: 100,
                //   color: AppColors.styleColor,
                // ),

                image: impagepath,
                sizew: MediaQuery.of(context).size.width * .25,
                sizeh: MediaQuery.of(context).size.width * .30,
                // sizew: MediaQuery.of(context).size.width * .1,
                // sizeh: MediaQuery.of(context).size.width * .1,
                borderWidth: 2,
                // label: "Bhajan",
                onTap: () {
                  commonmethod.isInternet(context);
                  Route route;
                  switch (modulename) {
                    case "Pravchan":
                      route = MaterialPageRoute(
                        builder: (_) => MuniPage(appname: modulename),
                      );
                      break;
                    case "Setting":
                      route = MaterialPageRoute(
                        builder: (_) => Settings(appname: modulename),
                      );
                      break;
                    default:
                      route = MaterialPageRoute(
                        builder: (_) => ListPage(appname: modulename),
                      );
                  }
                  Navigator.of(context).push(route);
                },
              ),
            ),
          ],
        )),
        // Expanded (
        Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: [20,20],
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${selectlang.getAlbum(modulename, lang_selection)}",
              style: TextStyle(
                color: AppColors.styleColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
        // )
      ],
    );
  }

  Future<bool> loginAction() async {
    //replace the below line of code with your login request
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await new Future.delayed(const Duration(seconds: 2));
    localPref = prefs;
    return true;
  }
}
