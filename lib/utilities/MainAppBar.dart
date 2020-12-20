import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget> actions;
  double elevation;
  Widget bottom;
  MainAppBar({this.title, this.actions, this.elevation, this.bottom});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: elevation,
      title: Text(
        title,
        style: Styles.titleTextStyle(),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().appBarHeight);
}
