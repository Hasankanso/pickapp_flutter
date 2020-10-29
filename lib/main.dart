import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'file:///C:/Users/Hassa/AndroidStudioProjects/pickapp/lib/pages/Search.dart';
import 'package:pickapp/localization/Language.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        supportedLocales: [
          Locale('en'),
          Locale('ar'),
        ],
      localizationsDelegates: [
        Lang.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales){
          if(locale.languageCode == deviceLocale.languageCode){
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: Search(),
    );
  }
}


