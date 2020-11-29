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
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale;

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
    Cache.init();
    super.initState();
  }
  void _init(){
    if (Cache.darkTheme) {
      Styles.setTheme(ThemeMode.dark);
    }
    if (Cache.locale != null) _locale = Locale(Cache.locale);

    App.init(this);
  }
  @override
  Widget build(BuildContext context) {
    if (!Cache.loaded) {
      return SplashScreen();
    } else {
      _init();
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
