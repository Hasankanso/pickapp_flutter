import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/items/ChatListTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Spinner.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> with AutomaticKeepAliveClientMixin<Inbox> {
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
  List<Chat> chats = [];

  _Body(Box chatsBox) {
    if (chatsBox != null) {
      for (final Chat chat in chatsBox.values) {
        chat.messages = List<Message>.from(chat.messages);
        chats.add(chat);
      }
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
        valueListenable: App.updateInbox,
        builder: (BuildContext context, bool isLoggedIn, Widget child) {
          return ListBuilder(
              list: widget.chats,
              itemBuilder: ChatListTile.itemBuilder(
                  widget.chats,
                  (chat) => Navigator.of(context).pushNamed(
                        "/Conversation",
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
