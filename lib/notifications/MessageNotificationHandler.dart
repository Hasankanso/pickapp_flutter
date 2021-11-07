import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/Message.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';
import 'package:just_miles/pages/Inbox.dart';
import 'package:just_miles/requests/GetPerson.dart';
import 'package:just_miles/requests/Request.dart';

class MessageNotificationHandler extends NotificationHandler {
  Message message;
  static const String action = "CHAT_MESSAGE";

  MessageNotificationHandler(MainNotification notification) : super(notification) {
    message = Message.fromJson(notification.object);
    notification.object = message;
  }

  @override
  Future<void> updateApp() async {
    App.updateConversation.value = !App.updateConversation.value;
    App.updateInbox.value = !App.updateInbox.value;
    App.isNewMessageNotifier.value = true;
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
    await chat.addAndCacheMessage(message); //add message and cache Chat
  }

  @override
  Future<void> display(BuildContext context) {
    Cache.getChat(message.senderId).then((chat) {
      assert(chat != null);
      Inbox.openChat(chat, context);
    });
  }
}
