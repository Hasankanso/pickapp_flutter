import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/requests/GetPerson.dart';
import 'package:pickapp/requests/Request.dart';

class MessageNotificationHandler extends NotificationHandler {
  Message message;
  static const String action = "CHAT_MESSAGE";

  MessageNotificationHandler(MainNotification notification) : super(notification) {
    print("message received");
    Message message = Message.fromJson(notification.object);
    notification.object = message;
    this.message = message;
  }

  @override
  Future<void> cache() async {
    Chat chat = await Cache.getChat(message.senderId);

    if (chat == null || chat.person == null) {
      Request.initBackendless();
      Person person = await GetPerson(message.senderId).send((hi, bye, lay) => {});
      if (person == null) return;
      chat = new Chat(id: person.id, date: message.date, person: person, isNewMessage: true);
    }

    chat.addAndCacheMessage(message); //add message and cache Chat
  }

  @override
  void display(BuildContext context) {
    Cache.getChat(message.senderId).then((chat) {
      chat.initMessages().then((value) {
        assert(chat != null);
        Navigator.of(context).pushNamed("/Conversation", arguments: chat);
      });
    });
  }
}
