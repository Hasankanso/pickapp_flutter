import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/PushNotificationsManager.dart';
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

  static Future<void> clearHiveCache() async {
    // var rateB = await Hive.openBox<Rate>('rates');
    // await rateB.clear();
    // await rateB.close();
    await clearNotifications();
    var sNotfB = await Hive.openBox<MainNotification>('scheduledNotifications');
    await sNotfB.clear();
    await sNotfB.close();
    // var userB = Hive.box(User.boxName);
    // await userB.clear();
    // await ChatRepository().deleteChats();
    await removeAllScheduledNotification();
    await removeAllScheduledNotificationId();
  }

  static clearNotifications() async {
    var notfB = await Hive.openBox<MainNotification>('notifications');
    await notfB.clear();
    await notfB.close();
  }

  static Future<void> closeHiveBoxes() async {
    await Hive.close();
  }

  static Future<List<MainNotification>> getScheduledNotifications() async {
    var notificationBox;
    if (!Hive.isBoxOpen("scheduledNotifications")) {
      notificationBox = await Hive.openBox("scheduledNotifications");
    } else {
      notificationBox = Hive.box("scheduledNotifications");
    }
    List<MainNotification> returnNotifications = [];

    if (notificationBox.isOpen) {
      var scheduledNotifications =
          notificationBox.get("scheduledNotifications");
      if (scheduledNotifications != null) {
        scheduledNotifications =
            scheduledNotifications.cast<MainNotification>();
        returnNotifications = scheduledNotifications;
      }
      await notificationBox.close();
    }
    return returnNotifications;
  }

  static Future<bool> updateScheduledNotifications(
      List<MainNotification> allnotifications) async {
    var notificationBox;
    if (!Hive.isBoxOpen("scheduledNotifications")) {
      notificationBox = await Hive.openBox("scheduledNotifications");
    } else {
      notificationBox = Hive.box("scheduledNotifications");
    }
    if (notificationBox.isOpen) {
      await notificationBox.put("scheduledNotifications", allnotifications);
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> removeScheduledNotification(int notificationId) async {
    var notificationBox;
    if (!Hive.isBoxOpen("scheduledNotifications")) {
      notificationBox = await Hive.openBox("scheduledNotifications");
    } else {
      notificationBox = Hive.box("scheduledNotifications");
    }
    List<MainNotification> allNotf = [];

    if (notificationBox.isOpen) {
      var scheduledNotifications =
          notificationBox.get("scheduledNotifications");
      if (scheduledNotifications != null) {
        scheduledNotifications =
            scheduledNotifications.cast<MainNotification>();
        allNotf = scheduledNotifications;
      }
      await notificationBox.close();
    }
    for (int i = 0; i < allNotf.length; i++) {
      if (allNotf[i].notificationId == notificationId) {
        allNotf.remove(allNotf[i]);
        return true;
      }
    }
    return false;
  }

  static Future<bool> removeAllScheduledNotification() async {
    var notificationBox;
    if (!Hive.isBoxOpen("scheduledNotifications")) {
      notificationBox = await Hive.openBox("scheduledNotifications");
    } else {
      notificationBox = Hive.box("scheduledNotifications");
    }

    if (notificationBox.isOpen) {
      await notificationBox.delete("scheduledNotifications");
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> addScheduledNotification(
      MainNotification notification) async {
    var notificationBox = await Hive.openBox("scheduledNotifications");
    List<MainNotification> returnNotifications = [];

    if (notificationBox.isOpen) {
      var notfications = notificationBox.get("scheduledNotifications");
      if (notfications != null) {
        notfications = notfications.cast<MainNotification>();
        returnNotifications.addAll(notfications);
      }
      returnNotifications.add(notification);

      await notificationBox.put("scheduledNotifications", returnNotifications);
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<List<MainNotification>> getNotifications() async {
    var notificationBox;
    if (!Hive.isBoxOpen("notifications")) {
      notificationBox = await Hive.openBox("notifications");
    } else {
      notificationBox = Hive.box("notifications");
    }
    List<MainNotification> returnNotifications = [];

    if (notificationBox.isOpen) {
      var notifications = notificationBox.get("notifications");
      if (notifications != null) {
        notifications = notifications.cast<MainNotification>();
        returnNotifications.addAll(notifications);
      }
      await notificationBox.close();
    }
    return returnNotifications;
  }

  static Future<bool> updateNotifications(
      List<MainNotification> allnotifications) async {
    var notificationBox;
    if (!Hive.isBoxOpen("notifications")) {
      notificationBox = await Hive.openBox("notifications");
    } else {
      notificationBox = Hive.box("notifications");
    }
    if (notificationBox.isOpen) {
      await notificationBox.put("notifications", allnotifications);
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> addNotification(MainNotification notification) async {
    var notificationBox = await Hive.openBox("notifications");
    List<MainNotification> returnNotifications = [];

    if (notificationBox.isOpen) {
      var notfications = notificationBox.get("notifications");
      if (notfications != null) {
        notfications = notfications.cast<MainNotification>();
        returnNotifications.addAll(notfications);
      }
      returnNotifications.add(notification);
      while (returnNotifications.length >
          PushNotificationsManager.MAX_NOTIFICATIONS) {
        returnNotifications.removeAt(0);
      }

      await notificationBox.put("notifications", returnNotifications);
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<void> openChats(List<MainNotification> notifications) async {
    final box = await Hive.openBox('localNotifications');
    if (box.containsKey(0)) {
      await box.put(0, notifications);
    } else {
      box.add(notifications);
    }
    await box.close();
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
