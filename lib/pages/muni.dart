import 'package:Tirthankar/widgets/custome_tilebuilder.dart';
import 'package:flutter/services.dart';

import 'package:Tirthankar/core/const.dart';
import 'package:Tirthankar/core/dbmanager.dart';
import 'package:Tirthankar/core/keys.dart';
import 'package:Tirthankar/core/language.dart';
import 'package:Tirthankar/models/listdata.dart';
import 'package:Tirthankar/models/music.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

import 'package:Tirthankar/pages/youtube.dart';
import 'package:Tirthankar/pages/home.dart';
import 'package:Tirthankar/widgets/common_methods.dart';
import 'package:Tirthankar/widgets/custom_button_widget.dart';
import 'package:Tirthankar/widgets/custome_grid_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  // final sqllitedb dbHelper = new sqllitedb();
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
        body: Container(
          margin: EdgeInsets.all(12),
          child: new StaggeredGridView.countBuilder(
              crossAxisCount: kIsWeb ? 4 : 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 12,
              itemCount: myImageAndCaption.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => YoutubePlay(
                          appname: "Pravchan",
                          search:
                              getYoutubeSearchName(myImageAndCaption[index][1]),
                        ),
                      ),
                    );
                    print("Container clicked" + myImageAndCaption[index][1]);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: CustomTileBuilder(
                              imagepath: myImageAndCaption[index][0],
                              name: myImageAndCaption[index][1]))),
                );
              },
              staggeredTileBuilder: (index) {
                return new StaggeredTile.count(1, index.isEven ? 1 : 0.8);
              }),
        ),

        // GridView.count(
        //   crossAxisCount: 3,
        //   children: [
        //     ...myImageAndCaption.map(
        //       (i) => Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Material(
        //             color: AppColors.mainColor,
        //             // shape: CircleBorder(),
        //             // elevation: 3.0,
        //             // child: Image.asset(
        //             //   i.first,
        //             //   fit: BoxFit.fitWidth,
        //             //   height: 100,
        //             //   width: 100,
        //             // ),

        //             child: CustomButtonWidget(
        //               image: i.first,
        //               size: 100,
        //               borderWidth: 5,
        //               onTap: () {
        //                 // commonmethod.isInternet(context);
        //                 if (internet != false) {
        //                   Navigator.of(context).push(
        //                     MaterialPageRoute(
        //                       builder: (_) => YoutubePlay(
        //                         appname: "Pravchan",
        //                         search: getYoutubeSearchName(i.last),
        //                       ),
        //                     ),
        //                   );
        //                 }
        //               },
        //             ),
        //           ),
        //           Expanded(
        //             flex: 1,
        //             child: Container(
        //               alignment: Alignment.center,
        //               padding: EdgeInsets.all(2),
        //               child: Text(
        //                   "${selectlang.getAlbum(i.last, lang_selection)}"),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
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
}
