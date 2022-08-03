import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    } catch (e) {
      _failed = true;
    }
    _loading = false;
    return _prefs;
  }

  static bool get loading => _loading;

  static bool get failed => _failed;

  static Future<void> clearHiveCache() async {
    await removeAllScheduledNotificationId();
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

  static setDisableAnimation(bool value) {
    _prefs.setBool("DISABLE_ANIMATION", value);
  }

  static setConditionAccepted(bool value) {
    _prefs.setBool("TERM_CONDITIONS", value);
  }

  static String get locale => _prefs.getString("LANG_CODE");

  static bool get conditionAccepted => _prefs.getBool(
            "TERM_CONDITIONS",
          ) !=
          null
      ? _prefs.getBool("TERM_CONDITIONS")
      : false;

  static bool get dateTimeRangePicker => _prefs.getBool("isRangePicker") != null
      ? _prefs.getBool("isRangePicker")
      : false;

  static bool get disableAnimation =>
      _prefs.getBool("DISABLE_ANIMATION") != null
          ? _prefs.getBool("DISABLE_ANIMATION")
          : false;

  static bool get darkTheme => _prefs.getBool("THEME_MODE") != null
      ? _prefs.getBool("THEME_MODE")
      : false;

  static Future<bool> setIsNewNotification(bool value) async {
    _prefs.setBool("IS_NEW_NOTIFICATION", value);
    return true;
  }

  static Future<bool> getIsNewNotification() async {
    var isNewNotification = _prefs.getBool(
      "IS_NEW_NOTIFICATION",
    );
    if (isNewNotification == null) return false;
    return isNewNotification;
  }

  static Future<bool> setCountriesList(List<String> value) async {
    _prefs.setStringList("COUNTRIES", value);
    return true;
  }

  static Future<List<String>> getCountriesList() async {
    var countries = _prefs.getStringList(
      "COUNTRIES",
    );
    if (countries == null) return [];
    return countries;
  }

  static Future<int> setScheduledNotificationId(String objectId) async {
    var box = await Hive.openBox("appSettings");
    int notificationId = box.get("NOTIFICATION_ID", defaultValue: 0);
    if (notificationId >= 500) {
      notificationId = -1;
    }
    notificationId += 1;
    await box.put("NOTIFICATION_ID", notificationId);

    var notificationD = box.get("NOTIFICATION_DICTIONARY",
        defaultValue: new Map<String, int>());

    notificationD = Map<String, dynamic>.from(notificationD);

    notificationD[objectId] = notificationId;
    await box.put("NOTIFICATION_DICTIONARY", notificationD);
    await box.close();
    return notificationId;
  }

  static Future<bool> removeAllScheduledNotificationId() async {
    var box = await Hive.openBox("appSettings");

    await box.delete("NOTIFICATION_ID");
    await box.delete("NOTIFICATION_DICTIONARY");

    await box.close();
    return true;
  }

  static Future<int> getScheduledNotificationId(String objectId) async {
    var box = await Hive.openBox("appSettings");
    var notificationD = box.get("NOTIFICATION_DICTIONARY",
        defaultValue: Map<String, dynamic>());
    notificationD = Map<String, dynamic>.from(notificationD);
    await box.close();
    return notificationD[objectId];
  }

  static Future<bool> removeScheduledNotificationId(String objectId) async {
    var box = await Hive.openBox("appSettings");
    var notificationD = box.get("NOTIFICATION_DICTIONARY");
    notificationD = Map<String, int>.from(notificationD);
    notificationD.remove(objectId);
    await box.put("NOTIFICATION_DICTIONARY", notificationD);
    await box.close();
    return true;
  }
}
