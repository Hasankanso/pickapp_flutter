import 'package:pickapp/dataObjects/Alert.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class BroadcastAlertNotificationHandler extends NotificationHandler {
  Alert alert;

  BroadcastAlertNotificationHandler(MainNotification notification)
      : super(notification) {
    if (!(notification.object is Alert)) {
      notification.object = Alert.fromJson(notification.object);
    }
    this.alert = notification.object;
  }

  @override
  Future<void> cache() async {}

  @override
  void display() {
    // TODO: implement display
  }
}
