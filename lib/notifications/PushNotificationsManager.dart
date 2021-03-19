import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/notifications/RateNotificationHandler.dart';
import 'package:pickapp/notifications/ReserveSeatsNotificationHandler.dart';

class PushNotificationsManager {
  static final int MAX_NOTIFICATIONS = 20;

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<String> init({context}) async {
    String token;
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: _foregroundMessageHandler,
        onBackgroundMessage: _backgroundMessageHandler,
        onLaunch: _onAppOpen,
        onResume: _onAppOpen,
      );
      _initialized = true;
    }
    return token;
  }

  //this function is used in AddCar2, Details, RegisterDriver and login Pages.
  static Future<String> requestToken() async {
    // For testing purposes print the Firebase Messaging token
    return _instance._firebaseMessaging.getToken();
  }

  Future<void> initNotifications() async {
    List<MainNotification> allNotifications = await Cache.getNotifications();
    App.notifications = allNotifications;
    print(allNotifications.length);

    List<MainNotification> allScheduledNotifications =
        await Cache.getScheduledNotifications();
    List<MainNotification> updatedScheduledNotifications =
        List<MainNotification>();
    updatedScheduledNotifications.addAll(allScheduledNotifications);

    bool isOneScheduledNotificationHandled = false;
    for (MainNotification n in allScheduledNotifications) {
      if (n.scheduleDate.isBefore(DateTime.now())) {
        isOneScheduledNotificationHandled = true;
        updatedScheduledNotifications.remove(n);
        allNotifications.add(n);
      }
    }

    if (isOneScheduledNotificationHandled) {
      await Cache.updateScheduledNotifications(updatedScheduledNotifications);
    }
    if (Cache.isNewNotification) {
      App.isNewNotificationNotifier.value = true;
    }

    _updateApp();

    if (isOneScheduledNotificationHandled) {
      await Cache.updateNotifications(allNotifications);
    }
  }
}

_updateApp() {
  App.updateUpcomingRide.value = true;
  App.refreshProfile.value = true;
  App.updateNotifications.value = true;
}

NotificationHandler notificationHandler;
//this will be invoked when app is terminated and user click the notification
Future<dynamic> _onAppOpen(Map<String, dynamic> message) async {
  print("you clicked on a notification");
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (App.isAppBuild) {
      timer.cancel();
      switch (message['data']['action']) {
        case "SEATS_RESERVED":
          print(message['data']);
          print(message['data']['rideId']);
          Ride ride = App.getRideFromObjectId(message['data']['rideId']);
          print(ride);
          NotificationHandler handler = ReserveSeatsNotificationHandler.from(ride);
          handler.display();
          break;
        case "RATE":
          print(2);
          break;
      }
    }
  });
  print("appTerminated: $message");
}

//this will be invoked when app in foreground
Future<dynamic> _foregroundMessageHandler(
    Map<String, dynamic> notification) async {
  print("app in foreground and notification received");
  Map<String, dynamic> data =
      new Map<String, dynamic>.from(notification["data"]);
  if (data["isCache"] != "true") return;

  bool isSchedule = data["isSchedule"] == "true";
  NotificationHandler handler =
      await _cacheNotification(data, isHandled: !isSchedule);
  if (!isSchedule) {
    App.notifications.add(handler.notification);
    _updateApp();
  }
}

//this will be invoked whenever a notification received and app is terminated or in background
Future<dynamic> _backgroundMessageHandler(
    Map<String, dynamic> notification) async {
  print("app is terminated or in background and notification received");
  Map<String, dynamic> data =
      new Map<String, dynamic>.from(notification["data"]);

  if (data["isCache"] != "true") return;

  await _cacheNotification(data);
}

Future<NotificationHandler> _cacheNotification(Map<String, dynamic> data,
    {bool isHandled = false}) async {
  await Cache.initializeHive();
  //todo
  //Cache.setIsNewNotification(true);
  App.isNewNotificationNotifier.value = true;
  MainNotification newNotification = MainNotification.fromMap(data);
  newNotification.object = json.decode(newNotification.object);
  NotificationHandler handler = _createNotificationHandler(newNotification);
  if (data["isSchedule"] != "true") {
    await Cache.addNotification(newNotification);
  } else {
    await Cache.addScheduledNotification(newNotification);
  }
  await handler.cache();
  return handler;
}

NotificationHandler _createNotificationHandler(
    MainNotification newNotification) {
  switch (newNotification.action) {
    case "SEATS_RESERVED":
      return ReserveSeatsNotificationHandler(newNotification);
      break;
    case "RATE":
      return RateNotificationHandler(newNotification);
      break;
  }
  return null;
}
