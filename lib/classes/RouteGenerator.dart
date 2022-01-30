import 'package:flutter/material.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/pages/AddAlert.dart';
import 'package:just_miles/pages/AddCar.dart';
import 'package:just_miles/pages/AddCar2.dart';
import 'package:just_miles/pages/BecomeDriver.dart';
import 'package:just_miles/pages/CarDetails.dart';
import 'package:just_miles/pages/CarView.dart';
import 'package:just_miles/pages/ContactUs.dart';
import 'package:just_miles/pages/Conversation.dart';
import 'package:just_miles/pages/CountriesRestriction.dart';
import 'package:just_miles/pages/Details.dart';
import 'package:just_miles/pages/EditRide.dart';
import 'package:just_miles/pages/Email.dart';
import 'package:just_miles/pages/Home.dart';
import 'package:just_miles/pages/Login.dart';
import 'package:just_miles/pages/LoginRegister.dart';
import 'package:just_miles/pages/NewVersion.dart';
import 'package:just_miles/pages/Notifications.dart';
import 'package:just_miles/pages/Phone.dart';
import 'package:just_miles/pages/Phone2.dart';
import 'package:just_miles/pages/PrivacyPolicy.dart';
import 'package:just_miles/pages/Profile.dart';
import 'package:just_miles/pages/RateDriver.dart';
import 'package:just_miles/pages/RatePassengers.dart';
import 'package:just_miles/pages/Register.dart';
import 'package:just_miles/pages/RegisterDriver.dart';
import 'package:just_miles/pages/ReviewsListPage.dart';
import 'package:just_miles/pages/RideDetails.dart';
import 'package:just_miles/pages/SearchResults.dart';
import 'package:just_miles/pages/Security.dart';
import 'package:just_miles/pages/Settings.dart';
import 'package:just_miles/pages/Statistics.dart';
import 'package:just_miles/pages/TermAndConditions.dart';
import 'package:just_miles/pages/UpcomingRideDetails.dart';
import 'package:just_miles/pages/add_ride/AddRidePage2.dart';
import 'package:just_miles/pages/add_ride/AddRidePage3.dart';
import 'package:just_miles/pages/add_ride/AddRidePage4.dart';
import 'package:just_miles/pages/add_ride/AddRidePage5.dart';
import 'package:page_transition/page_transition.dart';

import 'App.dart';

class RouteGenerator {
  static PageTransitionType get isLTR => App.isLTR == true
      ? PageTransitionType.rightToLeft
      : PageTransitionType.leftToRight;

  static Duration _transitionTime = const Duration(milliseconds: 300);

  //this value is being updated in settings page.
  static Duration duration =
      Cache.disableAnimation ? Duration(milliseconds: 0) : _transitionTime;

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
        List list = args as List;
        bool isContactDisabled = false;
        if (list.length > 4) {
          isContactDisabled = list[4];
        }
        return PageTransition(
            settings: settings,
            type: isLTR,
            duration: duration,
            reverseDuration: duration,
            child: RideDetails(
              (list[0] as Ride),
              buttonText: list[1],
              onPressed: list[2],
              isEditDisabled: list[3],
              isContactDisabled: isContactDisabled,
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
        List argsList = args as List;
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: BecomeDriver(
              isRegionPage: argsList[0] as bool,
              isInRegister: argsList[1] as bool,
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
            ));
      case '/RegisterDriver':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: RegisterDriver(
              user: ((args as List)[0] as User),
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
              isInRegister: true,
            ));
      case '/AddCarRegister':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar(
              user: ((args as List)[0] as User),
            ));
      case "/AddCar2Register":
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: AddCar2(
              user: ((args as List)[0] as User),
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
      case '/RateDriver':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: RateDriver(
              ((args as List)[0] as Ride),
              ((args as List)[1] as Person),
              ((args as List)[2] as String),
              ((args as List)[3] as DateTime),
              ((args as List)[4] as MainNotification),
            ));
      case '/RatePassengers':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: RatePassengers(
              ride: ((args as List)[0] as Ride),
              notification: ((args as List)[1] as MainNotification),
            ));
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
      case '/NewVersion':
        return PageTransition(
            settings: settings,
            duration: duration,
            reverseDuration: duration,
            type: isLTR,
            child: NewVersion());
    }
  }
}
