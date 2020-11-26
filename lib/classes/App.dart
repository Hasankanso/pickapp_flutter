import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/main.dart';

class App {
  static MyAppState _state;
  static final String appName = "PickApp";
  static TextStyle textStyling = new TextStyle(fontSize: 30);
  static final String googleKey = "AIzaSyC7U0OEb9200tGZFFFTyLjQdo3goKyuSsw";
  static String dateFormat = 'dd/MM/yyyy';
  static String countryCode = "lb";
  static User _user;
  static bool _isLoggedIn = true;

  static void changeLanguage(String lang) async {
    await Cache.setLocale(lang);
    _state.setLocale(Locale(lang));
  }

  static void init(MyAppState state) {
    _state = state;
  }

  //called in Home class
  static void setContext(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    ScreenUtil.init(context,
        designSize: Size(360, 640), designStatusBarHeight : 24, allowFontScaling: true);
    Styles.setFontSizes(
        subValueFontSize: ScreenUtil().setSp(12.24),
        fontSize: ScreenUtil().setSp(15),
        titleFontSize: ScreenUtil().setSp(17.64));
    Styles.setIconSizes(
        largeSize: ScreenUtil().setSp(27),
        mediumSize: ScreenUtil().setSp(21),
        smallSize: ScreenUtil().setSp(14.5));
  }

  static bool isNullOrEmpty(String toCheck) {
    if (["", null].contains(toCheck)) return true;
    return false;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIphone() {
    return Platform.isIOS;
  }

  static bool get isLoggedIn => _isLoggedIn;

  static set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  static User get user => _user;

  static set user(User value) {
    _user = value;
  }

  static Driver get driver => user == null ? null : user.driver;
  static Person get person => user == null ? null : user.person;
}
