import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/utilities/ChatListTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
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
    c2.person = p1;
    c2.date = d;
    c3.person = p2;
    c3.date = d;
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
              itemBuilder: ChatListTile.itemBuilder(chatsList),
            ),
          ),
        );
      },
      valueListenable: App.isLoggedInNotifier,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
