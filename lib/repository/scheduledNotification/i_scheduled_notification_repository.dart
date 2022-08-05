abstract class IScheduledNotificationRepository {
  Future<int> setScheduledNotificationId(String objectId);
  Future<bool> removeAllScheduledNotificationId();
  Future<int> getScheduledNotificationId(String objectId);
  Future<bool> removeScheduledNotificationId(String objectId);
}
