import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget> actions;
  double elevation;
  PreferredSizeWidget bottom;
  bool hideBackBtn;
  Widget leading;
  MainAppBar(
      {this.title,
      this.actions,
      this.elevation,
      this.bottom,
      this.hideBackBtn = false,
      this.leading});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: !hideBackBtn,
      elevation: elevation,
      leading: leading,
      title: Text(
        title,
        style: Styles.titleTextStyle(),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      ScreenUtil().appBarHeight + (bottom?.preferredSize?.height ?? 0.0));
}
