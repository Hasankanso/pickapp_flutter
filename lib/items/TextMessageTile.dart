import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/utilities/Responsive.dart';

class TextMessageTile extends StatelessWidget {

  Message msg;
  void Function(Message) onPressed;

  TextMessageTile({this.msg, this.onPressed});

  static Function(BuildContext, int) itemBuilder(List<Message> msgs, onPressed)  {
    return (context, index) {
      return TextMessageTile(msg : msgs[index], onPressed: onPressed);
    };
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(height: 40, child: Card(child: Container(child: Text(msg.message))));
  }
}
