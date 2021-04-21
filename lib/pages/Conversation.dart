import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/items/TextMessageTile.dart';
import 'package:pickapp/notifications/MessageNotificationHandler.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Conversation extends StatefulWidget {
  Chat chat;

  Conversation({Chat chat}) {
    assert(chat != null);
    this.chat = chat;
  }

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController msgInputController = new TextEditingController();
  ScrollController _controller = new ScrollController();
  final focusNode = FocusNode();

  String constructFCMPayload(String msg) {
    String name = App.person.firstName + " " + App.person.lastName;

    return jsonEncode({
      'registration_ids': [widget.chat.person.deviceToken],
      'data': {
        'action': MessageNotificationHandler.action,
        'object': {
          'senderId': App.person.id,
          'message': msg,
          'name': name,
          'myMessage': false,
          'date': DateTime.now().toString(),
        }
      },
      'notification': {
        'title': 'Message',
        'body': '$name sent you a message',
      },
    });
  }

  Future<void> sendPushMessage() async {
    String msg = msgInputController.text;
    try {
      await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA6JX9kus:APA91bHpaK5v4eMPWvWPVaivDGyZszwNklqUpyBn--0ZziJlXT6ZMJYMJ9zq7gv8CNSXNmSk8vPMmG10l00OzHI_vfCAIYvnDVlMbyYIduc1dhqXlf5O4jAr-siCuZ_Ox0O5HPqbgiht',
        },
        body: constructFCMPayload(msg),
      );
      print('FCM request for device sent!');
      msgInputController.text = "";
      widget.chat.cacheMessage(
          Message(senderId: App.person.id, message: msg, myMessage: true, date: DateTime.now()));
      setState(() {});
    } catch (e) {
      CustomToast().showErrorToast(Lang.getString(context, "Something_Wrong"));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    App.updateInbox.value = false;
    return MainScaffold(
      appBar: MainAppBar(
        title: widget.chat.person.firstName + " " + widget.chat.person.lastName,
      ),
      body: ValueListenableBuilder(
          valueListenable: App.updateConversation,
          builder: (BuildContext context, bool isLoggedIn, Widget child) {
            App.updateConversation.value = false;
            var messages = List<Message>.from(widget.chat.messages.reversed);
            return ListBuilder(
              reverse: true,
              list: messages,
              controller: _controller,
              itemBuilder: TextMessageTile.itemBuilder(messages, null),
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
                        sendPushMessage();

                        Future.delayed(Duration.zero, () {
                          focusNode.canRequestFocus = true;
                        });
                      }),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Styles.primaryColor(), width: 2),
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
