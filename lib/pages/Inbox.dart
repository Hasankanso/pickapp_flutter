import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/ChatListTile.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
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

  static Future<Chat> loadOrCreateNewChat(
      Person person, String personId) async {
    var box;

    if (Hive.isBoxOpen('chat')) {
      box = Hive.box('chat');
    } else {
      box = await Hive.openBox('chat');
    }

    Chat c = box.get(personId) as Chat;
    if (c != null) {
      return c;
    } else {
      return new Chat(
          id: personId,
          date: DateTime.now(),
          messages: new List<Message>(),
          person: person,
          isNewMessage: false);
    }
  }

  static Future<void> messageReceived(Map message) {
    print("received message");

//TODO problem by parsing Message object
    Message msg = new Message(
        senderId: message['senderId'].toString(),
        message: message['message'].toString(),
        date: null,
        myMessage: message['myMessage'].toString() == "true");
//Message msg = Message.fromJson(message);
    print(msg.toString());
    loadOrCreateNewChat(null, msg.senderId)
        .then((value) => value.addMessage(msg));
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

class _Body extends StatelessWidget {
  Box chatsBox;

  _Body(this.chatsBox);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: chatsBox.length,
          itemBuilder: (context, index) {
            Chat c = chatsBox.getAt(index) as Chat;
            return ChatListTile(
                c,
                (chat) => Navigator.of(context)
                    .pushNamed("/ExistingConversation", arguments: chat));
          }),
    );
  }
}
