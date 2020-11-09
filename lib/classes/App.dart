import 'package:flutter/material.dart';
import 'package:pickapp/main.dart';
import 'package:pickapp/classes/Cache.dart';
import'dart:io' show Platform;

class App {
  static MyAppState _state;
  static BuildContext _context;
  static final String appName = "Pickapp";
  static TextStyle textStyling = new TextStyle(fontSize: 30);
  static final String googleKey = "AIzaSyC7U0OEb9200tGZFFFTyLjQdo3goKyuSsw";

  static void changeLanguage(String lang) async {
    await Cache.setLocale(lang);
    _state.setLocale(Locale(lang));
  }

  static void init(MyAppState state) {
    _state = state;
  }

  static bool isAndroid(){
    return Platform.isAndroid;
  }

  static bool isIphone(){
    return Platform.isIOS;
  }

}
