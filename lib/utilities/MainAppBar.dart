import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget> actions;
  double elevation;
  MainAppBar({this.title, this.actions, this.elevation});
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().appBarHeight);
}
