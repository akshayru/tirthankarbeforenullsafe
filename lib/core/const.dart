import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color mainColor = Color(0XFFe5eefc);
  static Color styleColor = Color(0XFF6f7e96);
  static Color activeColor = Color(0XFFd0ddf3);
  static Color lightBlue = Color(0XFF92aeff);
  static Color darkBlue = Color(0XFF5880ff);
  static Color lightBlueShadow = Color(0XAA92aeff);
  static Color white = Color(0XFFFFFFFF);
  static Color white54 = Color(0X8AFFFFFF);
  static Color brown = Color(0XFF795548);
  static Color brown200 = Color(0XFFBCAAA4);
  static Color red200 = Color(0xFFEF9A9A);
  static Color black = Color(0XFF000000);
  static Color darkmode = Color(0X73000000);
  static Color transperent = Colors.transparent;

  AppColors() {
    String mode;
    // mode = "darkmode";
    switch (mode) {
      case "darkMode":        
        mainColor = Color(0XFFe5eefc);
        styleColor = Color(0XFF6f7e96);
        activeColor = Color(0xff0B2512);
        lightBlue = Color(0XFF92aeff);
        darkBlue = Color(0xff3B3B3B);
        lightBlueShadow = Color(0xff372901);
        white = Color(0XFFFFFFFF);
        white54 = Color(0X8AFFFFFF);
        brown = Color(0XFF795548);
        brown200 = Color(0XFFBCAAA4);
        red200 = Color(0xFFEF9A9A);
        black = Color(0XFF000000);
        darkmode = Color(0X73000000);
        transperent = Colors.transparent;
        break;
      default:
        mainColor = Color(0XFFe5eefc);
        styleColor = Color(0XFF6f7e96);
        activeColor = Color(0XFFd0ddf3);
        lightBlue = Color(0XFF92aeff);
        darkBlue = Color(0XFF5880ff);
        lightBlueShadow = Color(0XAA92aeff);
        white = Color(0XFFFFFFFF);
        white54 = Color(0X8AFFFFFF);
        brown = Color(0XFF795548);
        brown200 = Color(0XFFBCAAA4);
        red200 = Color(0xFFEF9A9A);
        black = Color(0XFF000000);
        darkmode = Color(0X73000000);
        transperent = Colors.transparent;
        break;
    }
  }
}
