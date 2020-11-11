import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget> actions;
  MainAppBar({this.title, this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: App.mediaQuery.size.height * 0.082,
      title: Text(
        title,
        style: Styles.titleTextStyle(),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(App.mediaQuery.size.height * 0.082);
}
