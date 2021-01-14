
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/ChatListTile.dart';
import 'package:pickapp/requests/GetPerson.dart';
import 'package:pickapp/requests/Request.dart';
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

  static Future<Chat> loadOrCreateNewChat(Person person, String personId,
      {Message msg}) async {
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
      Request<Person> getUser = GetPerson(new Person(id: personId));
      await getUser.send(
          (Person p1, int p2, String p3) => personReceived(msg, p1, p2, p3));
      return null;
    }
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

  static Future<void> messageReceived(Map message) {
    print("received message");

//TODO problem by parsing Message object
    Message msg = new Message(
        senderId: message['senderId'].toString(),
        message: message['message'].toString(),
        date: null,
        myMessage: message['myMessage'].toString() == "true");

    print(msg.toString());
    loadOrCreateNewChat(null, msg.senderId, msg: msg);
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
