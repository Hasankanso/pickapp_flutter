import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/notifications/PushNotificationsManager.dart';

class NotificationListTile extends ListTile {
  final MainNotification notification;
  NotificationListTile(this.notification);

  static Function(BuildContext, int) itemBuilder(List<MainNotification> n) {
    return (context, index) {
      return NotificationListTile(n[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    NotificationHandler handler =
        PushNotificationsManager.createNotificationHandler(notification);
    return Card(
      elevation: 1.0,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        onTap: () async {
          if (handler != null) await handler.display(context);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: Styles.headerTextStyle(),
            ),
          ],
        ),
        subtitle: Text(
          notification.body,
          style: Styles.valueTextStyle(),
        ),
      ),
    );
  }
}
