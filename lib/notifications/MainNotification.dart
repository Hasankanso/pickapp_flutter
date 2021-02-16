import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//import 'package:timezone/data/latest.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
//import 'package:pickapp/classes/App.dart';
// import 'package:pickapp/classes/Cache.dart';

part 'MainNotification.g.dart';

@HiveType(typeId: 12)
class MainNotification {
  @HiveField(0)
  int _id;
  @HiveField(1)
  String _objectId;
  @HiveField(2)
  String _action;
  @HiveField(3)
  String _title;
  @HiveField(4)
  String _description;
  @HiveField(5)
  DateTime _scheduleDate;
  @HiveField(6)
  String _subtitle;
  @HiveField(7)
  String _imagePath;

  MainNotification(
      {String title,
      String description,
      int id,
      String objectId,
      String action,
      DateTime scheduleDate,
      String imagePath,
      String subtitle}) {
    this.id = id;
    this.objectId = objectId;
    this.description = description;
    this.title = title;
    this.action = action;
    this.scheduleDate = scheduleDate;
    this.imagePath = imagePath;
    this.subtitle = subtitle;
  }

  MainNotification.fromJson(Map<String, dynamic> json)
      : _objectId = json["objectId"],
        _action = json["action"],
        _title = json["title"],
        _subtitle = json["subtitle"],
        _description = json["description"],
        _imagePath = json["imagePath"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'objectId': this.objectId,
        'action': this.action,
        'title': this.title,
        'description': this.description,
        'subtitle': this.subtitle,
        'imagePath': this.imagePath
      };

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  String get objectId => _objectId;

  set objectId(String value) {
    _objectId = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  get action => _action;

  set action(value) {
    _action = value;
  }

  get id => _id;

  set id(value) {
    _id = value;
  }

  String get subtitle => _subtitle;

  set subtitle(String value) {
    _subtitle = value;
  }

  DateTime get scheduleDate => _scheduleDate;

  set scheduleDate(DateTime value) {
    _scheduleDate = value;
  }

/*
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

  static _localeNotificationCallBack(String payload, context) {
    if (payload != null) {
      MainNotification notification =
          MainNotification.fromJson(json.decode(payload));
      switch (notification.action) {
        case 'upcomingRide':
          Ride ride = App.getRideFromObjectId(notification.objectId);
          Navigator.pushNamed(context, "/RideDetails2", arguments: ride);
          break;
        default:
          //for default notification
          break;
      }
    }
  }

  static pushLocalNotification(MainNotification notification) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidImage;
    var iosImage;

    if (notification.imagePath != null) {
      //todo put image file name
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/test';
      final Response response = await get("url");
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
        notification.description,
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
    if(App.notifications!=null){
      App.notifications.add(notification);
    } else {
      App.notifications=[notification];
    }
    await Cache.setNotifications(App.notifications);
  }

  static deleteLocalNotification(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static deleteAllLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }*/
  static void onMessage(Map<String, dynamic> args, context) {
    print("lllllllll");
    print(args.values);
    print("oks");
    print(ModalRoute.of(context).settings.name);
    Navigator.pushNamed(context, "/Notifications");
    print(11);
  }
}
