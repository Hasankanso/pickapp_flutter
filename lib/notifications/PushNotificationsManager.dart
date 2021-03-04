import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/requests/GetMyUpcomingRides.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/UpdateDeviceToken.dart';

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
        onBackgroundMessage: _backgroundMessageHandler,
        onLaunch: onLaunch,
        onResume: onResume,
        onMessage: onMessage,
      );

      String token = await requestToken();
      print("FirebaseMessaging token: $token");
      if(App.isLoggedInNotifier.value){
        //if token is different, update it in backendless
        if(App.user.person.deviceToken != token){
          UpdateDeviceToken request = UpdateDeviceToken(token, App.user.person);
          request.send(updateTokenResponse);
        }
      }
      _initialized = true;
    }
  }

  //this function is used in AddCar2, Details, RegisterDriver and login Pages.
  static Future<String> requestToken() async {
    // For testing purposes print the Firebase Messaging token
    return _instance._firebaseMessaging.getToken();
  }

  updateTokenResponse(String token, int code, String p3) {
    if(code == 200){
      App.user.person.deviceToken = token;
      Cache.setUserCache(App.user);
    }
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
  Map<String, dynamic> data = message['data'];

  MainNotification newNotification = MainNotification.fromMap(data);
  bool isCache = data["isCache"] == "true";

  if (isCache) {
    Cache.addNotification(newNotification);
  }
  handleNotifications();
}

Future<void> handleNotifications() async {
  List<MainNotification> allNotifications = await Cache.getNotifications();
  List<String> actionsToHandle = new List<String>(allNotifications.length);

  for (MainNotification n in allNotifications) {
    if (!(n.isHandled || actionsToHandle.contains(n.action))) {
      actionsToHandle.add(n.action);
    }
  }
  print("handling");
  for (String action in actionsToHandle) {
    if (action == "SEATS_RESERVED") {
      Request<List<Ride>> ride = GetMyUpComingRides(App.user);
      ride.send(upComingsRideResponse);
      print("notification handled");
    } else {
      print(
          "following notification action is not handled: $action. Check PushNotificationsManager.dart");
    }
  }
}

//this will be invoked whenever a notification received and app is terminated or in background
Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  Map<String, dynamic> data = message['data'];

  MainNotification newNotification = MainNotification.fromMap(data);
  bool isCache = data["isCache"] == "true";

  if (isCache) {
    Cache.addNotification(newNotification);
  }

  print("appInBackground: $message");
}

void upComingsRideResponse(List<Ride> rides, int code, String status) {
  if (code == 200) {
    App.person.upcomingRides = rides;
    Cache.setUserCache(App.user);
    App.updateUpcomingRide.value = true;
  }
}
