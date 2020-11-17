import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/main.dart';

class App {
  static MyAppState _state;
  static BuildContext _context;
  static final String appName = "PickApp";
  static TextStyle textStyling = new TextStyle(fontSize: 30);
  static final String googleKey = "AIzaSyC7U0OEb9200tGZFFFTyLjQdo3goKyuSsw";
  static bool isLoggedIn = true;
  static String dateFormat = 'dd/MM/yyyy';
  static MediaQueryData mediaQuery;
  static void changeLanguage(String lang) async {
    await Cache.setLocale(lang);
    _state.setLocale(Locale(lang));
  }

  static void init(MyAppState state) {
    _state = state;
  }

  //called in Home class
  static void setContext(BuildContext context){
    mediaQuery = MediaQuery.of(context);
    WidgetsFlutterBinding.ensureInitialized();
    ScreenUtil.init(context, designSize: Size(360, 640), allowFontScaling: true);
    Styles.setFontSizes(subValueFontSize : ScreenUtil().setSp(12.24), fontSize: ScreenUtil().setSp(15), titleFontSize:  ScreenUtil().setSp(17.64));
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isNullOrEmpty(String toCheck) {
    if (["", null].contains(toCheck)) return true;
    return false;
  }

  static bool isIphone() {
    return Platform.isIOS;
  }
}
