import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/ChatListTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Spinner.dart';

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
    Chat chat = await Cache.getChat(person.id,
        toStoreChat: new Chat(id: person.id, person: person, isNewMessage: false));
    return chat;
  }
}

class _InboxState extends State<Inbox> with AutomaticKeepAliveClientMixin<Inbox> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: App.updateInbox,
        builder: (BuildContext context, bool isLoggedIn, Widget child) {
          Future<List<Chat>> chats = Cache.getChats();
          App.updateInbox.value = false;
          return FutureBuilder<List<Chat>>(
              future: chats,
              builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
                return MainScaffold(
                  appBar: MainAppBar(
                    title: Lang.getString(context, "Chats"),
                  ),
                  body: snapshot.data != null ? _Body(snapshot.data) : Spinner(),
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
        itemBuilder: ChatListTile.itemBuilder(widget.chats, (chat) => Inbox.openChat(chat, context),
            (int index, Chat chat) {
          PopUp.areYouSure(
                  Lang.getString(context, "Yes"),
                  Lang.getString(context, "No"),
                  Lang.getString(context, "Chat_delete_message"),
                  Lang.getString(context, "Warning!"),
                  Colors.red, (bool) {
            if (bool == true) {
              Cache.clearHiveChat(chat.id);
              setState(() {
                widget.chats.removeAt(index);
              });
            }
          }, highlightYes: true)
              .confirmationPopup(context);
        }));
  }
}
