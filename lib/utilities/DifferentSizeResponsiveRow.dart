import 'package:flutter/widgets.dart';

class DifferentSizeResponsiveRow extends StatelessWidget {
  List<Widget> children;

  DifferentSizeResponsiveRow({List<Widget> children = const <Widget>[]}) {
    this.children = children;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = new List<Widget>(3 * children.length);
    Size screen = MediaQuery.of(context).size;

    int i = 0;
    for (Widget w in children) {
      spacedChildren[i] = Spacer();
      i++;
      spacedChildren[i] = w;
      i++;
      spacedChildren[i] = Spacer();
      i++;
    }
    double space = screen.height / 20;
    return Padding(
        child: Row(children: spacedChildren),
        padding: EdgeInsets.fromLTRB(0, 0, 0, space));
  }
}
