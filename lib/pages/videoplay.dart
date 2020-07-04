import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:tirthankar/core/const.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:tirthankar/models/listdata.dart';
import 'package:tirthankar/pages/youtube.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tirthankar/widgets/common_methods.dart';
import 'package:tirthankar/core/language.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState(id);
}

class _VideoScreenState extends State<VideoScreen> {
  String appname;
  Data data;
  String id;  
  final languageSelector selectlang = new languageSelector();
  final common_methods commonmethod = new common_methods();
  _VideoScreenState(this.id);
  @override
  void initState() {
    super.initState();    
  }

  @override
  void dispose() {
    // Never called
    print("Disposing first route");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    //   // DeviceOrientation.portraitDown,
    //   // DeviceOrientation.portraitUp,
    // ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.styleColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){                      
            Navigator.of(context).pop(false);     
          },
        ),
        title: Text(
          "Tirthankar",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.mainColor,
      body: FlutterYoutube.playYoutubeVideoById(
          apiKey: YOUTUBE_KEY,
          videoId: id,
          autoPlay: true, //default falase
          fullScreen: true //default false
          ),
    );
  }  
}
