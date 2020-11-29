import 'package:flutter/material.dart';

import 'MainAppBar.dart';

class MainScaffold extends StatelessWidget {
  MainAppBar appBar;
  Widget body;
  Widget bottomNavigationBar;
  Color backgroundColor;
  MainScaffold(
      {this.appBar,
      this.body,
      this.backgroundColor,
      this.bottomNavigationBar}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
