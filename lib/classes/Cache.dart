import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences _prefs;
  static bool _loading = false;
  static bool _failed = false;
  static ValueNotifier<bool> rangeDateTimeNotifier;

  static Future<SharedPreferences> init() async {
    _failed = false;
    _loading = true;

    try {
      _prefs = await SharedPreferences.getInstance();
      rangeDateTimeNotifier = ValueNotifier<bool>(Cache.dateTimeRangePicker);
    } catch (Exception) {
      _failed = true;
    }
    _loading = false;
    return _prefs;
  }

  static bool get loading => _loading;

  static bool get failed => _failed;

  static setUserCache(u) async {
    final userBox = Hive.box("user");
    User cacheUser = u;

    Person cachePerson = u.person;
    cachePerson.rates = null;
    cacheUser.person = cachePerson;
    var regions;
    if (u.driver != null) {
      regions = u.driver.regions;
      var d = u.driver;
      cacheUser.driver = Driver(id: d.id, cars: d.cars, updated: d.updated);
      App.isDriverNotifier.value = true;
    }

    if (userBox.containsKey(0)) {
      await userBox.put(0, cacheUser);
    } else {
      userBox.add(cacheUser);
    }
    if (regions != null) {
      await Hive.openBox('regions');
      final regionsBox = Hive.box("regions");
      if (regionsBox.containsKey(0)) {
        await regionsBox.put(0, regions);
      } else {
        regionsBox.add(regions);
      }
      regionsBox.close();
    }
    App.isLoggedIn = true;
    App.isLoggedInNotifier.value = true;
    App.isLoggedInNotifier.notifyListeners();
    Inbox.subscribeToChannel();
  }

  static void setLocale(String languageCode) {
    _prefs.setString("LANG_CODE", languageCode);
  }

  static void setDateTimeRangePicker(bool isRangePicker) {
    _prefs.setBool("isRangePicker", isRangePicker);
    rangeDateTimeNotifier.value = isRangePicker;
  }

  static setTheme(bool value) {
    _prefs.setBool("THEME_MODE", value);
  }

  static setConditionAccepted(bool value) {
    _prefs.setBool("TERM_CONDITIONS", value);
  }

  static String get locale => _prefs.getString("LANG_CODE");

  static bool get conditionAccepted => _prefs.getBool("TERM_CONDITIONS") != null
      ? _prefs.getBool("TERM_CONDITIONS")
          ? true
          : false
      : false;

  static bool get dateTimeRangePicker => _prefs.getBool("isRangePicker") != null
      ? _prefs.getBool("isRangePicker")
          ? true
          : false
      : false;

  static bool get darkTheme => _prefs.getBool("THEME_MODE") != null
      ? _prefs.getBool("THEME_MODE")
          ? true
          : false
      : false;
}
