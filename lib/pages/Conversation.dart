import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/Message.dart';
import 'package:just_miles/items/TextMessageTile.dart';
import 'package:just_miles/notifications/MessageNotificationHandler.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';

class Conversation extends StatefulWidget {
  Chat _chat;

  Conversation(this._chat) {
    assert(_chat != null);
    this._chat = _chat;
  }

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController msgInputController = new TextEditingController();
  ScrollController _controller = new ScrollController();
  final focusNode = FocusNode();
  bool sendBtnDisabled = true;

  @override
  void initState() {
    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels != 0) {
          widget._chat.loadMessages(); //get one more chunk
          print("loading more messages if still");
          setState(() {});
        }
      }
    });
    super.initState();
  }

  String constructFCMPayload(String msg) {
    String name = App.person.firstName + " " + App.person.lastName;

    return jsonEncode({
      'registration_ids': [widget._chat.person.deviceToken],
      'data': {
        'action': MessageNotificationHandler.action,
        'dontCache': true,
        'object': {
          'senderId': App.person.id,
          'token': App.person.deviceToken,
          'message': msg,
          'name': name,
          'myMessage': false,
          'date': DateTime.now().toString(),
        }
      },
      'notification': {
        'title': name,
        'body': msg,
      },
    });
  }

  Future<void> sendPushMessage(BuildContext context, String msg) async {
    try {
      Response result = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA6JX9kus:APA91bHpaK5v4eMPWvWPVaivDGyZszwNklqUpyBn--0ZziJlXT6ZMJYMJ9zq7gv8CNSXNmSk8vPMmG10l00OzHI_vfCAIYvnDVlMbyYIduc1dhqXlf5O4jAr-siCuZ_Ox0O5HPqbgiht',
        },
        body: constructFCMPayload(msg),
      );

      if (result.statusCode == HttpStatus.ok &&
          json.decode(result.body)["success"] > 0) {
        print('FCM request for device sent!');
        widget._chat.addAndCacheMessage(Message(
            senderId: App.person.id,
            message: msg,
            myMessage: true,
            date: DateTime.now()));
        setState(() {});
      } else {
        print("error:" + result.statusCode.toString());
      }
    } catch (e) {
      CustomToast().showErrorToast(Lang.getString(context, "Something_Wrong"));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title:
            widget._chat.person.firstName + " " + widget._chat.person.lastName,
      ),
      body: ValueListenableBuilder(
          valueListenable: App.updateConversation,
          builder: (BuildContext context, bool isLoggedIn, Widget child) {
            var messages = List<Message>.from(widget._chat.messages.reversed);
            return ListBuilder(
              reverse: true,
              list: messages,
              controller: _controller,
              itemBuilder: TextMessageTile.itemBuilder(messages, null),
            );
          }),
      bottomNavigationBar: Card(
        margin: EdgeInsets.only(bottom: 1),
        elevation: 20,
        child: Row(
          children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 30,
              child: TextFormField(
                focusNode: focusNode,
                controller: msgInputController,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                onFieldSubmitted: (value) {
                  if (!sendBtnDisabled) sendMessage();
                },
                onChanged: (text) {
                  if ((text.length > 0 && text.trim().length != 0) &&
                      sendBtnDisabled) {
                    setState(() {
                      sendBtnDisabled = false;
                    });
                  } else if ((text.length <= 0 || text.trim().length == 0) &&
                      !sendBtnDisabled) {
                    setState(() {
                      sendBtnDisabled = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: Lang.getString(context, "Type_a_message"),
                  suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.send,
                        size: Styles.largeIconSize(),
                      ),
                      color: Styles.primaryColor(),
                      tooltip: null,
                      onPressed: !sendBtnDisabled ? sendMessage : null),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage() {
    sendPushMessage(context, msgInputController.text);
    setState(() {
      msgInputController.text = "";
      sendBtnDisabled = true;
    });
  }
}
