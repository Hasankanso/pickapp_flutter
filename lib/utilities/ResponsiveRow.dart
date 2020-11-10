import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class ResponsiveRow extends StatelessWidget {
  List<Widget> children;
  int widget_realtive_Size;

  ResponsiveRow(
      {List<Widget> children = const <Widget>[], widget_realtive_Size = 6}) {
    this.children = children;
    this.widget_realtive_Size = widget_realtive_Size;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = new List<Widget>(3 * children.length);
    Size screen = MediaQuery.of(context).size;
    int i = 0;
    for (Widget w in children) {
      spacedChildren[i] = Spacer();
      i++;
      spacedChildren[i] = Expanded(flex: widget_realtive_Size, child: w);
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
