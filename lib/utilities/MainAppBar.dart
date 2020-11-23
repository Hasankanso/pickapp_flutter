import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pickapp/classes/Styles.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget> actions;
  MainAppBar({this.title, this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: ScreenUtil().setHeight(55),
      title: Text(
        title,
        style: Styles.titleTextStyle(),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setHeight(55));
}
