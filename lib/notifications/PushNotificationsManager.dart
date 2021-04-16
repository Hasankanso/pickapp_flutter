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

  bool _initialized = false;

  Future<String> init(context) async {
    String token;
    if (!_initialized) {
      onTokenChange();
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);

      FirebaseMessaging.onMessageOpenedApp.listen(_onAppOpen);

      _initialized = true;
    }
    return token;
  }

  void onTokenChange() async {
    await for (String token in FirebaseMessaging.instance.onTokenRefresh) {
      print("new token");
      print(token);
    }
  }

  //this will be invoked when app in foreground
  Future<dynamic> _foregroundMessageHandler(RemoteMessage message) async {
    print("app in foreground and notification received");
    //        RemoteNotification notification = message.notification;
    //         AndroidNotification android = message.notification?.android;
    Map<String, dynamic> data = new Map<String, dynamic>.from(message.data);
    bool isSchedule = data["isSchedule"] == "true";
    NotificationHandler handler =
        await _cacheNotification(data, isSchedule: isSchedule);

    if (!isSchedule) {
      App.notifications.add(handler.notification);
      _updateApp();
    }
  }

  //todo this will be invoked when app is terminated and user click the notification
  Future<dynamic> _onAppOpen(RemoteMessage message) async {
    print("you clicked on a notification");
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (App.isAppBuild) {
        timer.cancel();
        switch (message.data['action']) {
          case "SEATS_RESERVED":
            print(message.data);
            print(message.data['rideId']);
            Ride ride = App.getRideFromObjectId(message.data['rideId']);
            print(ride);
            NotificationHandler handler =
                ReserveSeatsNotificationHandler.from(ride);
            handler.display();
            break;
          case "RATE":
            break;
        }
      }
    });
    print("appTerminated: $message");
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
        await Cache.setIsNewNotification(true);
        isOneScheduledNotificationHandled = true;
        updatedScheduledNotifications.remove(n);
        allNotifications.add(n);
      }
    }

    if (isOneScheduledNotificationHandled) {
      await Cache.updateScheduledNotifications(updatedScheduledNotifications);
    }
    if (isOneScheduledNotificationHandled ||
        await Cache.getIsNewNotification()) {
      App.isNewNotificationNotifier.value = true;
    }

    _updateApp();

    if (isOneScheduledNotificationHandled) {
      await Cache.updateNotifications(allNotifications);
    }
  }

  _updateApp() {
    App.updateUpcomingRide.value = true;
    App.refreshProfile.value = true;
    App.updateNotifications.value = true;
  }
}

//this will be invoked whenever a notification received and app is terminated or in background
Future<dynamic> backgroundMessageHandler(RemoteMessage message) async {
  print("app is terminated or in background and notification received");
  Map<String, dynamic> data = new Map<String, dynamic>.from(message.data);

  bool isSchedule = data["isSchedule"] == "true";
  await _cacheNotification(data, isSchedule: isSchedule);
}

Future<NotificationHandler> _cacheNotification(Map<String, dynamic> data,
    {bool isSchedule = false}) async {
  await Cache.initializeHive();
  await Cache.init();
  MainNotification newNotification = MainNotification.fromMap(data);
  print(newNotification.object);
  newNotification.object = json.decode(newNotification.object);
  NotificationHandler handler = _createNotificationHandler(newNotification);
  if (!isSchedule) {
    await Cache.setIsNewNotification(true);
    App.isNewNotificationNotifier.value = true;
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
