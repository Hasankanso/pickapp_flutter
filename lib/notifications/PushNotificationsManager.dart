import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickapp/classes/App.dart';

class PushNotificationsManager {
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
        onBackgroundMessage: _backgroundMessageHandler,
        onLaunch: onLaunch,
        onResume: onResume,
        onMessage: onMessage,
      );

      token = await _firebaseMessaging.getToken();
      _initialized = true;
    }
    return token;
  }
}

//this will be invoked when app is terminated and user click the notification
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

//this will be invoked when app in background and user click the notification
Future<dynamic> onResume(Map<String, dynamic> message) async {
  App.isNewNotificationNotifier.value = true;
  App.navKey.currentState.pushNamed("/Notifications");
  print("appInBackground: $message");
}

//this will be invoked when app in foreground
Future<dynamic> onMessage(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    bool isCache = data["isCache"] == "true";
    if (isCache) {
      App.isNewNotificationNotifier.value = true;
      print("appInForeground: $message");
    }
  }
}

//this will be invoked whenever a notification received and app is terminated or in background
Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    bool isCache = data["isCache"] == "true";
    if (isCache) {
      App.isNewNotificationNotifier.value = true;
      print("appInBackground: $message");
    }
  }
}
