import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/screenutil.dart';

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final int flex;

  ResponsiveRow({this.children = const <Widget>[], this.flex = 6});

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = new List<Widget>.filled(3 * children.length, null);

    int i = 0;
    for (Widget w in children) {
      spacedChildren[i] = Spacer();
      i++;
      spacedChildren[i] = Expanded(flex: flex, child: w);
      i++;
      spacedChildren[i] = Spacer();
      i++;
    }
    return Row(children: spacedChildren);
  }
}

class ResponsiveWidget extends StatelessWidget {
  double height = 0, width = 0;
  final Widget child;

  ResponsiveWidget({width, height, this.child}) {
    this.width = ScreenUtil().setWidth(width);
    this.height = ScreenUtil().setHeight(height);
  }

  ResponsiveWidget.fullWidth({height, this.child}) {
    this.width = ScreenUtil().screenWidth;
    this.height = ScreenUtil().setHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: this.width, height: this.height, child: child);
  }
}

class VerticalSpacer extends StatelessWidget {
  final double height;

  VerticalSpacer({this.height = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: ScreenUtil().setHeight(height));
  }
}

class ResponsiveSpacer extends StatelessWidget {
  final double width, height;

  ResponsiveSpacer({this.width = 0, this.height = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: ScreenUtil().setWidth(width), height: ScreenUtil().setHeight(height));
  }
}

class DifferentSizeResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  DifferentSizeResponsiveRow({this.children});

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = new List<Widget>.filled(3 * children.length, null);

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
