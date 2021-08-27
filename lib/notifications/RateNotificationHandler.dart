import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class RateNotificationHandler extends NotificationHandler {
  Rate rate;
  static const String action = "RATE";
  static const String prefix = "rate_driver.";

  RateNotificationHandler(MainNotification notification) : super(notification) {
    if (!(notification.object is Rate)) {
      notification.object = Rate.fromJson(notification.object);
      notification.scheduleDate = DateTime.now().add(App.availableDurationToRate);
    }
    this.rate = notification.object;
  }

  @override
  Future<void> cache() async {
    await Cache.addRate(rate);
    User user = await Cache.getUser();
    user.person.statistics = user.person.statistics.createNewStatistics(rate);
    await Cache.setUser(user);

    LocalNotificationManager.pushLocalNotification(this.notification, prefix + rate.id);
  }

  @override
  Future<void> updateApp() async {
    App.updateProfile.value = !App.updateProfile.value;
  }

  @override
  Future<void> display(BuildContext context) {
    Navigator.pushNamed(context, "/ReviewsPageList");
  }
}
