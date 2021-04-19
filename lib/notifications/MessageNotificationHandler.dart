import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class MessageNotificationHandler extends NotificationHandler {
  Message message;

  MessageNotificationHandler(MainNotification notification) : super(notification) {
    Message message = Message.fromJson(notification.object);
    notification.object = message;
    this.message = message;
  }

  @override
  Future<void> cache() async {
    Chat chat = await Cache.getChat(message.senderId);
    chat.addMessage(message);
  }

  @override
  void display() {
    // TODO: implement display
  }
}
