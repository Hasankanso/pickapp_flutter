import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Spinner.dart';

class ChatListTile extends ListTile {
  final Object o;
  Function(Chat) onPressed;

  ChatListTile(this.o, this.onPressed);

  static Function(BuildContext, int) itemBuilder(List<Chat> c, onPressed) {
    return (context, index) {
      return ChatListTile(c[index], onPressed);
    };
  }

  void deletionResponse(bool result) {
    if (result) {
      CustomToast()
          .showShortToast("Deletion Cancelled !", backgroundColor: Colors.red);
    } else {
      CustomToast().showShortToast("Ride Deleted Successfully",
          backgroundColor: Colors.greenAccent);

    }
  }

  void cc(String item) {
    CustomToast()
        .showShortToast("You clicked : " + item, backgroundColor: Colors.blue);
  }

/*
  @override
  Widget build(BuildContext context) {
    Chat r = o;
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Styles.primaryColor(),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: Styles.primaryColor(),
          child: Icon(
            Icons.person,
            size: Styles.mediumIconSize(),
            color: Styles.valueColor(),
          ),
        ),
        title: Text(
          r.person.firstName + " " + r.person.lastName,
          style: Styles.valueTextStyle(),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hellooooooo  Itss meeeeee",
                    style: Styles.subValueTextStyle(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    r.date.day.toString() +
                        "/" +
                        r.date.month.toString() +
                        "/" +
                        r.date.year.toString() +
                        "     " +
                        r.date.hour.toString() +
                        ":" +
                        r.date.minute.toString() +
                        " PM",
                    style: Styles.subValueTextStyle(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                    PopUp.areYouSure("Cancel", "Submit", "Are you sure you want to Submit ??", "Activate !!", Colors.greenAccent,clicked,interest: false).confirmationPopup(context);
                    },
                    icon: Icon(Icons.delete, color: Colors.red[500]),
                  )
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          cc(r.person.firstName);
        },
      ),
    );
  }
 */
  @override
  Widget build(BuildContext context) {
    Chat chat = o;
    DateTime now = DateTime.now();

    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed(chat);
        }
      },


      leading:CachedNetworkImage(
        imageUrl: chat.person.profilePictureUrl ?? "",
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
      title: Row(
        children: <Widget>[
          Text(chat.person.firstName + " " + chat.person.lastName),
          SizedBox(
            width: 16.0,
          ),
          Text(now.difference(chat.date).inHours < 12
              ? DateFormat(App.hourFormat).format(chat.date)
              : isSameDate(now, chat.date)
                  ? Lang.getString(context, "Today")
                  : now.year == chat.date.year
                      ? DateFormat("dd.MM").format(chat.date)
                      : DateFormat(App.birthdayFormat).format(chat.date)),
        ],
      ),
      subtitle: Text(chat.messages.last.message),
      trailing: Icon(
        Icons.arrow_forward_ios,
      ),
    );
  }

  void clicked(bool status) {}

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
