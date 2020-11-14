import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

import 'MainAppBar.dart';

class MainScaffold extends StatefulWidget {
  MainAppBar appBar;
  Widget body;
  MainScaffold({this.appBar, this.body});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor(),
      appBar: widget.appBar,
      body: widget.body,
    );
  }
}
