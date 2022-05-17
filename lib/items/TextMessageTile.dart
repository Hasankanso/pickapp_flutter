import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Message.dart';
import 'package:just_miles/utilities/Responsive.dart';

class TextMessageTile extends StatelessWidget {
  final Message msg;
  void Function(Message) onPressed;

  TextMessageTile({this.msg, this.onPressed});

  static Function(BuildContext, int) itemBuilder(
      List<Message> msgs, onPressed) {
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
          color:
              msg.myMessage ? Color(0xffdcf8c6) : Theme.of(context).cardColor,
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
                            style: Styles.valueTextStyle(
                                color: msg.myMessage ? Colors.black : null),
                          ),
                          VerticalSpacer(
                            height: 3,
                          ),
                          Text(
                            DateFormat(App.hourFormat,
                                    Localizations.localeOf(context).toString())
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
