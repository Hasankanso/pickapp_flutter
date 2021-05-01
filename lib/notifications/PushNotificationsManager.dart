import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/notifications/BroadcastAlertNotificationHandler.dart';
import 'package:pickapp/notifications/DeleteRideNotificationHandler.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/MessageNotificationHandler.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/notifications/RateNotificationHandler.dart';
import 'package:pickapp/notifications/ReserveSeatsNotificationHandler.dart';

class PushNotificationsManager {
  static final int MAX_NOTIFICATIONS = 20;
  static bool tokenListenerRunning =
      false; // to make sure there's only one listener to token

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  bool _initialized = false;

  Future<String> init(context) async {
    String token;
    if (!_initialized) {
      onTokenChange();
      FirebaseMessaging.onBackgroundMessage(cacheNotification);

      FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);

      FirebaseMessaging.onMessageOpenedApp.listen(_onAppOpen);

      _initialized = true;
    }
    return token;
  }

  void onTokenChange() async {
    if (tokenListenerRunning) {
      return;
    } // to make sure there's only one listener to token
    // (no memory leak)

    tokenListenerRunning = true;
    await for (String token in FirebaseMessaging.instance.onTokenRefresh) {
      print("new token");
      print(token);
    }
    tokenListenerRunning = false;
  }

  //this will be invoked when app in foreground
  Future<dynamic> _foregroundMessageHandler(RemoteMessage message) async {
    print("app in foreground and notification received");
    //        RemoteNotification notification = message.notification;
    //         AndroidNotification android = message.notification?.android;
    NotificationHandler handler =
        await cacheNotification(message); // do we want to initialize
    // hive and notificationManager in forground?

    bool isSchedule = message.data["isSchedule"] == "true";
    if (!isSchedule) {
      App.notifications.add(handler.notification);
      handler.updateApp();
      App.updateNotifications.value = true;
    }
  }

  //this will be invoked when app is in background or terminated and user click the notification
  Future<dynamic> _onAppOpen(RemoteMessage message) async {
    print("you clicked on a notification");
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (App.isAppBuild) {
        timer.cancel();
        NotificationHandler handler = _createNotificationHandler(message);
        if (handler != null) {
          handler.display(App.navKey.currentState.context);
        }
      }
    });
    print("appTerminated: $message");
  }

  Future<void> onResume() async {
    App.user = await Cache.getUser();
    await initNotifications();
  }

  Future<void> initNotifications() async {
    List<MainNotification> allNotifications = await Cache.getNotifications();

    App.notifications = allNotifications;

    List<MainNotification> allScheduledNotifications =
        await Cache.getScheduledNotifications();
    List<MainNotification> updatedScheduledNotifications = <MainNotification>[];
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

    App.updateUpcomingRide.value = true;
    App.updateProfile.value = true;
    App.updateNotifications.value = true;
    App.updateConversation.value = true;

    if (isOneScheduledNotificationHandled) {
      await Cache.updateNotifications(allNotifications);
    }
  }
}

//this is called when app is in background or terminated.
Future<NotificationHandler> cacheNotification(RemoteMessage message) async {
  await Cache.initializeHive();
  await Cache.init();

  bool isSchedule = message.data["isSchedule"] == "true";
  NotificationHandler handler = _createNotificationHandler(message);

  if (handler == null) {
    return null;
  }

  if (isSchedule) {
    //this section is related to local notification.
    await Cache.addScheduledNotification(handler.notification);
  } else {
    await Cache.setIsNewNotification(true);
    App.isNewNotificationNotifier.value = true;
    await Cache.addNotification(handler.notification);
  }

  await handler.cache();
  return handler;
}

NotificationHandler _createNotificationHandler(RemoteMessage message) {
  MainNotification newNotification = MainNotification.fromJson(message.data);
  newNotification.sentTime = message.sentTime;
  newNotification.object = json.decode(newNotification.object);

  switch (newNotification.action) {
    case "SEATS_RESERVED":
      return ReserveSeatsNotificationHandler(newNotification);
      break;
    case "RATE":
      return RateNotificationHandler(newNotification);
      break;
    case "RIDE_DELETED":
      return DeleteRideNotificationHandler(newNotification);
      break;
    case "ALERT_RECEIVED":
      return BroadcastAlertNotificationHandler(newNotification);
    case MessageNotificationHandler.action:
      return MessageNotificationHandler(newNotification);
  }
  print(
      "this notification: " + newNotification.action + " has no handler yet.");
  return null;
}
