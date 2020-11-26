import 'package:flutter/material.dart';
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
    }
  }
}
