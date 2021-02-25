import 'dart:async';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/TextMessageTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Conversation extends StatefulWidget {
  Chat chat;
  Conversation({Chat chat}) {
    assert(chat != null);
    this.chat = chat;
  }

  Conversation.from({Person person}) {
    assert(person != null);
    loadOrCreateNewChat(person, person.id);
  }

  Future<Chat> loadOrCreateNewChat(Person person, String personId) async {
    Chat chat = await Cache.getChat(personId);

    if (chat == null) {
      chat = Chat(
          id: personId,
          date: DateTime.now(),
          messages: new List<Message>(),
          person: person,
          isNewMessage: false);
    }
    this.chat = chat;
  }

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController msgInputController = new TextEditingController();
  ScrollController _controller = new ScrollController();
  final focusNode = FocusNode();
  void sendMessage() {
    String text = msgInputController.text;
    msgInputController.text = "";
    if (text.isEmpty) return;
    Chat c = widget.chat;
    String targetId = c.person.id;

    Message msg =
        Message(senderId: App.person.id, message: text, myMessage: true);

    print("Sending " + msg.toJson().toString() + " to " + c.person.firstName);
    Backendless.messaging
        .publish(msg.toJson(), channelName: targetId)
        .then((value) {
      switch (value.status) {
        case PublishStatusEnum.PUBLISHED:
          {
            setState(() {
              c.addMessage(msg);
            });
            print("message sent");
          }
          break;

        case PublishStatusEnum.FAILED:
          {
            print("Failed");
          }
          break;

        case PublishStatusEnum.CANCELLED:
          {
            print("message canceled before getting sent.");
          }
          break;

        case PublishStatusEnum.UNKNOWN:
          {
            print("it's unkown if the message has been sent or not");
          }
          break;

        case PublishStatusEnum.SCHEDULED:
          {
            setState(() {
              c.addMessage(msg);
            });
            print("message scheduled");
          }
          break;

        default:
          {
            print("Something else");
          }
          break;
      }
      App.refreshInbox.value = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    msgInputController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    App.refreshInbox.value = false;
    return MainScaffold(
      appBar: MainAppBar(
        title: widget.chat.person.firstName + " " + widget.chat.person.lastName,
      ),
      body: ValueListenableBuilder(
          valueListenable: App.refreshInbox,
          builder: (BuildContext context, bool isLoggedIn, Widget child) {
            return ListBuilder(
              list: widget.chat.messages,
              controller: _controller,
              itemBuilder:
                  TextMessageTile.itemBuilder(widget.chat.messages, null),
            );
          }),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            flex: 5,
            child: Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 20,
              child: TextFormField(
                focusNode: focusNode,
                controller: msgInputController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  prefixIcon: Icon(
                    Icons.account_box,
                    size: Styles.largeIconSize(),
                  ),
                  suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.send,
                        size: Styles.largeIconSize(),
                      ),
                      color: Styles.primaryColor(),
                      tooltip: null,
                      onPressed: () {
                        focusNode.unfocus();
                        // Disable text field's focus node request
                        focusNode.canRequestFocus = false;

                        sendMessage();

                        Future.delayed(Duration.zero, () {
                          focusNode.canRequestFocus = true;
                        });
                      }),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Styles.primaryColor(), width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
