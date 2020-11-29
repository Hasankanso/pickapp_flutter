import 'package:flutter/material.dart';
import 'package:pickapp/pages/AddRidePage2.dart';
import 'package:pickapp/pages/Bio.dart';
import 'package:pickapp/pages/ContactUs.dart';
import 'package:pickapp/pages/Home.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/pages/Notifications.dart';
import 'package:pickapp/pages/Settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => Notifications());
      case '/bio':
        return MaterialPageRoute(builder: (_) => Bio());
      case '/AddRidePage2':
        return MaterialPageRoute(builder: (_) => AddRidePage2());
      case '/ContactUs' :
        return MaterialPageRoute(builder: (_) => ContactUs());
    }
  }
}
