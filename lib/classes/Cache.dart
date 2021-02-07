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

    if (userBox.containsKey(0)) {
      await userBox.put(0, cacheUser);
    } else {
      userBox.add(cacheUser);
    }

    await Hive.openBox('regions');
    final regionsBox = Hive.box("regions");

    if (regions != null && u.driver.cars != null && u.driver.cars.isNotEmpty) {
      if (regionsBox.containsKey(0)) {
        await regionsBox.put(0, regions);
      } else {
        regionsBox.add(regions);
      }
    } else {
      await regionsBox.clear();
    }
    regionsBox.close();

    Inbox.subscribeToChannel();
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
    List<MainNotification> notifications;
    await Hive.openBox('localNotifications');
    final notificationsBox = Hive.box("localNotifications");
    if (notificationsBox.length != 0) {
      notifications = notificationsBox.getAt(0).cast<MainNotification>();
    }
    notificationsBox.close();
    return notifications;
  }

  static Future<void> setNotifications(
      List<MainNotification> notifications) async {
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

  static setDisableAnimation(bool value){
    _prefs.setBool("DISABLE_ANIMATION", value);
  }

  static setConditionAccepted(bool value) {
    _prefs.setBool("TERM_CONDITIONS", value);
  }


  static String get locale => _prefs.getString("LANG_CODE");

  static bool get conditionAccepted => _prefs.getBool("TERM_CONDITIONS") != null
      ? _prefs.getBool("TERM_CONDITIONS") : false;

  static bool get dateTimeRangePicker => _prefs.getBool("isRangePicker") != null
      ? _prefs.getBool("isRangePicker") : false;

  static bool get disableAnimation => _prefs.getBool("DISABLE_ANIMATION") != null
      ? _prefs.getBool("DISABLE_ANIMATION") : false;

  static bool get darkTheme => _prefs.getBool("THEME_MODE") != null
      ? _prefs.getBool("THEME_MODE") : false;
}
