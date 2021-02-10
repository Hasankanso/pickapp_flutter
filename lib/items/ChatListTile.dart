import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/utilities/Spinner.dart';

class ChatListTile extends StatelessWidget {
  final Chat chat;
  Function(Chat) onPressed;
  List<Chat> c;
  int index;
  Function(int) onDismiss;

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
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Card(
        child: ListTile(
          onTap: () {
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
          subtitle: Text(
            chat.messages.last.message,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: Text(now
                            .difference(
                                chat.messages[chat.messages.length - 1].date)
                            .inHours <
                        12
                    ? DateFormat(App.hourFormat, _locale)
                        .format(chat.messages[chat.messages.length - 1].date)
                    : isSameDate(
                            now, chat.messages[chat.messages.length - 1].date)
                        ? Lang.getString(context, "Now")
                        : now.year ==
                                chat.messages[chat.messages.length - 1].date
                                    .year
                            ? DateFormat("dd.MM", _locale).format(
                                chat.messages[chat.messages.length - 1].date)
                            : DateFormat(App.birthdayFormat, _locale).format(
                                chat.messages[chat.messages.length - 1].date)),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: Lang.getString(context, "Delete"),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => onDismiss(index),
        ),
      ],
    );
  }

  void clicked(bool status) {}

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
