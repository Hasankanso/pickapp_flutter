import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/RouteGenerator.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:pickapp/pages/SplashScreen.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/Startup.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Request.initBackendless();
  await Firebase.initializeApp();

  App.isLoggedInNotifier = ValueNotifier<bool>(App.isLoggedIn);
  App.isDriverNotifier = ValueNotifier<bool>(App.driver != null);

  final path = await PathProvider.getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(DriverAdapter());
  Hive.registerAdapter(CountryInformationsAdapter());
  Hive.registerAdapter(CarAdapter());
  Hive.registerAdapter(MainLocationAdapter());
  Hive.registerAdapter(RideAdapter());
  Hive.registerAdapter(PassengerAdapter());
  Hive.registerAdapter(ChatAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(MainNotificationAdapter());
  await Hive.openBox('user');

  final box = Hive.box("user");
  if (box.length != 0) {
    App.user = box.getAt(0) as User;
    App.isLoggedIn = true;
    App.isLoggedInNotifier.value = true;
    if (App.driver != null) App.isDriverNotifier.value = true;
    Inbox.subscribeToChannel();
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Styles.primaryColor(), // navigation bar color
  ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  Future<SharedPreferences> cacheFuture;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setTheme(ThemeMode mode) {
    setState(() {
      Styles.setTheme(mode);
    });
  }

  @override
  void initState() {
    App.init(this);
    cacheFuture = Cache.init();
    super.initState();
  }

  void _init() {
    if (Cache.darkTheme) {
      Styles.setTheme(ThemeMode.dark);
    }
    if (Cache.locale != null) _locale = Locale(Cache.locale);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (App.user != null) {
      //List<String> channels = ["default"];
      List<String> deviceObjectIds = List<String>();
      //await Backendless.messaging.registerDevice(channels).then((response) {
      //var ids = response.toJson()["channelRegistrations"];
      //for (final channel in channels) deviceObjectIds.add(ids["$channel"]);
      //});
      Request<String> request = Startup(App.user, deviceObjectIds);
      request.send((userStatus, code, message) =>
          response(userStatus, code, message, context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: cacheFuture,
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (Cache.loading) {
            return SplashScreen();
          } else if (Cache.failed) {
            Cache.init();
            return SplashScreen();
          } else {
            _init();
            return MaterialApp(
              title: App.appName,
              locale: _locale,
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Styles.primaryColor(),
                accentIconTheme: IconThemeData(color: Styles.labelColor()),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Styles.primaryColor(),
                  foregroundColor: Styles.primaryColor(),
                ),
                primaryTextTheme: TextTheme(
                    headline6: TextStyle(color: Styles.secondaryColor())),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              themeMode: Styles.currentTheme(),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                accentColor: Styles.secondaryColor(),
                primarySwatch: Styles.primaryColor(),
                toggleableActiveColor: Styles.primaryColor(),
                textSelectionHandleColor: Styles.primaryColor(),
                accentIconTheme: IconThemeData(color: Styles.secondaryColor()),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Styles.primaryColor(),
                  foregroundColor: Styles.primaryColor(),
                ),
                primaryTextTheme: TextTheme(
                    headline6: TextStyle(color: Styles.secondaryColor())),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              supportedLocales:
                  Lang.langs.map((element) => Locale(element.code)),
              localizationsDelegates: [
                Lang.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                Locale chosen = supportedLocales.first;
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale.languageCode) {
                    chosen = deviceLocale;
                    break;
                  }
                }
                //check if locale was cached
                if (_locale == null) Cache.setLocale(chosen.languageCode);
                App.locale = chosen;

                return chosen;
              },
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: '/',
            );
          }
        });
  }

  response(String userStatus, int code, String message, context) async {
    if (code != HttpStatus.ok) {
      if (code == -1 || code == -2) {
        await Hive.openBox("regions");
        var regionB = Hive.box("regions");
        await regionB.clear();
        regionB.close();
        var userB = Hive.box("user");
        userB.clear();
        App.user = null;
        App.isLoggedIn = false;
        App.isDriverNotifier.value = false;
        App.isLoggedInNotifier.value = false;
        CustomToast().showErrorToast(Lang.getString(context, message));
      } else if (code == -3) {
        CustomToast().showErrorToast(Lang.getString(context, message));
      } else {
        CustomToast().showErrorToast(message);
      }
    } else {}
  }
}
