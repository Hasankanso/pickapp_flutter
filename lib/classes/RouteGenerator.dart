import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/pages/AddAlert.dart';
import 'package:pickapp/pages/AddCar.dart';
import 'package:pickapp/pages/AddCar2.dart';
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
import 'package:pickapp/pages/CountriesRestriction.dart';
import 'package:pickapp/pages/Details.dart';
import 'package:pickapp/pages/EditRide.dart';
import 'package:pickapp/pages/Email.dart';
import 'package:pickapp/pages/Home.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/pages/MyRidesHistory.dart';
import 'package:pickapp/pages/Notifications.dart';
import 'package:pickapp/pages/Phone.dart';
import 'package:pickapp/pages/Phone2.dart';
import 'package:pickapp/pages/PrivacyPolicy.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/RatePassengers.dart';
import 'package:pickapp/pages/Register.dart';
import 'package:pickapp/pages/RegisterDriver.dart';
import 'package:pickapp/pages/ReviewsListPage.dart';
import 'package:pickapp/pages/RideDetails.dart';
import 'package:pickapp/pages/SearchResults.dart';
import 'package:pickapp/pages/Security.dart';
import 'package:pickapp/pages/Settings.dart';
import 'package:pickapp/pages/Statistics.dart';
import 'package:pickapp/pages/TermAndConditions.dart';
import 'package:pickapp/pages/UpcomingRideDetails.dart';

import 'App.dart';

class RouteGenerator {
  static PageTransitionType get isLTR =>
      App.isLTR == true ? PageTransitionType.rightToLeft : PageTransitionType.leftToRight;

  static Duration _transitionTime = const Duration(milliseconds: 300);

  //this value is being updated in settings page.
  static Duration duration = Cache.disableAnimation ? Duration(milliseconds: 0) : _transitionTime;

  static void disableAnimation(bool value) {
    duration = value ? Duration(milliseconds: 0) : _transitionTime;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Home());
      case '/Settings':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Settings());
      case '/LoginRegister':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: LoginRegister());
      case '/Login':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Login());
      case '/Register':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Register());
      case '/Notifications':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Notifications());
      case '/Details':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Details());
      case '/ContactUs':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: ContactUs());
      case '/Security':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Security());
      case '/AddRidePage2':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: AddRidePage2(
              rideInfo: ((args as List)[0] as Ride),
              appBarTitleKey: (args as List)[1],
            ));
      case '/AddRidePage3':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: AddRidePage3(
              rideInfo: (args as List)[0],
              appBarTitleKey: (args as List)[1],
            ));
      case '/AddRidePage4':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: AddRidePage4(
              rideInfo: (args as List)[0],
              appBarTitleKey: (args as List)[1],
            ));
      case '/AddRidePage5':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: AddRidePage5(
              rideInfo: (args as List)[0],
              appBarTitleKey: (args as List)[1],
            ));
      case '/UpcomingRideDetails':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: UpcomingRideDetails(
              (args as List)[0],
              buttonText: (args as List)[1],
              onPressed: (args as List)[2],
            ));
      case '/EditRide':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: EditRide(args as Ride));
      case '/MyRidesHistory':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: MyRidesHistory());
      case '/Statistics':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Statistics());
      case "/CarDetails":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: CarDetails(
              car: args,
            ));
      case '/PrivacyPolicy':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: PrivacyPolicy());
      case '/TermAndConditions':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: TermAndConditions());
      case '/RideResults':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: SearchResults(searchInfo: args));
      case '/Profile':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Profile());
      case '/RideDetails':
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: RideDetails(
              ((args as List)[0] as Ride),
              buttonText: (args as List)[1],
              onPressed: (args as List)[2],
              isEditDisabled: (args as List)[3],
            ));
      case '/CarView':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: CarView());

      //become driver screens
      case '/BecomeDriver':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: BecomeDriver(
              isRegionPage: args,
            ));
      case '/AddCarDriver':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar(driver: args));
      case "/AddCar2Driver":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar2(driver: args));
      //add car screens
      case '/AddCar':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar());
      case "/AddCar2":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar2(car: args));

      case "/Email":
        return PageTransition(
          settings: settings,
          duration: duration,
          reverseDuration: duration,
          type: isLTR,
          child: Email(),
        );
      case "/Phone":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Phone(
              args,
            ));
      case "/Phone2":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Phone2(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      case "/Phone2ChangePhone":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Phone2(
              oldUser: args,
            ));
      case '/RegisterDetails':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Details(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      case '/RegisterDriver':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: RegisterDriver(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      //register driver screens
      case '/BecomeDriverRegister':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: BecomeDriver(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      case '/AddCarRegister':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      case "/AddCar2Register":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar2(
              user: ((args as List)[0] as User),
              isForceRegister: (args as List)[1],
            ));
      case '/Conversation':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: Conversation(
              args,
            ));

      case '/ReviewsPageList':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: ReviewsListPage(args));
      case '/AddRate':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddRate(
              ((args as List)[0] as Ride),
              ((args as List)[1] as Person),
            ));
      case 'RatePassengers':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: RatePassengers(ride: args));
      case '/AddAlert':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddAlert());
      case '/CountriesRestriction':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: CountriesRestriction());
    }
  }
}
