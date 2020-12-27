import 'package:flutter/material.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/pages/AddCar.dart';
import 'package:pickapp/pages/AddCar2.dart';
import 'package:pickapp/pages/AddCar3.dart';
import 'package:pickapp/pages/AddRidePage2.dart';
import 'package:pickapp/pages/AddRidePage3.dart';
import 'package:pickapp/pages/AddRidePage4.dart';
import 'package:pickapp/pages/AddRidePage5.dart';
import 'package:pickapp/pages/BecomeDriver.dart';
import 'package:pickapp/pages/CarDetails.dart';
import 'package:pickapp/pages/CarView.dart';
import 'package:pickapp/pages/ContactUs.dart';
import 'package:pickapp/pages/Conversation.dart';
import 'package:pickapp/pages/Details.dart';
import 'package:pickapp/pages/Email.dart';
import 'package:pickapp/pages/Home.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/pages/Notifications.dart';
import 'package:pickapp/pages/Phone.dart';
import 'package:pickapp/pages/Phone2.dart';
import 'package:pickapp/pages/PrivacyPolicy.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/Register.dart';
import 'package:pickapp/pages/RideDetails.dart';
import 'package:pickapp/pages/SearchResults.dart';
import 'package:pickapp/pages/Settings.dart';
import 'package:pickapp/pages/Statistics.dart';
import 'package:pickapp/pages/TermAndConditions.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/LoginRegister':
        return MaterialPageRoute(builder: (_) => LoginRegister());
      case '/Login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/Register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => Notifications());
      case '/Details':
        return MaterialPageRoute(builder: (_) => Details());
      case '/ContactUs':
        return MaterialPageRoute(builder: (_) => ContactUs());
      case '/AddRidePage2':
        return MaterialPageRoute(
            builder: (_) => AddRidePage2(
                  rideInfo: args,
                ));
      case '/AddRidePage3':
        return MaterialPageRoute(
            builder: (_) => AddRidePage3(
                  rideInfo: args,
                ));
      case '/AddRidePage4':
        return MaterialPageRoute(
            builder: (_) => AddRidePage4(
                  rideInfo: args,
                ));
      case '/AddRidePage5':
        return MaterialPageRoute(
            builder: (_) => AddRidePage5(
              rideInfo: args,
            ));
      case '/Statistics':
        return MaterialPageRoute(builder: (_) => Statistics());
      case "/CarDetails":
        return MaterialPageRoute(
            builder: (_) => CarDetails(
                  car: args,
                ));
      case '/PrivacyPolicy':
        return MaterialPageRoute(builder: (_) => PrivacyPolicy());
      case '/TermAndConditions':
        return MaterialPageRoute(builder: (_) => TermAndConditions());
      case '/RideResults':
        return MaterialPageRoute(
            builder: (_) => SearchResults(searchInfo: args));
      case '/Profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/RideDetails':
        return MaterialPageRoute(builder: (_) => RideDetails(ride: args));
      case '/CarView':
        return MaterialPageRoute(builder: (_) => CarView());

      //become driver screens
      case '/BecomeDriver':
        return MaterialPageRoute(
            builder: (_) => BecomeDriver(
                  isRegionPage: args,
                ));
      case '/AddCarDriver':
        return MaterialPageRoute(builder: (_) => AddCar(driver: args));
      case "/AddCar2Driver":
        return MaterialPageRoute(builder: (_) => AddCar2(driver: args));
      case "/AddCar3Driver":
        return MaterialPageRoute(
            builder: (_) => AddCar3(
                  driver: args,
                ));
      //add car screens
      case '/AddCar':
        return MaterialPageRoute(builder: (_) => AddCar());
      case "/AddCar2":
        return MaterialPageRoute(builder: (_) => AddCar2(car: args));
      case "/AddCar3":
        return MaterialPageRoute(
            builder: (_) => AddCar3(
                  car: args,
                ));
      case "/Email":
        return MaterialPageRoute(
          builder: (_) => Email(),
        );
      case "/Phone":
        return MaterialPageRoute(
            builder: (_) => Phone(
                  args,
                ));
      case "/Phone2":
        return MaterialPageRoute(
            builder: (_) => Phone2(
                  user: ((args as List)[0] as User),
                  isForceRegister: (args as List)[1],
                ));

      case '/Conversation':
        return MaterialPageRoute(builder: (_) => Conversation(chat: args,));
    }
  }
}
