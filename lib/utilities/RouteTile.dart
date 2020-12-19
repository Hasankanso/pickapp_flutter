import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/RideRoute.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RouteTile extends StatefulWidget {
  final RideRoute r;
  Function(String) callBack;
  final int index1;

  RouteTile(this.r, this.callBack, this.index1);

  static Function(BuildContext, int) itemBuilder(List<RideRoute> c, callBack) {
    return (context, index) {
      return RouteTile(c[index], callBack, index);
    };
  }

  @override
  _RouteTileState createState() => _RouteTileState(callBack);
}

class _RouteTileState extends State<RouteTile> {
  final Function callback;
  int _selectedIndex;

  _RouteTileState(
    this.callback,
  );

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.index1 == _selectedIndex;
    var r = widget.r;
    if (r.name.length >= 25) {
      r.name = r.name.substring(0, 25) + "...";
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
          selected: isSelected,
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
            callback(r.points);
            _selectedIndex = widget.index1;
            setState(() {});
          },
        ),
      ),
    );
  }
}
