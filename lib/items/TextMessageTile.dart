import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/utilities/Responsive.dart';

class TextMessageTile extends StatelessWidget {
  Message msg;
  void Function(Message) onPressed;

  TextMessageTile({this.msg, this.onPressed});

  static Function(BuildContext, int) itemBuilder(List<Message> msgs, onPressed) {
    return (context, index) {
      return TextMessageTile(msg: msgs[index], onPressed: onPressed);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: msg.myMessage ? Alignment.centerRight : Alignment.centerLeft,
        constraints: BoxConstraints(
          minHeight: ScreenUtil().setHeight(40),
          minWidth: ScreenUtil().setWidth(10),
          maxWidth: ScreenUtil().setWidth(300),
        ),
        child: Card(
          color: msg.myMessage ? Colors.lightGreen.shade400 : Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.message,
                            style: Styles.valueTextStyle(),
                          ),
                          VerticalSpacer(
                            height: 3,
                          ),
                          Text(
                            DateFormat(App.hourFormat, Localizations.localeOf(context).toString())
                                .format(msg.date),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              color: Styles.labelColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
