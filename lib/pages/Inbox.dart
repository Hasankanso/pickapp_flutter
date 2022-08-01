import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/items/ChatListTile.dart';
import 'package:just_miles/repository/chat/chat_repository.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/PopUp.dart';
import 'package:just_miles/utilities/Spinner.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();

  static Future<void> openChat(Chat chat, context) async {
    await chat.initMessages();
    Navigator.of(context).pushNamed(
      "/Conversation",
      arguments: chat,
    );
  }

  static Future<Chat> getChat(Person person) async {
    Chat chat = await ChatRepository().getChat(person.id,
        toStoreChat:
            new Chat(id: person.id, person: person, isNewMessage: false));
    return chat;
  }
}

class _InboxState extends State<Inbox>
    with AutomaticKeepAliveClientMixin<Inbox> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: App.updateInbox,
        builder: (BuildContext context, bool isLoggedIn, Widget child) {
          Future<List<Chat>> chats = ChatRepository().getChats();
          return FutureBuilder<List<Chat>>(
              future: chats,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
                return MainScaffold(
                  appBar: MainAppBar(
                    title: Lang.getString(context, "Inbox"),
                  ),
                  body: snapshot.hasData ? _Body(snapshot.data) : Spinner(),
                );
              });
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _Body extends StatefulWidget {
  final List<Chat> chats;

  _Body(this.chats);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  ListController listController = new ListController();

  @override
  Widget build(BuildContext context) {
    return ListBuilder(
        list: widget.chats,
        itemBuilder: ChatListTile.itemBuilder(
            widget.chats, (chat) => Inbox.openChat(chat, context),
            (int index, Chat chat) {
          PopUp.areYouSure(
                  Lang.getString(context, "Yes"),
                  Lang.getString(context, "No"),
                  Lang.getString(context, "Chat_delete_message"),
                  Lang.getString(context, "Warning!"),
                  Colors.red, (bool) {
            if (bool == true) {
              ChatRepository().deleteChat(chat.id);
              setState(() {
                widget.chats.removeAt(index);
              });
            }
          }, highlightYes: true)
              .confirmationPopup(context);
        }));
  }
}
