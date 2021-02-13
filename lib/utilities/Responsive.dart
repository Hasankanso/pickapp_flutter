import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/screenutil.dart';

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
    return Row(children: spacedChildren);
  }
}

class ResponsiveWidget extends StatelessWidget {
  double height = 0, width = 0;
  Widget child;

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
  double height = 10;
  VerticalSpacer({this.height});

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
    return SizedBox(
        width: ScreenUtil().setWidth(width),
        height: ScreenUtil().setHeight(height));
  }
}

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
    return Row(children: spacedChildren);
  }
}
