import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickapp/classes/App.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init({context}) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          App.isNewNotificationNotifier.value = true;
          print("appInForeground: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          App.isNewNotificationNotifier.value = true;
          App.navKey.currentState.pushNamed("/Notifications");
          print("appTerminated: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          App.isNewNotificationNotifier.value = true;
          App.navKey.currentState.pushNamed("/Notifications");
          print("appInBackground: $message");
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}
