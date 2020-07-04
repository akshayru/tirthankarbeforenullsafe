// import 'dart:js';

import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:convert';

import 'package:tirthankar/core/const.dart';
import 'package:tirthankar/core/dbmanager.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:tirthankar/models/listdata.dart';
import 'package:tirthankar/models/music.dart';
import 'package:tirthankar/pages/pdf.dart';
import 'package:tirthankar/widgets/common_methods.dart';
import 'package:tirthankar/widgets/custom_button_widget.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:tirthankar/pages/home.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as eos;

class ListPage extends StatefulWidget {
  String appname;
  // int playingId;
  // List<MusicData> list;
  // ListPage({this.appname,this.playingId,this.list});
  Data data;
  ListPage({this.appname, this.data});
  @override
  _ListPageState createState() => _ListPageState(appname, data);
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  String appname;
  Data data;
  // PageController _pageController;
  // List<MusicData> list;
  bool isPlaying = false;
  bool isPause = false;
  // bool isOldData = false;
  _ListPageState(this.appname, this.data); // List<MusicModel> _list1;
  final sqllitedb dbHelper = new sqllitedb();
  final common_methods commonmethod = new common_methods();
  List<MusicData> _list;

  int _playId;
  int _songId;
  int _favstate;

  String _playURL;

  bool _isRepeat;
  bool _isShuffle;
  bool _isFavorite;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  final _random = new Random();
  AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    // _pageController = PageController();
    data = inuseAudioinfo;
    if (data != null) {
      // if (inuseAudioinfo == null){
      if (appname == data.appname) {
        _playId = data.playId;
        _songId = data.songId;
        _audioPlayer = data.audioPlayer;
        _isRepeat = data.isRepeat;
        _isShuffle = data.isShuffle;
        isPlaying = data.isPlaying;
        _duration = data.duration;
        _position = data.position;
        _list = data.list;
        _isFavorite = false;
      } else if (data.isPlaying == false) {
        _playId = 0;
        this.downloadSongListDB(appname);
        // this.downloadSongList(appname);
        _isRepeat = false;
        _isShuffle = false;
        _isFavorite = false;
      } else {
        //  _playId = data.playId;
        // _songId = data.songId;
        // _playId = 0;
        _audioPlayer = data.audioPlayer;
        _isRepeat = data.isRepeat;
        _isShuffle = data.isShuffle;
        isPlaying = data.isPlaying;
        _duration = data.duration;
        _position = data.position;
        // _list = data.list;
        _isFavorite = false;
        // this.downloadSongList(appname);
        this.downloadSongListDB(appname);
      }
    } else {
      _playId = 0;
      this.downloadSongListDB(appname);
      // this.downloadSongList(appname);
      _isRepeat = false;
      _isShuffle = false;
      _isFavorite = false;
    }
    if (inuseAudioinfo == null) {}

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        // _startTime = duration.toString().split(".")[0];
        _duration = duration;
        // _position = duration.toString().split(".")[0];
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _position = duration;
      });
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
        _position = _duration;
        if (_isRepeat) {
          _songId = _songId;
        } else {
          if (_isShuffle) {
            var element = _list[_random.nextInt(_list.length)];
            _songId = element.id;
          } else {
            // if (_songId < _list.length-0){
            _songId = _songId + 1;
            // } else {
            //   _songId = _songId;
            // }

          }
        }
        _player(_songId);
      });
    });

    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _pageController?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // var themeData = Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black87);
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.styleColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (isPlaying == true || isPause == true) {
              if (inuseAudioinfo == null) {
                inuseAudioinfo = buildData();
              }
            } else {
              inuseAudioinfo = null;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HomePage(
                  appname: appname,
                  // data: ndata,
                ),
              ),
            );
          },
        ),
        title: Text(
          appname,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      // backgroundColor: themeData.scaffoldBackgroundColor,
      backgroundColor: AppColors.mainColor,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButtonWidget(
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.styleColor,
                      ),
                      size: 50,
                      onTap: () {},
                    ),
                    CustomButtonWidget(
                      image: 'assets/logo.jpg',
                      size: 100,
                      borderWidth: 5,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Pdfview(
                              appname: appname,
                              pdfpage: 10,
                            ),
                          ),
                        );
                      },
                    ),
                    CustomButtonWidget(
                      child: Icon(
                        Icons.menu,
                        color: AppColors.styleColor,
                      ),
                      size: 50,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HomePage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              buildListView(),
              Row(children: <Widget>[
                Expanded(child: slider()),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        _isRepeat ? Icons.repeat_one : Icons.repeat,
                        color:
                            _isRepeat ? AppColors.brown : AppColors.styleColor,
                      ),
                      onPressed: () {
                        if (_playId != null) {
                          if (_isRepeat) {
                            _isRepeat = false;
                          } else {
                            _isRepeat = true;
                          }
                        } else {
                          _showDialog(
                            "",
                            "Please select song to repeat.",
                            Icon(
                              Icons.repeat_one,
                              size: 100,
                              color: AppColors.white54,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.styleColor,
                        ),
                        onPressed: () {
                          _player(_songId);
                        }),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: AppColors.styleColor,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            _audioPlayer.stop();
                            setState(() {
                              isPlaying = false;
                              _duration = new Duration();
                            });
                          }

                          // isPlaying = false;
                        }),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: _isShuffle
                              ? AppColors.brown
                              : AppColors.styleColor,
                        ),
                        onPressed: () {
                          if (_isShuffle) {
                            _isShuffle = false;
                          } else {
                            _isShuffle = true;
                          }
                        }),
                  ),
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildListView() {
    return Expanded(
      //This is added so we can see overlay else this will be over button
      child: ListView.builder(
        physics:
            BouncingScrollPhysics(), //This line removes the dark flash when you are at the begining or end of list menu. Just uncomment for
        // itemCount: _list.length,
        itemCount: _list == null ? 0 : _list.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          _favstate = _list[index].isfave;
          if (data != null) {
            if (data.songId != null && data.appname == appname) {
              child:
              buildAnimatedContainer(data.songId);
            }
          }
          return GestureDetector(
            onTap: () {
              inuseAudioinfo = null;
              _songId = index;
              if (_list[index].songURL == null ||
                  _list[index].songURL == "" ||
                  (_list[index].songURL).isEmpty) {
                if (_list[index].songURL != "") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Pdfview(
                        appname: appname,
                        pdfpage: _list[index].pdfpage,
                      ),
                    ),
                  );
                } else {
                  commonmethod.displayDialog(
                    context,
                    "",
                    "Unable to play this song.",
                    Icon(
                      Icons.library_music,
                      size: 100,
                      color: AppColors.white54,
                    ),
                  );
                }
              } else {
                _player(index);
              }
            },
            child: buildAnimatedContainer(index),
          );
        },
      ),
    );
  }

  Data buildData() {
    return Data(
        playId: _playId,
        songId: _songId,
        audioPlayer: _audioPlayer,
        isPlaying: isPlaying,
        isRepeat: _isRepeat,
        isShuffle: _isShuffle,
        duration: _duration,
        position: _position,
        list: _list,
        appname: appname);
  }

  AnimatedContainer buildAnimatedContainer(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      //This below code will change the color of selected area or song being played.
      decoration: BoxDecoration(
        color: _list[index].id == _playId
            ? AppColors.activeColor
            : AppColors.mainColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      //End of row color change
      child: Padding(
        padding:
            const EdgeInsets.all(16), //This will all padding around all size
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, //This will allign button to left, else button will be infront of name

          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ScrollingText(
                //   text: "This is my sample text",
                // ),

                Text(
                  _list[index].title,
                  style: TextStyle(
                    color: AppColors.styleColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _list[index].album,
                  style: TextStyle(
                    color: AppColors.styleColor.withAlpha(90),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            new Spacer(),
            IconButton(
                alignment: Alignment.centerLeft,
                icon: Icon(
                  Icons.book,
                  color: AppColors.brown200,
                ),
                color: AppColors.red200,
                // alignment: Alignment.centerRight,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Pdfview(
                        appname: appname,
                        pdfpage: _list[index].pdfpage,
                      ),
                    ),
                  );
                  setState(() {});
                }), // new Spacer(),

            IconButton(
                icon: Icon(
                    _favstate == 1 ? Icons.favorite : Icons.favorite_border),
                color: AppColors.red200,
                onPressed: () {
                  setState(() {
                    if (_list[index].isfave == 1) {
                      _favstate = 0;
                      _list[index].isfave = 0;
                      dbHelper.updateFavorite(_list[index].id, 0);
                      commonmethod.displayDialog(
                        context,
                        "",
                        "Song removed from favorite",
                        Icon(
                          Icons.favorite_border,
                          size: 100,
                          color: AppColors.red200,
                        ),
                      );
                    } else {
                      _favstate = 1;
                      _list[index].isfave = 1;
                      dbHelper.updateFavorite(_list[index].id, 1);
                      commonmethod.displayDialog(
                        context,
                        "",
                        "Song added to favorite",
                        Icon(
                          Icons.favorite,
                          size: 100,
                          color: AppColors.red200,
                        ),
                      );
                    }
                  });
                })
          ],
        ),
      ),
    );
  }

  Widget slider() {
    return Slider(
        activeColor: AppColors.styleColor,
        inactiveColor: AppColors.lightBlue,
        value: _duration.inSeconds.toDouble(),
        min: 0.0,
        max: _position.inSeconds.toDouble(),
        divisions: 10,
        onChangeStart: (double value) {
          print('Start value is ' + value.toString());
        },
        onChangeEnd: (double value) {
          print('Finish value is ' + value.toString());
        },
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  Future<Void> downloadSongList(String appname) async {
    String url =
        "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/input.json";
    String arrayObjsText = "";
    // '{ "version":1, "tags": [ { "id": 1, "title": "Namp 1", "album": "Flume", "songURL": "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/Namokar/Namokaar+Mantra+by+Lata+Mangeshkar.mp3", "hindiName": "Testing 1", "favorite": false }, { "id": 2, "title": "Namp 2", "album": "Flume", "songURL": "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/Namokar/Namokar+Mantra+by+Anurasdha+Paudwal.mp3", "hindiName": "Testing 1", "favorite": false }, { "id": 3, "title": "Namp 3", "album": "Flume", "songURL": "https://parshtech-songs-jainmusic.s3.us-east-2.amazonaws.com/Namokar/Namokaar+Mantra+by+Lata+Mangeshkar.mp3", "hindiName": "Testing 1", "favorite": false } ] }';
    // '{"tags": [{"name": "dart", "quantity": 12}, {"name": "flutter", "quantity": 25}, {"name": "json", "quantity": 8}]}';
    try {
      eos.Response response;
      Dio dio = new Dio();
      response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );
      // _list = response.data;
      arrayObjsText = response.data;
      // arrayObjsText = response.data.toString();
      // print(response.data.toString());
    } catch (e) {
      print(e);
    }
    var tagObjsJson = jsonDecode(arrayObjsText)['tags'] as List;
    this.setState(() {
      _list =
          tagObjsJson.map((tagJson) => MusicData.fromJson(tagJson)).toList();
    });
  }

  Future<List<MusicData>> downloadSongListDB(String appname) async {
    String sql = "";
    try {
      switch (appname.toUpperCase()) {
        case "FAVORITE":
          sql = "select * from songs where isfave=1";
          break;
        case "KIDS":
        case "STORY":
          sql = "select * from songs where album='$appname'";
          break;
        default:
          sql = "select * from songs where album='$appname'";
          break;
      }
      // _list = dbHelper.getSong("select * from songs where album='$appname'");
      List<MusicData> list1 = await dbHelper.getSongList(sql);

      // Future<List<MusicData>> list = await list1;
      _list = list1;
      setState(() {
        buildListView();
      });
    } catch (e) {
      print(e);
    }
  }

  // user defined function
  void _showDialog(String title, String message, Widget child) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      // barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 700),
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });

        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.only(top: 5.0),
          backgroundColor: AppColors.styleColor,
          content: Container(
            height: 150,
            // margin: EdgeInsets.all(1.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75),
                    child: child ?? Container(),
                  )
                ]),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text(
                      message,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ])
              ]),
            ),
          ),
          elevation: 50,
        );
      },
    );
  }

  Future<void> _player(int index) async {
    commonmethod.isInternet(context);
    if (isPlaying && index != null) {
      if (_playId == _list[index].id) {
        _songId = index;
        int status = await _audioPlayer.pause();
        if (status == 1) {
          setState(() {
            isPause = true;
            isPlaying = false;
          });
        }
      } else {
        _playId = _list[index].id;
        _songId = index;
        _playURL = _list[index].songURL;
        _audioPlayer.stop();
        int status = await _audioPlayer.play(_playURL);
        if (status == 1) {
          setState(() {
            isPlaying = true;
          });
        }
      }
    } else {
      if (index == null) {
        if (isPlaying) {
          _audioPlayer.pause();
          setState(() {
            isPause = true;
            isPlaying = false;
          });
        } else {
          if (!isPlaying) {
            if (isPause) {
              _audioPlayer.resume();
              // isPlaying = true;
              setState(() {
                isPause = false;
                isPlaying = true;
              });
            } else {
              _showDialog(
                "",
                "Select song from list to play.",
                Icon(
                  Icons.library_music,
                  size: 100,
                  color: AppColors.white54,
                ),
              );
            }
          }
        }
      } else if (index != null && isPause == true) {
        _audioPlayer.resume();
        // isPlaying = true;
        setState(() {
          isPause = false;
          isPlaying = true;
        });
      } else {
        _playId = _list[index].id;
        _songId = index;
        _playURL = _list[index].songURL;
        int status = await _audioPlayer.play(_playURL);
        if (status == 1) {
          setState(() {
            isPlaying = true;
          });
        }
      }
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(IterableProperty<MusicData>('_list', _list));
  // }
}
