import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/MyRidesTile.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

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
