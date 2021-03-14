import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class MessageNotificationHandler extends NotificationHandler{

  Message message;

  MessageNotificationHandler(MainNotification notification) : super(notification) {

    Message message = Message.fromJson(notification.object);
    notification.object = message;
    this.message = message;
  }

  @override
  void cache() async {
    Chat chat = await Cache.getChat(message.senderId);
    chat.addMessage(message);
  }

  @override
  void display(NavigatorState state) {
    // TODO: implement display
  }

  @override
  void updateApp() {
    App.updateUpcomingRide.value = true;
  }
}
