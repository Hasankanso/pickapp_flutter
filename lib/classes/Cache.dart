import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences _prefs;
  static bool _initialized = false;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  static bool get loaded => _initialized;

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
