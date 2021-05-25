import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pickapp/ads/Ads.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/RouteGenerator.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/notifications/PushNotificationsManager.dart';
import 'package:pickapp/pages/SplashScreen.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Ads.initialize();

  await Cache.initializeHive();

  App.user = await Cache.getUser();
  if (App.user != null) {
    App.isLoggedInNotifier.value = true;
    List<String> c = await Cache.getCountriesList();
    App.setCountriesComponent(c);

    if (App.driver != null) App.isDriverNotifier.value = true;
  }

  //navbar color, not the bottomnavbar, it's the bar where you can press back in android.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Styles.primaryColor(),
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
    super.initState();
    Request.initBackendless();
    App.init(this);
    cacheFuture = Cache.init();
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      await PushNotificationsManager().onResume();
    }));
    PushNotificationsManager()
        .init()
        .then((value) => PushNotificationsManager().initNotifications());
  }

  void _init() {
    if (Cache.darkTheme) {
      Styles.setTheme(ThemeMode.dark);
    }
    if (Cache.locale != null) _locale = Locale(Cache.locale);
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
              navigatorKey: App.navKey,
              title: App.appName,
              locale: _locale,
              navigatorObservers: <NavigatorObserver>[App.observer],
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
                textSelectionColor: Styles.highlitedPrimary(),
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
              builder: (context, child) => Scaffold(
                body: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus.unfocus();
                    }
                  },
                  child: child,
                ),
              ),
              initialRoute: '/',
            );
          }
        });
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.paused:
        await Cache.closeHiveBoxes();
        break;
    }
  }
}
