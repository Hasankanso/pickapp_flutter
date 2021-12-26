import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';
import 'package:just_miles/notifications/PushNotificationsManager.dart';
import 'package:path_provider/path_provider.dart';
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
      NotificationHandler handler =
          PushNotificationsManager.createNotificationHandler(notification);
      if (handler != null) handler.display(context);
    }
  }

  static pushLocalNotification(MainNotification notification, String id) async {
    notification.id = await Cache.setScheduledNotificationId(id);
    notification.dictId = id;
    _pushLocalNotification(notification);
  }

  static _pushLocalNotification(MainNotification notification) async {
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
              'voomcar-channel',
              'Voomcar',
              'This channel is for Voomcar',
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
