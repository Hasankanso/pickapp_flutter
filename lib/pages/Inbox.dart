import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/ChatListTile.dart';
import 'package:pickapp/requests/GetPerson.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Spinner.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
  static Channel channel;
  static void subscribeToChannel() {
    print("subscribing to my messaging channel");
    if (channel != null) {
      channel.isJoined().then((joined) {
        if (!joined) {
          Backendless.messaging.subscribe(App.person.id).then((ch) {
            channel = ch;
            channel.addMessageListener(messageReceived);
          });
        }
      });
    } else {
      Backendless.messaging.subscribe(App.person.id).then((ch) {
        channel = ch;
        channel.addMessageListener(messageReceived);
      });
    }
  }

  static Future<void> messageReceived(Map message) async {
    Message msg = Message(
        senderId: message['senderId'].toString(),
        message: message['message'].toString(),
        date: DateTime.now(),
        myMessage: message['myMessage'].toString() == "true");

    print(msg.toString());

    Chat c = await Cache.getChat(msg.senderId);
    print(c);
    if (c != null) {
      c.addMessage(msg);
    } else {
      Request<Person> getUser = GetPerson(new Person(id: msg.senderId));
      await getUser.send(
          (Person p1, int p2, String p3) => personReceived(msg, p1, p2, p3));
    }
    App.newMessageInbox.value = true;
    App.newMessageInbox.notifyListeners();
  }

  static Chat personReceived(Message msg, Person p1, int p2, String p3) {
    if (p2 == 200) {
      Chat newChat = new Chat(
          id: p1.id,
          date: DateTime.now(),
          messages: new List<Message>(),
          person: p1,
          isNewMessage: false);
      newChat.addMessage(msg);
    }
  }
}

class _InboxState extends State<Inbox>
    with AutomaticKeepAliveClientMixin<Inbox> {
  Future<Box> box = Hive.openBox('chat');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
        future: box,
        builder: (BuildContext context, AsyncSnapshot<Box> snapshot) {
          return MainScaffold(
            appBar: MainAppBar(
              title: Lang.getString(context, "Chats"),
            ),
            body: Hive.isBoxOpen('chat') ? _Body(snapshot.data) : Spinner(),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _Body extends StatefulWidget {
  List<Chat> chats = List<Chat>();

  _Body(Box chatsBox) {
    if (chatsBox != null) {
      for (final chat in chatsBox.values) chats.add(chat);
    }
  }

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  ListController listController = new ListController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: App.newMessageInbox,
        builder: (BuildContext context, bool isLoggedIn, Widget child) {
          return ListBuilder(
              list: widget.chats,
              itemBuilder: ChatListTile.itemBuilder(
                  widget.chats,
                  (chat) => Navigator.of(context).pushNamed(
                        "/ExistingConversation",
                        arguments: chat,
                      ), (index) {
                PopUp.areYouSure(
                        Lang.getString(context, "Yes"),
                        Lang.getString(context, "No"),
                        Lang.getString(context, "Chat_delete_message"),
                        Lang.getString(context, "Warning!"),
                        Colors.red, (bool) {
                  if (bool == true) {
                    setState(() {
                      widget.chats.removeAt(index);
                    });
                  }
                }, highlightYes: true)
                    .confirmationPopup(context);
              }));
        });
  }
}
