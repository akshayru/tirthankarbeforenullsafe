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
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String appname;
  Data data;
  YoutubePlayerController _controller;
  final languageSelector selectlang = new languageSelector();
  final common_methods commonmethod = new common_methods();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
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
        backgroundColor: AppColors.styleColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => YoutubePlay(
                  appname: appname,
                  // data: ndata,
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
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready.');
        },
      ),
    );
  }

  Data buildData() {
    Data ndata;
    if (data == null) {
      return null;
    } else {
      return data;
    }
  }
}
