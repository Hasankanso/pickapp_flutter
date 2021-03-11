import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/UserStatistics.dart';

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
  String _body;
  @HiveField(5)
  DateTime _scheduleDate;
  @HiveField(6)
  String _subtitle;
  @HiveField(7)
  String _imagePath;
  @HiveField(8)
  String _imageUrl;
  @HiveField(9)
  bool _isHandled;
  @HiveField(10)
  Object object;

  static List<MainNotification> notifications = List<MainNotification>();

  MainNotification(
      {String title,
      String body,
      int id,
      String objectId,
      String action,
      DateTime scheduleDate,
      String imagePath,
      String subtitle,
      String imageUrl,
      Object object}) {
    this.id = id;
    this.objectId = objectId;
    this.body = body;
    this.title = title;
    this.action = action;
    this.scheduleDate = scheduleDate;
    this.imagePath = imagePath;
    this.subtitle = subtitle;
    this.imageUrl = imageUrl;
    this._isHandled = false;
    this.object = object;
  }

  MainNotification.fromJson(Map<String, dynamic> json)
      : _objectId = json["objectId"],
        _action = json["action"],
        _title = json["title"],
        _subtitle = json["subtitle"],
        _body = json["body"],
        _imagePath = json["imagePath"],
        _imageUrl = json["imageUrl"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'objectId': this.objectId,
        'action': this.action,
        'title': this.title,
        'body': this.body,
        'subtitle': this.subtitle,
        'imagePath': this.imagePath,
        'imageUrl': this.imageUrl
      };

  static MainNotification fromMap(Map<String, dynamic> args) {
    return MainNotification(
        action: args["action"],
        title: args["title"],
        body: args["body"],
        subtitle: args["subtitle"],
        object: args["object"]);
  }

  Future<void> handle() async {
    switch (_action) {
      case "SEATS_RESERVED":
        //notifier true;
        //change on cache...
        break;
      case "RATE":
        await _handleRate();
        break;
    }
    _isHandled = true;
  }

  _handleRate() async {
    Rate rate = ((this.object as List)[0] as Rate);
    UserStatistics statistics = ((this.object as List)[1] as UserStatistics);
    await Cache.addRate(rate);
    App.user.person.statistics = statistics;
    await Cache.setUser(App.user);
    App.refreshProfile.value = true;
  }

  set imageUrl(String value) {
    _imageUrl = value;
  }

  bool get isHandled => _isHandled;

  String get imageUrl => _imageUrl;

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

  get body => _body;

  set body(value) {
    _body = value;
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

  @override
  String toString() {
    return 'MainNotification{_id: $_id, _objectId: $_objectId, _action: $_action, _title: $_title, _body: $_body, _scheduleDate: $_scheduleDate, _subtitle: $_subtitle, _imagePath: $_imagePath, _imageUrl: $_imageUrl}';
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

}
