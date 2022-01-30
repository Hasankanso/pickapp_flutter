import 'package:flutter/widgets.dart';
import 'package:just_miles/ads/Ads.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/items/MyRidesTile.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class RideReminderNotificationHandler extends NotificationHandler {
  RideReminderNotificationHandler(MainNotification notification)
      : super(notification);

  @override
  Future<void> cache() async {}

  @override
  Future<void> updateApp() async {}

  @override
  Future<void> display(BuildContext context) async {
    List<Object> objects = notification.object as List;

    Ride r = await App.person.getUpcomingRideFromId(objects[0] as String);
    Ads.loadRewardedAd();
    if (r != null) {
      if ((objects[1] as bool) == true) {
        Navigator.of(context).pushNamed("/RideDetails", arguments: [
          r,
          Lang.getString(context, "Edit_Reservation"),
          (ride) {
            MyRidesTile.seatsLuggagePopUp(context, r);
          },
          false
        ]);
      } else {
        Navigator.of(context).pushNamed("/UpcomingRideDetails", arguments: [
          r,
          Lang.getString(context, "Edit_Ride"),
          (r) {
            return Navigator.pushNamed(context, "/EditRide", arguments: r);
          }
        ]);
      }
    }
  }
}
