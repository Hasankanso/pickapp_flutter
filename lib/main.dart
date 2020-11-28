import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/pages/SplashScreen.dart';
import 'package:pickapp/routing/RouteGenerator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    MyAppState state = new MyAppState();
    App.init(state);
    return state;
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  bool _cacheLoaded = false;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setDarkTheme() {
    setState(() {
      Styles.setTheme(ThemeMode.dark);
    });
  }

  @override
  void initState() {
    super.initState();
    Cache.getLocale().then((String lang) =>
        Cache.getCurrentTheme().then((ThemeMode mode) => setState(() {
              if (lang != null) {
                this._locale = Locale(lang);
              }
              if (mode != null) {
              Styles.setTheme(mode);
              }
              _cacheLoaded = true;
            })));
  }

  @override
  Widget build(BuildContext context) {
    if (!_cacheLoaded) {
      return SplashScreen();
    } else {
      return MaterialApp(
        title: App.appName,
        locale: _locale,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Styles.primaryColor(),
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Styles.secondaryColor())),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        themeMode: Styles.currentTheme(),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Styles.primaryColor(),
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Styles.secondaryColor())),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: Lang.langs.map((element) => Locale(element.code)),
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
          return chosen;
        },
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    }
  }
}
