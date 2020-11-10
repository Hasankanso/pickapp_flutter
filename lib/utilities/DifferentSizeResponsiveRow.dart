import 'package:flutter/widgets.dart';

class DifferentSizeResponsiveRow extends StatelessWidget {
  List<Widget> children;

  DifferentSizeResponsiveRow({List<Widget> children = const <Widget>[]}) {
    this.children = children;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = new List<Widget>(3 * children.length);

    int i = 0;
    for (Widget w in children) {
      spacedChildren[i] = Spacer();
      i++;
      spacedChildren[i] = w;
      i++;
      spacedChildren[i] = Spacer();
      i++;
    }
    return Row(children: spacedChildren);
  }
}