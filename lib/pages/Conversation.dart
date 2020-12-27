import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:conversation/widgets/conversation_input_widget.dart';
import 'package:conversation/widgets/conversation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/TextMessageTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Conversation extends StatefulWidget {
  final Chat chat;

  Conversation({this.chat});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController msgInputController = new TextEditingController();

  void addMessage(chatMessage) {
    setState(() {
      widget.chat.addMessage(chatMessage);
    });
  }

  void sendMessage() {


    Backendless.messaging.publish(msgInputController.text,
        channelName: widget.chat.person.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    Person person = widget.chat.person;

    return MainScaffold(
      appBar: MainAppBar(
        title: person.firstName + " " + person.lastName,
      ),
      body: ListBuilder(
        list: widget.chat.messages,
        itemBuilder: TextMessageTile.itemBuilder(widget.chat.messages, null),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 120,
        child: Row(
          children: [
            Expanded(flex : 5,
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
            Expanded(flex : 1, child: RaisedButton(child: Text("Send"), onPressed: sendMessage)),
          ],
        ),
      ),
    );
  }
}
