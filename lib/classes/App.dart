import 'dart:io' show HttpStatus, Platform;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart' as int1;
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/CountryInformations.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/main.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/utilities/CustomToast.dart';

import 'Localizations.dart';

class App {
  static final navKey = new GlobalKey<NavigatorState>();
  static bool isAppBuild = false;
  static MyAppState _state;
  static final String appName = "Voomcar";
  static TextStyle textStyling = new TextStyle(fontSize: 30);
  static final String googleKey = "AIzaSyCjEHxPme3OLzDwsnkA8Tl5QF8_B9f70U0";
  static String dateFormat = 'dd/MM/yyyy hh:mm a';
  static String hourFormat = 'hh:mm a';
  static String birthdayFormat = 'dd/MM/yyyy';
  static User _user;

  //these are real boolean notifiers.
  static ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);
  static ValueNotifier<bool> isDriverNotifier = ValueNotifier<bool>(App.driver != null);
  static ValueNotifier<bool> isNewNotificationNotifier = ValueNotifier<bool>(false);
  static ValueNotifier<bool> isNewMessageNotifier = ValueNotifier<bool>(false);

  //these are only triggers.
  static ValueNotifier<bool> updateProfile = ValueNotifier<bool>(false);
  static ValueNotifier<bool> updateInbox = ValueNotifier(false);
  static ValueNotifier<bool> updateConversation = ValueNotifier(false);
  static ValueNotifier<bool> updateUpcomingRide = ValueNotifier(false);
  static ValueNotifier<bool> updateNotifications = ValueNotifier(false);
  static ValueNotifier<bool> updateLocationFinder = ValueNotifier(false);

  static List<String> _countriesInformationsNames = ["Deutschland", "لبنان"];
  static List<String> _countriesInformationsCodes = ["49", "961"];
  static dynamic maxPriceFilter;
  static dynamic minPriceFilter;
  static dynamic stepPriceFilter;
  static Locale locale;
  static List<Component> countriesComponents = <Component>[];

  //if you want to change this variable, Rate_days_validation text.
  static Duration availableDurationToRate = Duration(days: 2);

  static bool isLTR;
  static List<MainNotification> notifications = <MainNotification>[];

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static List<String> _chattiness;
  static List<String> _rateReasons;
  static List<String> _genders;

  static Map<String, CountryInformations> _countriesInformations = <String, CountryInformations>{
    'Deutschland': CountryInformations(
        name: "Deutschland",
        id: "CAE25E4F-A78C-12BB-FF38-92A6EC9D4F00",
        digits: 11,
        code: "49",
        drivingAge: 18,
        countryComponent: "DE"),
    'لبنان': CountryInformations(
        name: "لبنان",
        id: "F85258BF-63A7-F939-FF31-C78BB1837300",
        digits: 8,
        code: "961",
        drivingAge: 18,
        countryComponent: "LB"),
  };

  static CountryInformations getCountryInfo(String code) {
    var list = _countriesInformations.values.toList();
    for (final v in list)
      if (code == v.code) {
        return v;
      }
    return null;
  }

  static void changeLanguage(String lang, context) async {
    await Cache.setLocale(lang);
    _state.setLocale(Locale(lang));
  }

  static bool checkIfDriver(User user) {
    if (user.driver != null && user.driver == App.user.driver)
      return true;
    else
      return false;
  }

  static void setTheme(bool value) async {
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

  static void updateUserCache() {
    Cache.setUser(App.user);
    updateUpcomingRide.value = !updateUpcomingRide.value;
  }

  //called in Home class
  static void setContext(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    ScreenUtil.init(context,
        designSize: Size(360, 640), designStatusBarHeight: 24, allowFontScaling: true);
    Styles.setFontSizes(
        subValueFontSize: ScreenUtil().setSp(12.24),
        fontSize: ScreenUtil().setSp(15),
        titleFontSize: ScreenUtil().setSp(17.64));
    Styles.setIconSizes(
        largeSize: ScreenUtil().setSp(27),
        mediumSize: ScreenUtil().setSp(21),
        subMediumSize: ScreenUtil().setSp(18),
        smallSize: ScreenUtil().setSp(14.5));
    App.isLTR = Directionality.of(context) == TextDirection.ltr;
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
        subMediumSize: ScreenUtil().setSp(18),
        smallSize: ScreenUtil().setSp(14.5));
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIphone() {
    return Platform.isIOS;
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
        (DateTime.now().month == date.month && DateTime.now().day < date.day)) years--;
    return years;
  }

  static bool handleErrors(BuildContext context, int code, String message) {
    if (code == HttpStatus.ok) {
      return false;
    }
    if (code < 0) {
      CustomToast().showErrorToast(Lang.getString(context, code.toString()));
    } else {
      CustomToast().showErrorToast(message);
    }
    return true;
  }

  //todo it is too much 6 months
  static DateTime get maxAlertDate {
    var d = DateTime.now();
    DateTime(d.year, d.month + 6, d.day);
  }

  static List<String> get countriesInformationsNames => _countriesInformationsNames;

  static List<String> get countriesInformationsCodes => _countriesInformationsCodes;

  static Map<String, CountryInformations> get countriesInformations => _countriesInformations;

  static Driver get driver => user == null ? null : user.driver;

  static Person get person => user == null ? null : user.person;

  static List<String> getRateReasons(context) {
    if (_rateReasons == null) {
      _rateReasons = <String>[
        Lang.getString(context, "rate_reason_1"),
        Lang.getString(context, "rate_reason_2"),
        Lang.getString(context, "rate_reason_3"),
        Lang.getString(context, "rate_reason_4"),
        Lang.getString(context, "rate_reason_5"),
        Lang.getString(context, "rate_reason_6"),
        Lang.getString(context, "rate_reason_7")
      ];
    }
    return _rateReasons;
  }

  static List<String> getGender(context) {
    if (_genders == null) {
      _genders = <String>[
        Lang.getString(context, "Male"),
        Lang.getString(context, "Female"),
      ];
    }
    return _genders;
  }

  static List<String> getChattiness(context) {
    if (_chattiness == null) {
      _chattiness = <String>[
        Lang.getString(context, "I'm_a_quiet_person"),
        Lang.getString(context, "I_talk_depending_on_my_mood"),
        Lang.getString(context, "I_love_to_chat!"),
      ];
    }
    return _chattiness;
  }

  static deleteRideFromMyRides(Ride ride) {
    App.user.person.upcomingRides.remove(ride);
    LocalNotificationManager.cancelLocalNotification("ride_reminder." + ride.id);
    updateUserCache();
  }

  static addRideToMyRides(Ride ride, context) {
    String _locale = Localizations.localeOf(context).toString();
    App.user.person.upcomingRides.add(ride);
    updateUserCache();

    var rd = ride.leavingDate;
    DateTime d = new DateTime(rd.year, rd.month, rd.day, rd.hour, rd.minute, rd.second);
    String title = "Ride reminder";
    String body = "You have an upcoming ride that will start at " +
        int1.DateFormat(App.hourFormat, _locale).format(ride.leavingDate) +
        ", be ready";

    d.add(Duration(minutes: -30));
    //if there is less than 30 minutes then no need for reminder
    if (d.isAfter(DateTime.now())) {
      return;
    }
    MainNotification notification = MainNotification(
        title: title,
        body: body,
        object: [ride.id, ride.reserved],
        action: "RIDE_REMINDER",
        scheduleDate: d.add(Duration(minutes: -30)));
    LocalNotificationManager.pushLocalNotification(notification, "ride_reminder." + ride.id);
  }

  static double roundRate(double rate) {
    double rateA = rate;

    var k = ((rateA * 100) % 100).toInt();
    if (k >= 85) {
      rateA = rateA.round().toDouble();
    } else if (k > 25) {
      k = 5;
      rateA = double.parse(((rateA * 10).toInt() ~/ 10).toString() + "." + k.toString());
    } else {
      rateA = rateA.round().toDouble();
    }
    return rateA;
  }

  static void setCountriesComponent(List<String> countriesList) {
    if (countriesComponents == null) {
      countriesComponents = <Component>[];
    }
    if (countriesList != null)
      for (final item in countriesList) countriesComponents.add(Component(Component.country, item));
  }

  static Future<bool> logout() async {
    await Cache.clearHiveCache();
    App.user = null;
    App.isDriverNotifier.value = false;
    App.isLoggedInNotifier.value = false;
    LocalNotificationManager.cancelAllLocalNotifications();
    return true;
  }
}
