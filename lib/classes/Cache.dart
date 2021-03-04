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
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/dataObjects/UserStatistics.dart';
import 'package:pickapp/notifications/MainNotification.dart';
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

  static setUserCache(User u) async {
    final userBox = Hive.box("user");
    User cacheUser = u;

    Person cachePerson = u.person;
    cachePerson.rates = null;

    cacheUser.person = cachePerson;

    var regions;
    if (u.driver != null && u.driver.cars != null && u.driver.cars.isNotEmpty) {
      regions = u.driver.regions;
      var d = u.driver;
      cacheUser.driver = Driver(id: d.id, cars: d.cars, updated: d.updated);
    }

    await userBox.put(0, cacheUser);

    await Hive.openBox('regions');
    final regionsBox = Hive.box("regions");

    if (regions != null && u.driver.cars != null && u.driver.cars.isNotEmpty) {
      await regionsBox.put(0, regions);
    } else if (u.driver.cars == null || u.driver.cars.isEmpty) {
      await regionsBox.clear();
    }
    regionsBox.close();
    //todo
    //Inbox.subscribeToChannel();
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
    await Hive.openBox("regions");
    var regionB = Hive.box("regions");
    await regionB.clear();
    regionB.close();
    var userB = Hive.box("user");
    userB.clear();
  }

  static Future<void> initializeHive() async {
    final path = await PathProvider.getApplicationDocumentsDirectory();
    Hive.init(path.path);
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(PersonAdapter());
    Hive.registerAdapter(DriverAdapter());
    Hive.registerAdapter(CountryInformationsAdapter());
    Hive.registerAdapter(CarAdapter());
    Hive.registerAdapter(MainLocationAdapter());
    Hive.registerAdapter(RideAdapter());
    Hive.registerAdapter(PassengerAdapter());
    Hive.registerAdapter(ChatAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(MainNotificationAdapter());
    Hive.registerAdapter(UserStatisticsAdapter());
  }

  static Future<List<MainLocation>> getRegions() async {
    Box regionsBox;

    await Hive.openBox("regions");
    regionsBox = Hive.box("regions");
    if (regionsBox.length != 0) {
      var list = regionsBox.getAt(0).cast<MainLocation>();
      regionsBox.close();
      return list;
    }
    regionsBox.close();
    return null;
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
    Box<List<MainNotification>> notificationBox =
        await Hive.openBox("notifications");
    List<MainNotification> returnNotifications = new List<MainNotification>();

    if (notificationBox.isOpen) {
      List<MainNotification> allNotifications =
          notificationBox.get("notifications");
      if (allNotifications != null) returnNotifications = allNotifications;
      notificationBox.close();
    }
    return returnNotifications;
  }

  static Future<bool> addNotification(MainNotification notification) async {
    Box<List<MainNotification>> notificationBox =
        await Hive.openBox("notifications");
    List<MainNotification> returnNotifications = new List<MainNotification>();

    if (notificationBox.isOpen) {
      List<MainNotification> allNotifications =
          notificationBox.get("notifications");
      if (allNotifications != null) returnNotifications = allNotifications;

      setNotifications(returnNotifications);
      return true;
    }
    return false;
  }

  static Future<void> setNotifications(
      List<MainNotification> notifications) async {
    Box<List<MainNotification>> notificationBox =
        await Hive.openBox("notifications");
    if (notificationBox.isOpen) {
      await notificationBox.put("notifications", notifications);
    }
    notificationBox.close();
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
