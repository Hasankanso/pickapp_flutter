import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/pages/AddAlert.dart';
import 'package:pickapp/pages/AddCar.dart';
import 'package:pickapp/pages/AddCar2.dart';
import 'package:pickapp/pages/AddCar3.dart';
import 'package:pickapp/pages/AddRate.dart';
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
import 'package:pickapp/pages/HowItWorks.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/pages/MyRidesHistory.dart';
import 'package:pickapp/pages/Notifications.dart';
import 'package:pickapp/pages/Phone.dart';
import 'package:pickapp/pages/Phone2.dart';
import 'package:pickapp/pages/PrivacyPolicy.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/RatesListPage.dart';
import 'package:pickapp/pages/Register.dart';
import 'package:pickapp/pages/RegisterDriver.dart';
import 'package:pickapp/pages/RideDetails.dart';
import 'package:pickapp/pages/RideDetails2.dart';
import 'package:pickapp/pages/SearchResults.dart';
import 'package:pickapp/pages/Security.dart';
import 'package:pickapp/pages/Settings.dart';
import 'package:pickapp/pages/Statistics.dart';
import 'package:pickapp/pages/TermAndConditions.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Home());
      case '/Settings':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Settings());
      case '/LoginRegister':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginRegister());
      case '/Login':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Login());
      case '/Register':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Register());
      case '/Notifications':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Notifications());
      case '/Details':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Details());
      case '/ContactUs':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: ContactUs());
      case '/Security':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Security());
      case '/AddRidePage2':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddRidePage2(
              rideInfo: args,
            ));
      case '/AddRidePage3':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddRidePage3(
              rideInfo: args,
            ));
      case '/AddRidePage4':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddRidePage4(
              rideInfo: args,
            ));
      case '/AddRidePage5':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddRidePage5(
              rideInfo: args,
            ));
      case '/RideDetails2':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: RideDetails2(
    (args as List)[0],
    buttonText: (args as List)[1],
    onPressed: (args as List)[2],
    ));
      case '/HowItWorks':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: HowItWorks());
      case '/MyRidesHistory':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: MyRidesHistory());
      case '/Statistics':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Statistics());
      case "/CarDetails":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: CarDetails(
              car: args,
            ));
      case '/PrivacyPolicy':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: PrivacyPolicy());
      case '/TermAndConditions':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: TermAndConditions());
      case '/RideResults':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SearchResults(searchInfo: args));
      case '/Profile':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: Profile());
      case '/RideDetails':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: RideDetails(
              (args as List)[0],
              buttonText: (args as List)[1],
              onPressed: (args as List)[2],
            ));
      case '/CarView':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: CarView());

      //become driver screens
      case '/BecomeDriver':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: BecomeDriver(
              isRegionPage: args,
            ));
      case '/AddCarDriver':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddCar(driver: args));
      case "/AddCar2Driver":
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddCar2(driver: args));
      case "/AddCar3Driver":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddCar3(
              driver: args,
            ));
      //add car screens
      case '/AddCar':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddCar());
      case "/AddCar2":
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddCar2(car: args));
      case "/AddCar3":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddCar3(
              car: args,
            ));
      case "/Email":
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: Email(),
        );
      case "/Phone":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Phone(
              args,
            ));
      case "/Phone2":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Phone2(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      case "/Phone2ChangePhone":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Phone2(
              oldUser: args,
            ));
      case '/RegisterDetails':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Details(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
              idToken: (args as List)[2],
            ));
      case '/RegisterDriver':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: RegisterDriver(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
              idToken: (args as List)[2],
            ));
      //register driver screens
      case '/BecomeDriverRegister':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: BecomeDriver(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
              idToken: (args as List)[2],
            ));
      case '/AddCarRegister':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddCar(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
              idToken: (args as List)[2],
            ));
      case "/AddCar2Register":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddCar2(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
              idToken: (args as List)[2],
            ));
      case "/AddCar3Register":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddCar3(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
              idToken: (args as List)[2],
            ));
      case '/ExistingConversation':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Conversation(
              chat: args,
            ));

      case '/Conversation':
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Conversation.from(
              person: args,
            ));

      case '/RatesView':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: RatesListPage(args));
      case '/AddRate':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddRate());
      case '/AddAlert':
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddAlert());
    }
  }
}
