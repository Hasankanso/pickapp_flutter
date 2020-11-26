import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/utilities/ChatListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class ChatPage extends StatelessWidget {
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
    if (!App.isLoggedIn) {
      return Login();
    }
    c1.person = p;
    c1.date = d;
    c2.person = p1;
    c2.date = d;
    c3.person = p2;
    c3.date = d;
    chatsList.add(c1);
    chatsList.add(c2);
    chatsList.add(c3);
    chatsList.add(c1);
    chatsList.add(c2);
    chatsList.add(c3);
    chatsList.add(c1);
    chatsList.add(c2);
    chatsList.add(c3);

    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Chats"),
      ),
      body: Container(
        child: ChatListBuilder(chatsList),
      ),
    );
  }
}
