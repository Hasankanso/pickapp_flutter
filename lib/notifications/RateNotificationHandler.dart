import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/dataObjects/UserStatistics.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class RateNotificationHandler extends NotificationHandler{

  Rate rate;

  RateNotificationHandler(MainNotification notification) : super(notification) {

    //cast
    //save rate in notification.object and in this.rate
    Rate rate = Rate.fromJson((notification.object as List)[0]);
    notification.object = rate;
    this.rate = rate;
    notification.scheduleDate = DateTime.now().add(Duration(days: 2));

  }

  @override
  void cache() async {
    await Cache.addRate(rate);
    User user = await Cache.getUser();

    //create function in UserStatistics called update as example, and give it the rate as parameter, and it should update all statistics infromation based on it.
    //user.person.statistics = statistics;
    await Cache.setUser(App.user);
  }

  @override
  void display(NavigatorState state) {
    // TODO: implement display
  }

  @override
  void updateApp() {
    App.refreshProfile.value = true;
  }
}
