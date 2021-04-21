import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/LocalNotificationManager.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class RateNotificationHandler extends NotificationHandler {
  Rate rate;

  RateNotificationHandler(MainNotification notification) : super(notification) {
    if (!(notification.object is Rate)) {
      notification.object = Rate.fromJson(notification.object);
      notification.scheduleDate = DateTime.now().add(Duration(minutes: App.daysToShowRate));
      notification.id = 0;
      LocalNotificationManager.pushLocalNotification(notification);
    }
    this.rate = notification.object;
  }

  @override
  Future<void> cache() async {
    await Cache.addRate(rate);
    User user = await Cache.getUser();
    user.person.statistics = user.person.statistics.createNewStatistics(rate);
    await Cache.setUser(user);
  }

  @override
  void display(BuildContext context) {
    // TODO: implement display
  }
}
