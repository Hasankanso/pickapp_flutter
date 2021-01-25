import 'dart:io' show Platform;

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  static ValueNotifier<bool> isLoggedInNotifier;
  static ValueNotifier<bool> isDriverNotifier;
  static List<String> _countriesInformationsNames = ["Deutschland", "لبنان"];
  static List<String> _countriesInformationsCodes = ["49", "961"];
  static dynamic maxPriceFilter;
  static dynamic minPriceFilter;
  static dynamic stepPriceFilter;
  static Channel inboxChannel;
  static List<MainNotification> notifications = List<MainNotification>();
  static Locale locale;
  static ValueNotifier<bool> newMessageInbox = ValueNotifier(false);
  static bool isLTR;
  static ValueNotifier<bool> isNewNotificationNotifier =
      ValueNotifier<bool>(false);

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

  static void changeLanguage(String lang, context) async {
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

  static Ride getRideFromObjectId(String objectId) {
    for (final ride in person.upcomingRides) {
      if (ride.id == objectId) {
        return ride;
      }
    }
  }
}
