import 'package:flutter/services.dart';

import 'package:tirthankar/core/const.dart';
import 'package:tirthankar/core/dbmanager.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:tirthankar/core/language.dart';
import 'package:tirthankar/models/listdata.dart';
import 'package:tirthankar/models/music.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

import 'package:tirthankar/pages/youtube.dart';
import 'package:tirthankar/pages/home.dart';
import 'package:tirthankar/widgets/common_methods.dart';
import 'package:tirthankar/widgets/custom_button_widget.dart';
import 'package:tirthankar/widgets/custome_grid_widget.dart';
// import 'package:youtube_api/youtube_api.dart';

class MuniPage extends StatefulWidget {
  // int playingId;
  // Data data;
  String appname;

  // List<MusicData> list;
  MuniPage({this.appname});
  @override
  _MuniPageState createState() => _MuniPageState(appname);
}

class _MuniPageState extends State<MuniPage> {
  String appname;
  // Data data;
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
  _MuniPageState(this.appname);
  // print('${playingId}');

  @override
  void initState() {
    appname = "";

    WidgetsBinding.instance.addPostFrameCallback((_) => setup());
  }

  setup() {
    commonmethod.isInternet(context);
    // isInternet();
    commonmethod.downloadSongList(context, appname);
  }

  @override
  void setState(fn) {}

  @override
  Widget build(BuildContext context) {
    final myImageAndCaption = [
      ["assets/pramansagar.png", "Praman Sagar"],
      ["assets/tarunsagar.png", "Tarun Sagar"],
      ["assets/vidyasagar.png", "Vidya Sagar"],
      ["assets/hukumchand.png", "Dr. HukumChand Ji Bharill"],
      ["assets/pulaksagar.png", "Pulak Sagar"],
      ["assets/pushpdantsagar.png", "Pushpdant Sagar"]
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
                    // shape: CircleBorder(),
                    // elevation: 3.0,
                    // child: Image.asset(
                    //   i.first,
                    //   fit: BoxFit.fitWidth,
                    //   height: 100,
                    //   width: 100,
                    // ),

                    child: CustomButtonWidget(
                      image: i.first,
                      size: 100,
                      borderWidth: 5,
                      onTap: () {
                        // commonmethod.isInternet(context);
                        if (internet != false) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => YoutubePlay(
                                appname: getYoutubeSearchName(i.last),
                              ),
                            ),
                          );
                        }
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

  String getYoutubeSearchName(String muni) {
    String muniname = selectlang.getAlbum(muni, 0);
    switch (muniname) {
      case "Praman Sagar":
        return "praman sagar ji maharaj pravachan ";
        break;
      case "Tarun Sagar":
        return "Tarun Sagar ji maharaj pravachan ";
        break;
      case "Vidya Sagar":
        return "Vidya Sagar ji maharaj pravachan ";
        break;
      case "Dr. HukumChand Ji Bharill":
        return "hukumchand bharill ji ke pravachan";
        break;
      case "Pulak Sagar":
        return "Pulak Sagar ji maharaj pravachan ";
        break;
      case "Pushpdant Sagar":
        return "Pushpdant Sagar ji maharaj pravachan ";
        break;
      case "Praman Sagar":
        return "praman sagar ji maharaj pravachan ";
        break;
      case "Praman Sagar":
        return "praman sagar ji maharaj pravachan ";
        break;
      default:
        return "jain muni pravachan";
    }
  }

  Column buildItem(BuildContext context, String impagepath, String modulename) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomButtonWidget(
                image: impagepath,
                size: 100,
                borderWidth: 5,
                onTap: () {
                  if (internet == false) {
                    commonmethod.displayDialog(
                      context,
                      "Internet Check",
                      "No internet connection.",
                      Icon(
                        Icons.signal_wifi_off,
                        size: 100,
                        color: AppColors.red200,
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => YoutubePlay(
                          appname: appname,
                          // data: data,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        // ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  "${selectlang.getAlbum(modulename, lang_selection)}",
                  style: TextStyle(
                    color: AppColors.styleColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        // )
      ],
    );
  }
}
