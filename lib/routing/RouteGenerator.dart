import 'package:flutter/material.dart';
import 'package:pickapp/pages/AddRidePage2.dart';
import 'package:pickapp/pages/AddRidePage3.dart';
import 'package:pickapp/pages/AddRidePage4.dart';
import 'package:pickapp/pages/ContactUs.dart';
import 'package:pickapp/pages/Details.dart';
import 'package:pickapp/pages/EditAccount.dart';
import 'package:pickapp/pages/Home.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/pages/Notifications.dart';
import 'package:pickapp/pages/Regions.dart';
import 'package:pickapp/pages/Settings.dart';
import 'package:pickapp/pages/Statistics.dart';
import 'package:pickapp/utilities/BecomeDriver.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/Login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => Notifications());
      case '/Details':
        return MaterialPageRoute(builder: (_) => Details());
      case '/ContactUs':
        return MaterialPageRoute(builder: (_) => ContactUs());
      case '/AddRidePage2':
        return MaterialPageRoute(builder: (_) => AddRidePage2());
      case '/AddRidePage3':
        return MaterialPageRoute(builder: (_) => AddRidePage3());
      case '/AddRidePage4':
        return MaterialPageRoute(builder: (_) => AddRidePage4());
      case '/Statistics':
        return MaterialPageRoute(builder: (_) => Statistics());
      case '/Regions':
        return MaterialPageRoute(builder: (_) => Regions());
      case '/EditAccount':
        return MaterialPageRoute(builder: (_) => EditAccount());
      case '/BecomeDriver':
        return MaterialPageRoute(builder: (_) => BecomeDriver());
    }
  }
}
