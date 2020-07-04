import 'package:shared_preferences/shared_preferences.dart';
import 'package:tirthankar/models/listdata.dart';
import 'package:tirthankar/models/music.dart';

const String YOUTUBE_KEY='AIzaSyCqgguJhqJBWBMvGwGAW4STCvnCfC_WlVs';
//Akshay Key - 'AIzaSyCprW3guMdiCuim9iUkZrOdHmyrXqla4gg';

int lang_selection;
bool internet;
String downloadDate;
SharedPreferences localPref;
List<MusicData> songlist;
Data inuseAudioinfo;
var dbversion;


Future init() async {
  localPref = await SharedPreferences.getInstance();
}