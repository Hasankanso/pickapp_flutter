import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences _prefs;
  static bool _loading = false;
  static bool _failed = false;
  static Future<bool> init() async {
    _failed = false;
    _loading = true;

    try {
      _prefs = await SharedPreferences.getInstance();
    } catch(Exception){
      _failed = true;
    }
    _loading = false;
    return !_failed;
  }

  static bool get loading => _loading;

  static bool get failed => _failed;

  static void setLocale(String languageCode){
    _prefs.setString("LANG_CODE", languageCode);
  }

  static void setDateTimeRangePicker(String isRangePicker){
    _prefs.setString("isRangePicker", isRangePicker);
  }

  static forceDarkTheme(bool value)
  {
    _prefs.setBool("THEME_MODE", value);
  }

  static String get locale => _prefs.getString("LANG_CODE");

  static bool get dateTimeRangePicker => _prefs.getBool("isRangePicker") !=null? _prefs.getBool("isRangePicker")? true: false :false;

static bool get darkTheme => _prefs.getBool("THEME_MODE")!=null? _prefs.getBool("THEME_MODE")? true : false : false;
}
