import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class RateNotificationHandler extends NotificationHandler {
  Rate rate;

  RateNotificationHandler(MainNotification notification) : super(notification) {
    //cast
    //save rate in notification.object and in this.rate
    Rate rate = Rate.fromJson(notification.object);
    notification.object = rate;
    this.rate = rate;
    notification.scheduleDate = DateTime.now().add(Duration(days: 2));
  }

  @override
  Future<void> cache() async {
    await Cache.addRate(rate);
    User user = await Cache.getUser();
    user.person.statistics = user.person.statistics.createNewStatistics(rate);
    await Cache.setUser(user);
  }

  @override
  void display(NavigatorState state) {
    // TODO: implement display
  }

  @override
  Future<void> updateApp() async {
    App.refreshProfile.value = true;
  }
}
