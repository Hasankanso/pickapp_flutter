import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
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
    await setCountriesList([u.person.countryInformations.countryComponent]);
  }

  //will get chat correspondent to key, if not found and toStoreChat is provided, toStoreChat
  // will be cached instead, and returned
  static Future<Chat> getChat(String key, {Chat toStoreChat}) async {
    Box<Chat> box = await Hive.openBox('chat');

    Chat chat = box.get(key);

    if (chat == null && toStoreChat != null) {
      box.put(key, toStoreChat);
      return toStoreChat;
    }

    return box.get(key);
  }

  static Future<List<Chat>> getChats() async {
    Box<Chat> box = await Hive.openBox('chat');
    box = Hive.box('chat');

    var values = box.values;
    assert(values != null);

    List<Chat> chats = values.toList();

    if (chats == null) return [];

    return chats;
  }

  static Future<void> clearHiveCache() async {
    await Hive.openBox('rates');
    var rateB = Hive.box('rates');
    await rateB.clear();
    await rateB.close();
    await Hive.openBox('notifications');
    var notfB = Hive.box('notifications');
    await notfB.clear();
    await notfB.close();
    await Hive.openBox('scheduledNotifications');
    var sNotfB = Hive.box('scheduledNotifications');
    await sNotfB.clear();
    await sNotfB.close();
    var userB = Hive.box("user");
    await userB.clear();
  }

  static Future<void> clearHiveChats() async {
    Box<Chat> chatB = await Hive.openBox('chat');

    Iterable<Chat> iterable = chatB.values;
    for (Chat chat in iterable) {
      for (int i = chat.lastChunkIndex; i >= 0; i++) {
        var messageBox = await Hive.openBox<Message>('${chat.id}.messages.$i');
        await messageBox.clear();
        await messageBox.close();
      }
    }
    await chatB.clear();
    await chatB.close();
  }

  static Future<void> clearHiveChat(String key) async {
    Box<Chat> chatB = await Hive.openBox('chat');

    Chat chat = chatB.get(key);
    for (int i = chat.lastChunkIndex; i >= 0; i++) {
      var messageBox = await Hive.openBox<Message>('${chat.id}.messages.$i');
      await messageBox.clear();
      await messageBox.close();
    }
    await chatB.clear();
    await chatB.close();
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
      Hive.registerAdapter(ReservationAdapter());
      Hive.registerAdapter(ChatAdapter());
      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(MainNotificationAdapter());
      Hive.registerAdapter(UserStatisticsAdapter());
    }
  }

  static Future<List<Rate>> getRates() async {
    var rateBox;
    if (!Hive.isBoxOpen("rates")) {
      rateBox = await Hive.openBox("rates");
    } else {
      rateBox = Hive.box("rates");
    }
    List<Rate> returnRates = [];

    if (rateBox.isOpen) {
      var rates = rateBox.get("rates");
      if (rates != null) {
        rates = rates.cast<Rate>();
        returnRates = rates;
      }
      await rateBox.close();
    }
    return returnRates;
  }

  static Future<bool> addRate(Rate rate) async {
    var rateBox = await Hive.openBox("rates");
    List<Rate> returnRates = [];

    if (rateBox.isOpen) {
      var rates = rateBox.get("rates");
      if (rates != null) rates = rates.cast<Rate>();
      List<Rate> allRates = rates;
      if (allRates != null) returnRates.addAll(allRates);
      returnRates.add(rate);

      await rateBox.put("rates", returnRates);
      await rateBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> setRates(List<Rate> allRates) async {
    var rateBox;
    if (!Hive.isBoxOpen("rates")) {
      rateBox = await Hive.openBox("rates");
    } else {
      rateBox = Hive.box("rates");
    }
    if (rateBox.isOpen) {
      rateBox.put("rates", allRates);
      await rateBox.close();
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

  static Future<List<MainNotification>> getScheduledNotifications() async {
    var notificationBox;
    if (!Hive.isBoxOpen("scheduledNotifications")) {
      notificationBox = await Hive.openBox("scheduledNotifications");
    } else {
      notificationBox = Hive.box("scheduledNotifications");
    }
    List<MainNotification> returnNotifications = new List<MainNotification>();

    if (notificationBox.isOpen) {
      var scheduledNotifications = notificationBox.get("scheduledNotifications");
      if (scheduledNotifications != null) {
        scheduledNotifications = scheduledNotifications.cast<MainNotification>();
        returnNotifications = scheduledNotifications;
      }
      await notificationBox.close();
    }
    return returnNotifications;
  }

  static Future<bool> updateScheduledNotifications(List<MainNotification> allnotifications) async {
    var notificationBox;
    if (!Hive.isBoxOpen("scheduledNotifications")) {
      notificationBox = await Hive.openBox("scheduledNotifications");
    } else {
      notificationBox = Hive.box("scheduledNotifications");
    }
    if (notificationBox.isOpen) {
      notificationBox.put("scheduledNotifications", allnotifications);
      await notificationBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> addScheduledNotification(MainNotification notification) async {
    var notificationBox = await Hive.openBox("scheduledNotifications");
    List<MainNotification> returnNotifications = new List<MainNotification>();

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
    List<MainNotification> returnNotifications = new List<MainNotification>();

    if (notificationBox.isOpen) {
      var notfications = notificationBox.get("notifications");
      if (notfications != null) {
        notfications = notfications.cast<MainNotification>();
        returnNotifications.addAll(notfications);
      }
      await notificationBox.close();
    }
    return returnNotifications;
  }

  static Future<bool> updateNotifications(List<MainNotification> allnotifications) async {
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
    List<MainNotification> returnNotifications = [];

    if (notificationBox.isOpen) {
      var notfications = notificationBox.get("notifications");
      if (notfications != null) {
        notfications = notfications.cast<MainNotification>();
        returnNotifications.addAll(notfications);
      }
      returnNotifications.add(notification);
      while (returnNotifications.length > PushNotificationsManager.MAX_NOTIFICATIONS) {
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

  static bool get dateTimeRangePicker =>
      _prefs.getBool("isRangePicker") != null ? _prefs.getBool("isRangePicker") : false;

  static bool get disableAnimation =>
      _prefs.getBool("DISABLE_ANIMATION") != null ? _prefs.getBool("DISABLE_ANIMATION") : false;

  static bool get darkTheme =>
      _prefs.getBool("THEME_MODE") != null ? _prefs.getBool("THEME_MODE") : false;

  static Future<bool> setIsNewNotification(bool value) async {
    await Hive.openBox("appSettings");
    var box = Hive.box("appSettings");
    await box.put("IS_NEW_NOTIFICATION", value);
    await box.close();
    return true;
  }

  static Future<bool> getIsNewNotification() async {
    await Hive.openBox("appSettings");
    var box = Hive.box("appSettings");
    bool isNewNotification = box.get("IS_NEW_NOTIFICATION");
    await box.close();
    if (isNewNotification == null) return false;
    return isNewNotification;
  }

  static Future<bool> setCountriesList(List<String> value) async {
    await Hive.openBox("appSettings");
    var box = Hive.box("appSettings");
    await box.put("countriesList", value);
    await box.close();
    return true;
  }

  static Future<List<String>> getCountriesList() async {
    await Hive.openBox("appSettings");
    var box = Hive.box("appSettings");
    List<String> countriesList = box.get("countriesList") as List<String>;
    await box.close();
    return countriesList;
  }

  static void setChat(Chat chat) async {
    Box<Chat> chatBox = await Hive.openBox('chat');
    chatBox.put(chat.id, chat);
  }
}
