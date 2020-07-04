import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tirthankar/pages/home.dart';
import 'package:tirthankar/pages/youtubelist.dart';
import 'package:tirthankar/widgets/common_methods.dart';


import 'Pages/dashboard_page.dart';

void main() {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  final common_methods commonmethod = new common_methods();
  
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Tirthankar',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      home: HomePage(),
    );
  }
}


  


