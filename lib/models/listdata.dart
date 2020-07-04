

import 'package:audioplayers/audioplayers.dart';

import 'music.dart';

class Data {  
  String appname;
  int playingId;
  List<MusicData> list;  
  bool isPlaying = false;   
  int playId;
  int songId;
  String playURL;  
  bool isRepeat;
  bool isShuffle;  
  Duration duration = new Duration();
  Duration position = new Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  Data({this.appname, this.playingId, this.isPlaying,this.audioPlayer,this.duration,this.isRepeat,this.isShuffle,this.playId,this.position,this.songId,this.list});
}