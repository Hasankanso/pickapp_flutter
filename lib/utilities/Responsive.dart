import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class ResponsiveRow extends StatelessWidget {
  List<Widget> children;
  int widgetRealtiveSize;

  ResponsiveRow(
      {List<Widget> children = const <Widget>[], widgetRealtiveSize = 6}) {
    this.children = children;
    this.widgetRealtiveSize = widgetRealtiveSize;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = new List<Widget>(3 * children.length);
    Size screen = MediaQuery.of(context).size;
    int i = 0;
    for (Widget w in children) {
      spacedChildren[i] = Spacer();
      i++;
      spacedChildren[i] = Expanded(flex: widgetRealtiveSize, child: w);
      i++;
      spacedChildren[i] = Spacer();
      i++;
    }
    double space = screen.height / 20;
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, space),
        child: Row(children: spacedChildren));
  }
}


class ResponsiveWidget extends StatelessWidget {
  double height = 0, width = 0;
  Widget child;

  ResponsiveWidget({this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ScreenUtil().setWidth(width), height : ScreenUtil().setHeight(height), child: child);
  }
}
