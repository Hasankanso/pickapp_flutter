import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/RideRoute.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RouteTile extends StatefulWidget {
  final RideRoute r;
  Function(String) callBack;
  final int index1;
  Function showHide;
  ListController listController;

  RouteTile(this.r, this.callBack, this.index1, this.listController);

  static Function(BuildContext, int) itemBuilder(
      List<RideRoute> c, callBack, ListController listController) {
    return (context, index) {
      return RouteTile(c[index], callBack, index, listController);
    };
  }

  @override
  _RouteTileState createState() => _RouteTileState(callBack);
}

class _RouteTileState extends State<RouteTile> {
  final Function callback;

  _RouteTileState(
    this.callback,
  );

  @override
  Widget build(BuildContext context) {
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
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          selected: widget.index1 == widget.listController.selected,
          leading: Icon(
            Icons.timeline,
            size: Styles.mediumIconSize(),
            color: Styles.primaryColor(),
          ),
          title: Text(
            r.name,
            style: Styles.valueTextStyle(),
          ),
          onTap: () {
            callback(r.points);
            setState(() {
              widget.listController.selected = widget.index1;
            });
          },
        ),
      ),
    );
  }
}
