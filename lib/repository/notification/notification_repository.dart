import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/PushNotificationsManager.dart';
import 'package:just_miles/repository/notification/i_notification_repository.dart';
import 'package:just_miles/repository/repository.dart';

class NotificationRepository extends Repository<MainNotification>
    implements INotificationRepository {
  @override
  Future<bool> insert(MainNotification object) async {
    if (object == null) {
      return false;
    }
    try {
      String boxName = this.boxName[MainNotification];
      var box = await Repository.openBox(boxName);

      List<MainNotification> listToSave = [];

      var savedObjects = box.get(boxName);
      if (savedObjects != null)
        savedObjects = savedObjects.cast<MainNotification>();
      List<MainNotification> listObjects = savedObjects;
      if (listObjects != null) listToSave.addAll(listObjects);
      listToSave.add(object);
      while (listToSave.length > PushNotificationsManager.MAX_NOTIFICATIONS) {
        listToSave.removeAt(0);
      }
      await box.put(boxName, listToSave);
      await box.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}
