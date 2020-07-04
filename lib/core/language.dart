import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tirthankar/models/music.dart';
// / import 'employee.dart';
 
class languageSelector {
  String album="";
  String ename = "";
  String mname = "";
  String esign = "";
  String msign = "";
  String other1 = "";
  String other2 = "";
  String title = "";
  String appname = "";
  
  String getAlbum (String module,int lang_index){
    if (lang_index == 0 || lang_index==null){
      return module;
    } else {
      switch (module) {
        case "Tirthankar":
          return "तीर्थंकर";
          break;      
        case "Language":
          return "भाषा";
          break;          
        case "Pravchan":
          return "प्रवचन";
          break;
        case "Bhaktambar":
          return "भक्ताम्बर";
          break; 
        case "Namokar":
          return "णमोकार";
          break;
        case "Bhajan":
          return "भजन";
          break;
        case "Kids":
          return "किड्स";
          break;
        case "Stuti":
          return "स्तुति";
          break;
        case "Favorite":
          return "फेवरेट";
          break;
        case "Aarti":
          return "आरती";
          break;  
        case "Setting":
          return "सेटिंग";
          break;
       case "Praman Sagar":
          return "प्रमाणसागर जी";
          break;   
        case "Tarun Sagar":
          return "तरुणसागर जी";
          break;   
        case "Pushpdant Sagar":
          return "पुष्पदंतसागर जी";
          break;   
        case "Pulak Sagar":
          return "पुलकसागर जी";
          break;   
        case "Dr. HukumChand Ji Bharill":
          return "डॉ. हुकमचन्दजी";
          break;   
        case "Vidya Sagar":
          return "विद्यासागर जी";
          break;             
        default:
      }
    }

  }

  Future<int> getLanguage() async {
    int lang_index;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lang_index = prefs.getInt('language') ?? 0;
    return lang_index;
  }

 
  
   
}