import 'dart:convert';
import 'dart:io' show File, Platform;

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart' as p;
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/main.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'Localizations.dart';

class App {
  static MyAppState _state;
  static final String appName = "PickApp";
  static TextStyle textStyling = new TextStyle(fontSize: 30);
  static final String googleKey = "AIzaSyCjEHxPme3OLzDwsnkA8Tl5QF8_B9f70U0";
  static String dateFormat = 'dd/MM/yyyy hh:mm a';
  static String hourFormat = 'hh:mm a';
  static String birthdayFormat = 'dd/MM/yyyy';
  static String countryCode =
      "lb"; //todo person.countryInformations.countryComponent;
  static User _user;
  static bool _isLoggedIn = false;
  static ValueNotifier<bool> isLoggedInNotifier;
  static ValueNotifier<bool> isDriverNotifier;
  static List<String> _countriesInformationsNames = ["Deutschland", "لبنان"];
  static List<String> _countriesInformationsCodes = ["49", "961"];
  static dynamic maxPriceFilter;
  static dynamic minPriceFilter;
  static dynamic stepPriceFilter;
  static Channel inboxChannel;
  static List<MainNotification> notifications = List<MainNotification>();

  static ValueNotifier<bool> newMessageInbox = ValueNotifier(false);
  static Map<String, CountryInformations> _countriesInformations =
      <String, CountryInformations>{
    'Deutschland': CountryInformations(
        name: "Deutschland",
        id: "CAE25E4F-A78C-12BB-FF38-92A6EC9D4F00",
        digits: 11,
        code: "49",
        drivingAge: 18),
    'لبنان': CountryInformations(
        name: "لبنان",
        id: "F85258BF-63A7-F939-FF31-C78BB1837300",
        digits: 8,
        code: "961",
        drivingAge: 18),
  };

  static Locale locale;

  static void changeLanguage(String lang) async {
    await Cache.setLocale(lang);
    _state.setLocale(Locale(lang));
  }


  static bool checkIfDriver(Ride ride) {
    if (ride.user.driver != null) {
      if (ride.user.driver == App.user.driver)
        return true;
      else
        return false;
    } else
      return false;
  }

  static void forceDarkTheme(bool value) async {
    Cache.setTheme(value);

    if (value) {
      _state.setTheme(ThemeMode.dark);
    } else {
      _state.setTheme(ThemeMode.system);
    }
  }

  static void init(MyAppState state) {
    _state = state;
  }

  //called in Home class
  static void setContext(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    ScreenUtil.init(context,
        designSize: Size(360, 640),
        designStatusBarHeight: 24,
        allowFontScaling: true);
    Styles.setFontSizes(
        subValueFontSize: ScreenUtil().setSp(12.24),
        fontSize: ScreenUtil().setSp(15),
        titleFontSize: ScreenUtil().setSp(17.64));
    Styles.setIconSizes(
        largeSize: ScreenUtil().setSp(27),
        mediumSize: ScreenUtil().setSp(21),
        smallSize: ScreenUtil().setSp(14.5));
  }

  static void changeScreenReferenceSize(double width, double height) {
    WidgetsFlutterBinding.ensureInitialized();
    ScreenUtil.re_init(width, height);
    Styles.setFontSizes(
        subValueFontSize: ScreenUtil().setSp(12.24),
        fontSize: ScreenUtil().setSp(15),
        titleFontSize: ScreenUtil().setSp(17.64));
    Styles.setIconSizes(
        largeSize: ScreenUtil().setSp(27),
        mediumSize: ScreenUtil().setSp(21),
        smallSize: ScreenUtil().setSp(14.5));
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIphone() {
    return Platform.isIOS;
  }

  static bool get isLoggedIn => _isLoggedIn;

  static set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  static User get user => _user;

  static set user(User value) {
    _user = value;
    if (value != null) {
      maxPriceFilter = person.countryInformations.maxPrice;
      minPriceFilter = person.countryInformations.minPrice;
      stepPriceFilter = person.countryInformations.priceStep;
    }
  }

  static int calculateAge(DateTime date) {
    int years = DateTime.now().year - date.year;
    if (DateTime.now().month < date.month ||
        (DateTime.now().month == date.month && DateTime.now().day < date.day))
      years--;
    return years;
  }

  //todo it is too much 6 months
  static DateTime get maxAlertDate {
    var d = DateTime.now();
    DateTime(d.year, d.month + 6, d.day);
  }

  static List<String> get countriesInformationsNames =>
      _countriesInformationsNames;

  static List<String> get countriesInformationsCodes =>
      _countriesInformationsCodes;

  static Map<String, CountryInformations> get countriesInformations =>
      _countriesInformations;

  static Driver get driver => user == null ? null : user.driver;

  static p.Person get person => user == null ? null : user.person;

  static List<String> getRateReasons(context) {
    return <String>[
      Lang.getString(context, "I'm_a_quiet_person"),
      Lang.getString(context, "I_talk_depending_on_my_mood"),
      Lang.getString(context, "I_love_to_chat!"),
    ];
  }

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

    if (notification.imageUrl != null) {
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
    //todo cache notification
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
  }

  static Ride getRideFromObjectId(String objectId) {
    for (final ride in person.upcomingRides) {
      if (ride.id == objectId) {
        return ride;
      }
    }
  }
}
