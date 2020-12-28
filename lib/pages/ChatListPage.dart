import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/items/ChatListTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}


class _ChatListPageState extends State<ChatListPage>
    with AutomaticKeepAliveClientMixin<ChatListPage> {

  static Channel myChannel;
  static bool newMessageReceived = false;

  @override
  void initState(){
    Backendless.messaging.subscribe(App.person.id).then((ch) {
      ch.addMessageListener<String>(messageReceived);
      myChannel = ch;
    });
  }

  Future<void> messageReceived(String message){
    print("message received");
    print(message);
    //TODO store message in hive, and update state, here.
  }


  DateTime d = DateTime.now();

  Person p = new Person.name("Ali", "Loubani");

  Person p1 = new Person.name("Adel", "Kanso");

  Person p2 = new Person.name("Hassan", "Kanso");

  final List<Chat> chatsList = new List();

  Chat c1 = new Chat();

  Chat c2 = new Chat();

  Chat c3 = new Chat();

  @override
  Widget build(BuildContext context) {
    c1.person = p;
    c1.date = d;
    c1.addMessage("hiii");

    c2.person = p1;
    c2.date = d;
    c2.addMessage("pinki");
    c3.person = App.person;
    c3.date = d;
    c3.addMessage("pinko");
    chatsList.add(c1);
    chatsList.add(c2);
    chatsList.add(c3);
    return ValueListenableBuilder(
      builder: (BuildContext context, bool isLoggedIn, Widget child) {
        if (!isLoggedIn) {
          return LoginRegister();
        }
        return MainScaffold(
          appBar: MainAppBar(
            title: Lang.getString(context, "Chats"),
          ),
          body: Container(
            child: ListBuilder(
              list: chatsList,
              itemBuilder: ChatListTile.itemBuilder(chatsList, OnPressed),
            ),
          ),
        );
      },
      valueListenable: App.isLoggedInNotifier,
    );
  }

  void OnPressed(Chat c) {
    Navigator.of(context).pushNamed("/Conversation", arguments: c);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
