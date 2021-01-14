import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/TextMessageTile.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class Conversation extends StatefulWidget {
  ValueNotifier<Chat> chatNotifier = new ValueNotifier(null);
  Conversation({Chat chat}) {
    assert(chat != null);
    this.chatNotifier.value = chat;
  }


  Conversation.from({Person person}) {
    assert(person != null);
    Inbox.loadOrCreateNewChat(person, person.id).then((value) => this.chatNotifier.value = value);
  }

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController msgInputController = new TextEditingController();


  void sendMessage() {
    String text = msgInputController.text;
    if(text.isEmpty) return;
    Chat c = widget.chatNotifier.value;
    String targetId = c.person.id;

    Message msg = new Message(senderId: App.person.id, message : text, myMessage: true);

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
    });
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<Chat>(
      valueListenable: widget.chatNotifier,
      builder: (BuildContext context, Chat chat, Widget child) {
        return chat == null ? Spinner() : MainScaffold(
          appBar: MainAppBar(
            title: chat.person.firstName + " " +
                chat.person.lastName,
          ),
          body: ListBuilder(
            list: chat.messages,
            itemBuilder: TextMessageTile.itemBuilder(
                chat.messages, null),
          ),
          bottomNavigationBar: ResponsiveWidget.fullWidth(
            height: 120,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: msgInputController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      filled: true,
                      prefixIcon: Icon(
                        Icons.account_box,
                        size: 28.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child:
                    RaisedButton(child: Text("Send"), onPressed: sendMessage)),
              ],
            ),
          ),
        );
      }
    );
  }
}
