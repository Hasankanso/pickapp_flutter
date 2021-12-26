import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Spinner.dart';

class ChatListTile extends ListTile {
  final Chat chat;
  final Function(Chat) onPressed;
  final List<Chat> c;
  final int index;
  final Function(int, Chat) onDismiss;

  ChatListTile(this.chat, this.onPressed, this.c, this.index, this.onDismiss);

  static Function(BuildContext, int) itemBuilder(
      List<Chat> c, onPressed, onDismiss) {
    return (context, index) {
      return ChatListTile(c[index], onPressed, c, index, onDismiss);
    };
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String _locale = Localizations.localeOf(context).toString();

    return ValueListenableBuilder(
        valueListenable: chat.newMessage,
        builder: (BuildContext context, String newMessage, Widget child) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Card(
              child: ListTile(
                onTap: () async {
                  if (onPressed != null) {
                    onPressed(chat);
                  }
                },
                leading: Validation.isNullOrEmpty(chat.person.profilePictureUrl)
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: ScreenUtil().setSp(20),
                        backgroundImage: AssetImage("lib/images/user.png"),
                      )
                    : CachedNetworkImage(
                        httpHeaders: Request.getImageHeader,
                        imageUrl: chat.person.profilePictureUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: ScreenUtil().setSp(20),
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: ScreenUtil().setSp(20),
                          child: Spinner(),
                        ),
                        errorWidget: (context, url, error) {
                          return CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: ScreenUtil().setSp(20),
                            backgroundImage: AssetImage("lib/images/user.png"),
                          );
                        },
                      ),
                title: Text(chat.person.firstName + " " + chat.person.lastName),
                subtitle: chat.lastMessage != null
                    ? Text(
                        chat.lastMessage.message,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: chat.lastMessage != null
                    ? Column(
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Text(
                                now.difference(chat.lastMessage.date).inHours <
                                        12
                                    ? DateFormat(App.hourFormat, _locale)
                                        .format(chat.lastMessage.date)
                                    : isSameDate(now, chat.lastMessage.date)
                                        ? Lang.getString(context, "Now")
                                        : now.year == chat.lastMessage.date.year
                                            ? DateFormat("dd.MM", _locale)
                                                .format(chat.lastMessage.date)
                                            : DateFormat(
                                                    App.birthdayFormat, _locale)
                                                .format(chat.lastMessage.date)),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: Lang.getString(context, "Delete"),
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => onDismiss(index, chat),
              ),
            ],
          );
        });
  }

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
