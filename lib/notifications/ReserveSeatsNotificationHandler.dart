import 'package:flutter/widgets.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler<Ride> {


  ReserveSeatsNotificationHandler(MainNotification notification) : super(notification);



  @override
  void cache(Ride ride) {
    // TODO: implement cache
  }

  @override
  void display(NavigatorState state, Ride ride) {
    // TODO: implement display
  }

  @override
  void updateApp(Ride ride) {
    // TODO: implement updateApp
  }


}