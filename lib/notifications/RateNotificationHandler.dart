import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/dataObjects/UserStatistics.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class RateNotificationHandler extends NotificationHandler {
  List<Rate> rates;
  static const String action = "RATE";
  static const String prefix = "rate_driver.";

  RateNotificationHandler(MainNotification notification) : super(notification) {
    notification.scheduleDate = DateTime.now().add(App.availableDurationToRate);
    this.rates = List<Rate>.from(notification.object);
  }

  @override
  Future<void> cache() async {
    await Cache.setRates(rates);
    User user = await Cache.getUser();
    UserStatistics userStatistics = user.person.statistics;
    for (final rate in rates) {
      userStatistics = userStatistics.createNewStatistics(rate);
    }
    user.person.statistics = userStatistics;
    await Cache.setUser(user);
    rates.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    if (rates.isNotEmpty)
      LocalNotificationManager.pushLocalNotification(
          this.notification, prefix + rates[0].id);
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
