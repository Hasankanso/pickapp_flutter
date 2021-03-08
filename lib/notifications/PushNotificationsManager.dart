import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/MainNotification.dart';

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
        onLaunch: onAppOpen,
        onResume: onAppOpen,

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

   Future<void> handleNotifications() async {
    List<MainNotification> allNotifications = await Cache.getNotifications();
    App.notifications = allNotifications;
    print(allNotifications.length);
    bool isOneNotificationHandled = false;
    for (MainNotification n in allNotifications) {
      if (!n.isHandled) {
        isOneNotificationHandled = true;
        App.isNewNotificationNotifier.value = true;
        n.handle();
      }
    }

    if (isOneNotificationHandled) {
      await Cache.updateNotifications(allNotifications);
    }
  }
}

//this will be invoked when app is terminated and user click the notification
Future<dynamic> onAppOpen(Map<String, dynamic> message) async {
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (App.isAppBuild) {
      timer.cancel();
      switch (message['data']['action']) {
        case "SEATS_RESERVED":
          Ride ride = App.getRideFromObjectId(message['data']['id']);
          App.navKey.currentState.pushNamed("/RideView", arguments: ride);
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
Future<dynamic> _foregroundMessageHandler(Map<String, dynamic> notification) async {
  print(notification);

  Map<String, dynamic> data =
      new Map<String, dynamic>.from(notification["data"]);


    MainNotification newNotification = MainNotification.fromMap(data);
    newNotification.handle();
    Cache.addNotification(newNotification);
}

//this will be invoked whenever a notification received and app is terminated or in background
Future<dynamic> _backgroundMessageHandler(
    Map<String, dynamic> notification) async {
  print("app is terminated or in background and notification received");

  Map<String, dynamic> data =
      new Map<String, dynamic>.from(notification["data"]);

    MainNotification newNotification = MainNotification.fromMap(data);

    await Cache.initializeHive();
    Cache.addNotification(newNotification);
}
