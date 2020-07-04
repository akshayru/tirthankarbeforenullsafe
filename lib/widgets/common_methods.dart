import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tirthankar/core/const.dart';
import 'package:flutter/material.dart';
import 'package:tirthankar/core/dbmanager.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as eos;
import 'package:tirthankar/core/language.dart';
import 'package:tirthankar/models/music.dart';

class common_methods {
  final sqllitedb dbHelper = new sqllitedb();
  final languageSelector selectlang = new languageSelector();

  displayDialog(
      BuildContext context, String title, String message, Widget child) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      // barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 700),
      context: context,
      builder: (context) {
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

  Future<void> downloadSongList(context, String appname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date1;
    bool firstinstall = false;
    dbversion = prefs.getInt('dbversion');
    downloadDate = prefs.getString('downloadDate');
    if (downloadDate == null || downloadDate == "") {
      firstinstall = true;
      // isInternet(context);
      date1 = DateTime.now();
    } else {
      date1 = DateTime.parse(downloadDate);
    }
    isInternet(context);
    final date2 = DateTime.now();
    final difference = date2.difference(date1).inDays;
    // if (difference == 0) {
    if (difference > 30 || firstinstall == true) {
      if (internet == false) {
        displayDialog(
          context,
          "Internet Check",
          "No internter connection.",
          Icon(
            Icons.signal_wifi_off,
            size: 100,
            color: AppColors.red200,
          ),
        );
      } else {
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

            songlist = tagObjsJson
                .map((tagJson) => MusicData.fromJson(tagJson))
                .toList();
            if (dbversion == body['version']) {
              print("No DB update");
            } else {
              // dbHelper.batchInsertEventSongAsync(_list, body['version']);
              dbHelper.buildDB1(songlist, body['version']);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<bool> isInternet(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        internet = true;
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        noInternet(context);
        internet = false;
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        internet = true;
        return true;
      } else {
        // Wifi detected but no internet connection found.
        noInternet(context);
        internet = false;
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      noInternet(context);
      internet = false;
      return false;
    }
  }

  noInternet(BuildContext context) {
    displayDialog(
      context,
      "Internet Check",
      "No internter connection.",
      Icon(
        Icons.signal_wifi_off,
        size: 100,
        color: AppColors.red200,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.styleColor,
      centerTitle: true,
      title: Text(
        selectlang.getAlbum("Tirthankar", lang_selection),
        style: TextStyle(color: AppColors.white),
      ),
    );
  }

  Future<void> getSharedPref(String variable) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (variable) {
      case "language":
        lang_selection = prefs.getInt('language') ?? 0;
        print(lang_selection);

        break;
      case "downloadDate":
        downloadDate = prefs.getString('downloadDate') ?? 0;
        if (downloadDate == null) {
          final date2 = DateTime.now();
          setSharedPref('downloadDate', date2.toString(), 0);
          downloadDate = date2.toString();
        }

        print(downloadDate);
        break;
      case "":
        lang_selection = prefs.getInt('language') ?? 0;
        downloadDate = prefs.getString('downloadDate');
        if (downloadDate == null) {
          final date2 = DateTime.now();
          setSharedPref('downloadDate', date2.toString(), 0);
          downloadDate = date2.toString();
        }
        print(lang_selection);
        print(downloadDate);
        break;
      default:
        lang_selection = prefs.getInt('language') ?? 0;
        downloadDate = prefs.getString('downloadDate');
        if (downloadDate == null) {
          final date2 = DateTime.now();
          setSharedPref('downloadDate', date2.toString(), 0);
          downloadDate = date2.toString();
        }
        print(lang_selection);
        print(downloadDate);
    }
  }

  Future<void> setSharedPref(
      String variable, String downloadDate, int lang) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (variable) {
      case "language":
        prefs.setInt('language', lang);
        lang_selection = lang;
        break;
      case "downloadDate":
        prefs.setString('downloadDate', downloadDate);
        downloadDate = downloadDate;
        break;
      default:
    }
  }
}
