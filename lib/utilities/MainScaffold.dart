import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

import 'MainAppBar.dart';

class MainScaffold extends StatefulWidget {
  MainAppBar appBar;
  Widget body;
  Color backgroundColor = Styles.secondaryColor();
  MainScaffold({this.appBar, this.body, this.backgroundColor});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.appBar,
      body: widget.body,
    );
  }
}
