import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:pickapp/requests/GetPerson.dart';
import 'package:pickapp/requests/Request.dart';

class MessageNotificationHandler extends NotificationHandler {
  Message message;
  static const String action = "CHAT_MESSAGE";

  MessageNotificationHandler(MainNotification notification)
      : super(notification) {
    print("message received");
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
      Person person =
          await GetPerson(message.senderId).send((hi, bye, lay) => {});
      if (person == null) return;
      chat = new Chat(
          id: person.id,
          date: message.date,
          person: person,
          isNewMessage: true);
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
