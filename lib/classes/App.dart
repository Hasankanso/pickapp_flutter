import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/main.dart';
import 'package:pickapp/requests/Request.dart';

class App {
  static MyAppState _state;
  static final String appName = "PickApp";
  static TextStyle textStyling = new TextStyle(fontSize: 30);
  static final String googleKey = "AIzaSyC7U0OEb9200tGZFFFTyLjQdo3goKyuSsw";
  static String dateFormat = 'dd/MM/yyyy';
  static String countryCode = "lb";
  static User _user = _fakeUser();
  static bool _isLoggedIn = true;
  static List<String> _countriesInformationsNames;

  static Locale locale;

  static void changeLanguage(String lang) async {
    await Cache.setLocale(lang);
    _state.setLocale(Locale(lang));
  }

  //NEVER USE THIS OUTSIDE OF THIS CLASS!!
  static User _fakeUser() {
    return User(
        email: 'kansoads@gmail.com',
        person: Person(
            firstName: "Hassan",
            lastName: "Kanso",
            rateAverage: 2.5,
            acomplishedRides: 20,
            canceledRides: 2,
            profilePictureUrl:
                "https://cdn.vox-cdn.com/thumbor/qaURkyxczndcpZJgkEKzs2frs_4=/1400x1400/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/16307099/1146087607.jpg.jpg",
            chattiness: 2,
            rateCount: 22,
            countryInformations: CountryInformations(
              name: "Lebanon",
              unit: "LL",
            )),
        driver: Driver(cars: [
          Car(
              maxLuggage: 2,
              maxSeats: 3,
              brand: "BMW",
              name: "C230",
              carPictureUrl: "lib/images/adel.png"),
          Car(
              maxLuggage: 2,
              maxSeats: 3,
              brand: "BMW",
              name: "C230",
              carPictureUrl: "lib/images/adel.png")
        ]));
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
    Request.initBackendless();
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

  static set countriesInformationsNames(List<String> value) {
    _countriesInformationsNames = value;
  }

  static Driver get driver => user == null ? null : user.driver;
  static Person get person => user == null ? null : user.person;
}
