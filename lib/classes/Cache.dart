import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/dataObjects/UserStatistics.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/PushNotificationsManager.dart';
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

  static setUser(User u) async {
    final userBox = Hive.box("user");
    u.person.rates = null;

    await userBox.put(0, u);
  }

  static Future<Chat> getChat(String key) async {
    Box box;
    if (!Hive.isBoxOpen('chat')) {
      box = await Hive.openBox('chat');
    }
    box = Hive.box('chat');
    return (box.get(key) as Chat);
  }

  static Future<void> clearHiveCache() async {
    await Hive.openBox('chat');
    var chatB = Hive.box('chat');
    await chatB.clear();
    chatB.close();
    await Hive.openBox('rates');
    var rateB = Hive.box('rates');
    await rateB.clear();
    rateB.close();
    await Hive.openBox('notifications');
    var notfB = Hive.box('notifications');
    await notfB.clear();
    notfB.close();
    var userB = Hive.box("user");
    userB.clear();
  }

  static Future<void> initializeHive() async {
    final path = await PathProvider.getApplicationDocumentsDirectory();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.init(path.path);
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(PersonAdapter());
      Hive.registerAdapter(DriverAdapter());
      Hive.registerAdapter(CountryInformationsAdapter());
      Hive.registerAdapter(CarAdapter());
      Hive.registerAdapter(MainLocationAdapter());
      Hive.registerAdapter(RideAdapter());
      Hive.registerAdapter(RateAdapter());
      Hive.registerAdapter(PassengerAdapter());
      Hive.registerAdapter(ChatAdapter());
      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(MainNotificationAdapter());
      Hive.registerAdapter(UserStatisticsAdapter());
    }
  }

  static Future<List<Rate>> getRates() async {
    List<Rate> returnRates = new List<Rate>();

    Box ratesBox;
    await Hive.openBox("rates");
    ratesBox = Hive.box("rates");
    if (ratesBox.length != 0) {
      returnRates = ratesBox.getAt(0).cast<List<Rate>>();
      ratesBox.close();
      return returnRates;
    }
    ratesBox.close();
    return returnRates;
  }

  static Future<bool> addRate(Rate rate) async {
    var rateBox = await Hive.openBox("rates");
    List<Rate> returnRates = new List<Rate>();

    if (rateBox.isOpen) {
      var rates = rateBox.get("rates");
      if (rates != null) {
        rates = rates as List<Rate>;
        returnRates = rates;
      }

      returnRates.add(rate);

      await rateBox.put("rates", returnRates);
      rateBox.close();
      return true;
    }
    return false;
  }

  static Future<User> getUser() async {
    User user;
    await Hive.openBox('user');

    final box = Hive.box("user");
    if (box.length != 0) {
      user = box.getAt(0) as User;
    }
    return user;
  }

  static Future<List<MainNotification>> getNotifications() async {
    var notificationBox;
    if (!Hive.isBoxOpen("notifications")) {
      notificationBox = await Hive.openBox("notifications");
    } else {
      notificationBox = Hive.box("notifications");
    }
    List<MainNotification> returnNotifications = new List<MainNotification>();

    if (notificationBox.isOpen) {
      var notfication = notificationBox.get("notifications");
      if (notfication != null)
        notfication = notfication.cast<MainNotification>();
      List<MainNotification> allNotifications = notfication;
      if (allNotifications != null) returnNotifications = allNotifications;
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
      notificationBox.put("notifications", allnotifications);
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> addNotification(MainNotification notification) async {
    var notificationBox = await Hive.openBox("notifications");
    List<MainNotification> returnNotifications = new List<MainNotification>();

    if (notificationBox.isOpen) {
      var notfication = notificationBox.get("notifications");
      if (notfication != null)
        notfication = notfication.cast<MainNotification>();
      List<MainNotification> allNotifications = notfication;
      if (allNotifications != null) returnNotifications = allNotifications;
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
    await Hive.openBox('localNotifications');
    final box = Hive.box("localNotifications");
    if (box.containsKey(0)) {
      await box.put(0, notifications);
    } else {
      box.add(notifications);
    }
    box.close();
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
}
