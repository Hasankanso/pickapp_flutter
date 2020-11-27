import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget> actions;
  MainAppBar({this.title, this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
