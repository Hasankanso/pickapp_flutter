import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/RideRoute.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RouteTile extends ListTile {
  final Object o;
  Function(String) callBack;

  RouteTile(this.o, this.callBack);

  static Function(BuildContext, int) itemBuilder(List<RideRoute> c, callBack) {
    return (context, index) {
      return RouteTile(c[index], callBack);
    };
  }

  @override
  Widget build(BuildContext context) {
    RideRoute r = o;
    if (r.name.length >= 32) {
      r.name = r.name.substring(0, 35)+"...";
    }
    return ResponsiveWidget.fullWidth(
      height: 70,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.grey[50],
        shadowColor: Styles.primaryColor(),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.timeline,
                size: Styles.mediumIconSize(), color: Styles.primaryColor()),
          ),
          title: Row(
            children: [
              Text(
                r.name,
                style: Styles.valueTextStyle(),
              )
            ],
          ),
          onTap: () {
            callBack(r.points);
          },
        ),
      ),
    );
  }
}
