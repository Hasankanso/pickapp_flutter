import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/pages/SplashScreen.dart';
import 'package:pickapp/routing/RouteGenerator.dart';

import 'classes/MainTheme.dart';
import 'classes/Styles.dart';

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
  bool _localeCached = true;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    Cache.getLocale().then((String lang) => setState(() {
          if (lang == null) {
            _localeCached = false;
            return;
          }
          this._locale = Locale(lang);
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null && _localeCached) {
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
        themeMode: MainTheme.currentTheme(),
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
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode) {
              return deviceLocale;
            }
          }

          Locale preferred = supportedLocales.first;
          if (!_localeCached) Cache.setLocale(preferred.languageCode);
          return preferred;
        },
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    }
  }
}
