import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/MyRidesTile.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationManager {
  static initializeLocaleNotification(context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(body),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text(Lang.getString(context, "Dismiss")),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text(Lang.getString(context, "Show")),
                      onPressed: () async {
                        _localeNotificationCallBack(payload, context);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            });
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) =>
          _localeNotificationCallBack(payload, context),
    );
  }

  static _localeNotificationCallBack(String payload, context) async {
    if (payload != null) {
      MainNotification notification =
          MainNotification.fromJson(json.decode(payload));
      await Cache.removeScheduledNotificationId(notification.id);
      switch (notification.action) {
        case 'RATE':
          Navigator.pushNamed(context, "/ReviewsPageList");
          break;
        case 'RIDE_REMINDER':
          List<Object> objects = notification.object as List;

          Ride r = App.person.getUpcomingRideFromId(objects[0] as String);

          if ((objects[1] as bool) == true) {
            Navigator.of(context).pushNamed("/RideDetails", arguments: [
              r,
              Lang.getString(context, "Edit_Reservation"),
              (ride) {
                MyRidesTile.seatsLuggagePopUp(context, r);
              },
              false
            ]);
          } else {
            Navigator.of(context).pushNamed("/UpcomingRideDetails", arguments: [
              r,
              Lang.getString(context, "Edit_Ride"),
              (r) {
                return Navigator.pushNamed(context, "/EditRide", arguments: r);
              }
            ]);
          }
          break;
        default:
          //for default notification
          break;
      }
    }
  }

  static pushLocalNotification(MainNotification notification, String id) async {
    notification.id = await Cache.setScheduledNotificationId(id);
    _pushLocalNotification(notification);
  }

  static _pushLocalNotification(MainNotification notification) async {
    print("a notification has been scheduled");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidImage;
    var iosImage;

    if (notification.imagePath != null) {
      //todo put image file name
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/test';
      final Response response = await get(Uri(host: "url"));
      final file = File(imagePath);
      await file.writeAsBytes(response.bodyBytes);

      androidImage = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
      );

      iosImage = <IOSNotificationAttachment>[
        IOSNotificationAttachment(imagePath)
      ];
    }

    String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        tz.TZDateTime(
            tz.local,
            notification.scheduleDate.year,
            notification.scheduleDate.month,
            notification.scheduleDate.day,
            notification.scheduleDate.hour,
            notification.scheduleDate.minute,
            notification.scheduleDate.second,
            notification.scheduleDate.millisecond),
        NotificationDetails(
            android: AndroidNotificationDetails(
              'pickapp-channel',
              'PickApp',
              'This channel is for PickApp',
              importance: Importance.max,
              priority: Priority.high,
              color: Styles.primaryColor(),
              channelShowBadge: true,
              enableVibration: true,
              ledColor: Styles.primaryColor(),
              showWhen: true,
              ledOnMs: 1000,
              visibility: NotificationVisibility.public,
              ledOffMs: 500,
              autoCancel: true,
              styleInformation: androidImage,
              subText: notification.subtitle,
            ),
            iOS: IOSNotificationDetails(
                presentBadge: true,
                presentSound: true,
                subtitle: notification.subtitle,
                attachments: iosImage)),
        androidAllowWhileIdle: true,
        payload: json.encode(notification.toJson()),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    await Cache.addScheduledNotification(notification);
  }

  static Future<PendingNotificationRequest> getLocalNotification(
      String id) async {
    List<PendingNotificationRequest> notis =
        await FlutterLocalNotificationsPlugin().pendingNotificationRequests();

    int integerId = await Cache.getScheduledNotificationId(id);
    return notis[integerId];
  }

  static Future<bool> cancelLocalNotification(String objectId) async {
    int id = await Cache.getScheduledNotificationId(objectId);
    if (id != null) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.cancel(id);
      if (id != null) {
        await Cache.removeScheduledNotification(id);
        await Cache.removeScheduledNotificationId(objectId);
        return true;
      }
    }
    return false;
  }

  static cancelAllLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
