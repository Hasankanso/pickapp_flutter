import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/PopUp.dart';

class ChatListTile extends ListTile {
  final Object o;

  ChatListTile(this.o);

  static Function(BuildContext, int) itemBuilder(List<Chat> c) {
    return (context, index) {
      return ChatListTile(c[index]);
    };
  }

  void deletionResponse(bool result) {
    if (result) {
      CustomToast().showShortToast("Deletion Cancelled !", backgroundColor :Colors.red);
    } else {
      CustomToast()
          .showShortToast("Ride Deleted Successfully", backgroundColor :Colors.greenAccent);
    }
  }

  void cc(String item) {
    CustomToast().showShortToast("You clicked : " + item, backgroundColor :Colors.blue);
  }

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
  void clicked(bool status){
  }
}
