import 'package:just_miles/notifications/MainNotification.dart';

abstract class INotificationRepository {
  Future<bool> insert(MainNotification mainNotification);
}
