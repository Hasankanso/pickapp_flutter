import 'package:just_miles/notifications/ScheduledNotification.dart';
import 'package:just_miles/repository/repository.dart';
import 'package:just_miles/repository/scheduledNotification/i_scheduled_notification_repository.dart';

class ScheduledNotificationRepository extends Repository<ScheduledNotification>
    implements IScheduledNotificationRepository {
  String notificationSettingsKey = "notificationSettings";
  String notificationIdKey = "notificationIdKey";
  String notificationDictKey = "notificationDictKey";
  int idLimit = 500;

  Future<int> setScheduledNotificationId(String objectId) async {
    var box = await Repository.openBox(notificationSettingsKey);
    int notificationId = box.get(notificationIdKey, defaultValue: 0);
    if (notificationId >= idLimit) {
      notificationId = -1;
    }
    notificationId += 1;
    await box.put(notificationIdKey, notificationId);

    var notificationD =
        box.get(notificationDictKey, defaultValue: new Map<String, int>());

    notificationD = Map<String, dynamic>.from(notificationD);

    notificationD[objectId] = notificationId;
    await box.put(notificationDictKey, notificationD);
    await box.close();
    return notificationId;
  }

  Future<bool> removeAllScheduledNotificationId() async {
    var box = await Repository.openBox(notificationSettingsKey);
    await box.delete(notificationIdKey);
    await box.delete(notificationDictKey);
    await box.close();
    return true;
  }

  Future<int> getScheduledNotificationId(String objectId) async {
    var box = await Repository.openBox(notificationSettingsKey);
    var notificationD =
        box.get(notificationDictKey, defaultValue: Map<String, dynamic>());
    notificationD = Map<String, dynamic>.from(notificationD);
    await box.close();
    return notificationD[objectId];
  }

  Future<bool> removeScheduledNotificationId(String objectId) async {
    var box = await Repository.openBox(notificationSettingsKey);
    var notificationD = box.get(notificationDictKey);
    notificationD = Map<String, int>.from(notificationD);
    notificationD.remove(objectId);
    await box.put(notificationDictKey, notificationD);
    await box.close();
    return true;
  }
}
