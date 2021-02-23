import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init({context}) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: onMessage,
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: onLaunch,
        onResume: onResume,
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}

Future<dynamic> onResume(Map<String, dynamic> message) async {
  App.isNewNotificationNotifier.value = true;
  App.navKey.currentState.pushNamed("/Notifications");
  print("appInBackground: $message");
}

Future<dynamic> onLaunch(Map<String, dynamic> message) async {
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (App.isAppBuild) {
      timer.cancel();
      App.isNewNotificationNotifier.value = true;
      App.navKey.currentState.pushNamed("/Notifications");
    }
  });
  print("appTerminated: $message");
}

Future<dynamic> onMessage(Map<String, dynamic> message) async {
  App.isNewNotificationNotifier.value = true;
  print("appInForeground: $message");
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("woslettttttttttttttttttttttttttttttttttttttttttttttttt");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  Cache.setDateTimeRangePicker(true);
  // Or do other work.
}
