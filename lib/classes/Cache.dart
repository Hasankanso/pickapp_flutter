import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/CountryInformations.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/Message.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/dataObjects/UserStatistics.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/PushNotificationsManager.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;
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

  static Future<void> clearHiveCache() async {
    var rateB = await Hive.openBox<Rate>('rates');
    await rateB.clear();
    await rateB.close();
    await clearNotifications();
    var sNotfB = await Hive.openBox<MainNotification>('scheduledNotifications');
    await sNotfB.clear();
    await sNotfB.close();
    var userB = Hive.box("user");
    await userB.clear();
    await clearHiveChats();
    await removeAllScheduledNotification();
    await removeAllScheduledNotificationId();
  }

  static clearNotifications() async {
    var notfB = await Hive.openBox<MainNotification>('notifications');
    await notfB.clear();
    await notfB.close();
  }

  static Future<void> clearHiveChats() async {
    var chatB = await Hive.openBox<Chat>('chat');

    Iterable<Chat> iterable = chatB.values;
    for (Chat chat in iterable) {
      await _clearHiveChat(chat); // delete chat chunks.
    }

    await chatB.deleteFromDisk();
  }

  static Future<void> clearHiveChat(String key) async {
    Box<Chat> chatB = await Hive.openBox('chat');
    Chat chat = chatB.get(key);
    await _clearHiveChat(chat);
    await chatB.delete(key);
    await chatB.close();
  }

  static Future<void> _clearHiveChat(Chat chat) async {
    if (chat == null) return;

    for (int i = chat.lastChunkIndex; i >= 0; i--) {
      var messageBox = await Hive.openBox<Message>('${chat.id}.messages.$i');
      await messageBox.deleteFromDisk();
    }
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

  static Future<void> closeHiveBoxes() async {
    await Hive.close();
  }

  //will get chat correspondent to key, if not found and toStoreChat is provided, toStoreChat
  // will be cached instead, and returned
  static Future<Chat> getChat(String key, {Chat toStoreChat}) async {
    Box<Chat> box;

    if (Hive.isBoxOpen('chat')) {
      box = Hive.box<Chat>('chat');
    } else {
      box = await Hive.openBox<Chat>('chat');
    }

    Chat chat = box.get(key);

    if (chat == null && toStoreChat != null) {
      await box.put(key, toStoreChat);
      return toStoreChat;
    }

    return box.get(key);
  }

  static Future<List<Chat>> getChats() async {
    Box<Chat> box = await Hive.openBox<Chat>('chat');
    box = Hive.box('chat');

    var values = box.values;
    assert(values != null);

    List<Chat> chats = values.toList();

    if (chats == null) return [];

    return chats;
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

  static Future<List<Ride>> getRidesHistory() async {
    var rideHistoryBox;
    if (!Hive.isBoxOpen("ridesHistory")) {
      rideHistoryBox = await Hive.openBox("ridesHistory");
    } else {
      rideHistoryBox = Hive.box("ridesHistory");
    }
    List<Ride> returnedRides = [];

    if (rideHistoryBox.isOpen) {
      var rides = rideHistoryBox.get("ridesHistory");
      if (rides != null) {
        rides = rides.cast<Ride>();
        returnedRides = new List<Ride>.from(rides);
      }
      await rideHistoryBox.close();
    }
    return returnedRides;
  }

  static Future<bool> updateRideHistory(List<Ride> allHistoryRides) async {
    var rideBox;
    if (!Hive.isBoxOpen("ridesHistory")) {
      rideBox = await Hive.openBox("ridesHistory");
    } else {
      rideBox = Hive.box("ridesHistory");
    }
    if (rideBox.isOpen) {
      await rideBox.put("ridesHistory", allHistoryRides);
      await rideBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> updateRates(List<Rate> rates) async {
    var rideBox;
    if (!Hive.isBoxOpen("rates")) {
      rideBox = await Hive.openBox("rates");
    } else {
      rideBox = Hive.box("rates");
    }
    if (rideBox.isOpen) {
      await rideBox.put("rates", rates);
      await rideBox.close();
      return true;
    }
    return false;
  }

  static Future<bool> setRates(List<Rate> allRates) async {
    var rateBox;
    if (!Hive.isBoxOpen("rates")) {
      rateBox = await Hive.openBox("rates");
    } else {
      rateBox = Hive.box<Rate>("rates");
    }
    if (rateBox.isOpen) {
      await rateBox.put("rates", allRates);
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
      if (allNotf[i].id == notificationId) {
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
    var box = await Hive.openBox("appSettings");
    await box.put("IS_NEW_NOTIFICATION", value);
    await box.close();
    return true;
  }

  static Future<bool> getIsNewNotification() async {
    var box = await Hive.openBox("appSettings");
    bool isNewNotification = box.get("IS_NEW_NOTIFICATION");
    await box.close();
    if (isNewNotification == null) return false;
    return isNewNotification;
  }

  static Future<bool> setIsGetUpcomingRideRequest(bool value) async {
    var box = await Hive.openBox("appSettings");
    await box.put("IS_GET_UPCOMING_RIDE_REQUEST", value);
    await box.close();
    return true;
  }

  static Future<bool> getIsGetUpcomingRideRequest() async {
    var box = await Hive.openBox("appSettings");
    bool isNewNotification = box.get("IS_GET_UPCOMING_RIDE_REQUEST");
    await box.close();
    if (isNewNotification == null) return false;
    return isNewNotification;
  }

  static Future<bool> setIsGetRateRequest(bool value) async {
    var box = await Hive.openBox("appSettings");
    await box.put("IS_GET_RATE_REQUEST", value);
    await box.close();
    return true;
  }

  static Future<bool> getIsGetRateRequest() async {
    var box = await Hive.openBox("appSettings");
    bool isNewNotification = box.get("IS_GET_RATE_REQUEST");
    await box.close();
    if (isNewNotification == null) return false;
    return isNewNotification;
  }

  static Future<bool> setCountriesList(List<String> value) async {
    var box = await Hive.openBox("appSettings");
    await box.put("countriesList", value);
    await box.close();
    return true;
  }

  static Future<List<String>> getCountriesList() async {
    var box = await Hive.openBox("appSettings");
    List<String> countriesList = box.get("countriesList") as List<String>;
    await box.close();

    return countriesList;
  }

  static void setChat(Chat chat) async {
    Box<Chat> chatBox = await Hive.openBox('chat');
    await chatBox.put(chat.id, chat);
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
