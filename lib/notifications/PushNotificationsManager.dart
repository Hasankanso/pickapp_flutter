import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/notifications/BroadcastAlertNotificationHandler.dart';
import 'package:just_miles/notifications/CancelReservationNotificationHandler.dart';
import 'package:just_miles/notifications/CancelRideNotificationHandler.dart';
import 'package:just_miles/notifications/EditReservationNotificationHandler.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/MessageNotificationHandler.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';
import 'package:just_miles/notifications/RateNotificationHandler.dart';
import 'package:just_miles/notifications/ReserveSeatsNotificationHandler.dart';
import 'package:just_miles/notifications/RideReminderNotificationHandler.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/requests/UpdateToken.dart';
import 'package:just_miles/requests/get_reservation.dart';

class PushNotificationsManager {
  static final int MAX_NOTIFICATIONS = 20;
  static bool tokenListenerRunning =
      false; // to make sure there's only one listener to token

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  bool _initialized = false;

  Future<String> init() async {
    String token;
    if (!_initialized) {
      onTokenChange();

      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

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
      if (App.user != null) {
        Request<String> request = UpdateNotificationToken(App.user, token);
        request.send(response);
      }
    }
    tokenListenerRunning = false;
  }

  response(String userStatus, int code, String message) async {
    if (code != HttpStatus.ok) {
      if (code == -1 || code == -2) {
        await App.logout();
      }
    }
  }

  //this will be invoked when app in foreground
  Future<dynamic> _foregroundMessageHandler(RemoteMessage message) async {
    print("app in foreground and notification received");
    NotificationHandler handler = await _cacheNotification(message);

    bool isSchedule = message.data["isSchedule"] == "true";
    if (!isSchedule) {
      List<MainNotification> notifications = await Cache.getNotifications();
      App.notifications = notifications;
      App.updateNotifications.value = !App.updateNotifications.value;
      handler.updateApp();
    }
  }

  //this will be invoked when app is in background or terminated and user click the notification
  Future<dynamic> _onAppOpen(RemoteMessage message) async {
    print("you clicked on a notification");
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (App.isAppBuild) {
        timer.cancel();
        NotificationHandler handler = await _createNotificationHandler(message);
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
    List<MainNotification> updatedScheduledNotifications = [];
    updatedScheduledNotifications.addAll(allScheduledNotifications);

    bool isOneScheduledNotificationHandled = false;
    for (MainNotification n in allScheduledNotifications) {
      if (n.scheduleDate.isBefore(DateTime.now())) {
        await Cache.setIsNewNotification(true);
        isOneScheduledNotificationHandled = true;
        updatedScheduledNotifications.remove(n);
        await Cache.removeScheduledNotificationId(n.dictId);
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

    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
    App.updateProfile.value = !App.updateProfile.value;
    App.updateNotifications.value = !App.updateNotifications.value;
    App.updateConversation.value = !App.updateConversation.value;

    if (isOneScheduledNotificationHandled) {
      await Cache.updateNotifications(allNotifications);
    }
  }

//this method is used in notification list page, to handle on item click event
  static NotificationHandler createNotificationHandler(
      MainNotification newNotification) {
    switch (newNotification.action) {
      case "SEATS_RESERVED":
        return ReserveSeatsNotificationHandler(newNotification);
        break;
      case "RESERVATION_CANCELED":
        return CancelReservationNotificationHandler(newNotification);
      case RateNotificationHandler.action:
        return RateNotificationHandler(newNotification);
        break;
      case "RIDE_CANCELED":
        return CancelRideNotificationHandler(newNotification);
        break;
      case "EDIT_RESERVATION":
        return EditReservationNotificationHandler(newNotification);
        break;
      case "ALERT_RECEIVED":
        return BroadcastAlertNotificationHandler(newNotification);
      case "RIDE_REMINDER":
        return RideReminderNotificationHandler(newNotification);
        break;
      case MessageNotificationHandler.action:
        return MessageNotificationHandler(newNotification);
    }
    print("this notification: " +
        newNotification.action +
        " has no handler yet.");
    return null;
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Cache.initializeHive();
  await Cache.init();
  await _cacheNotification(message);
  await Cache.closeHiveBoxes();
}

//this is called when app is in background or terminated.
Future<NotificationHandler> _cacheNotification(RemoteMessage message) async {
  bool isSchedule = message.data["isSchedule"] == "true";
  NotificationHandler handler = await _createNotificationHandler(message);

  if (handler == null) {
    // no handler for this notification
    return null;
  }

  if (isSchedule) {
    //this section is related to local notification.
    await Cache.addScheduledNotification(handler.notification);
  } else if (!handler.notification.dontCache) {
    // don't cache if we don't want to show it in the
    // home list
    await Cache.setIsNewNotification(true);
    App.isNewNotificationNotifier.value = true;
    await Cache.addNotification(handler.notification);
  }

  await handler.cache();
  return handler;
}

Future<Reservation> getReservation(MainNotification newNotification) async {
  List<dynamic> ids = (newNotification.object as List);
  String reservationId = ids[0];
  String rideId = ids[1];
  GetReservation request = GetReservation(reservationId, rideId);
  Reservation reserve = await request.send(null);
  return reserve;
}

Future<NotificationHandler> _createNotificationHandler(
    RemoteMessage message) async {
  MainNotification newNotification = MainNotification.fromJson(message.data);
  newNotification.sentTime = message.sentTime;
  if (newNotification.object != null) {
    newNotification.object = json.decode(newNotification.object);
    print(newNotification.object.toString());
  }
  switch (newNotification.action) {
    case "SEATS_RESERVED":
      if (newNotification.isMinimized) {
        newNotification.object = await getReservation(newNotification);
      }
      return ReserveSeatsNotificationHandler(newNotification);
      break;
    case "RESERVATION_CANCELED":
      return CancelReservationNotificationHandler(newNotification);
    case RateNotificationHandler.action:
      return RateNotificationHandler(newNotification);
      break;
    case "RIDE_CANCELED":
      return CancelRideNotificationHandler(newNotification);
      break;
    case "ALERT_RECEIVED":
      return BroadcastAlertNotificationHandler(newNotification);
    case "RIDE_REMINDER":
      return RideReminderNotificationHandler(newNotification);
      break;
    case "EDIT_RESERVATION":
      if (newNotification.isMinimized) {
        newNotification.object = await getReservation(newNotification);
      }
      return EditReservationNotificationHandler(newNotification);
      break;
    case MessageNotificationHandler.action:
      return MessageNotificationHandler(newNotification);
  }
  print(
      "this notification: " + newNotification.action + " has no handler yet.");
  return null;
}
