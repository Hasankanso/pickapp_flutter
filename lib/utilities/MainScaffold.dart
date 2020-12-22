import 'package:flutter/material.dart';

import 'MainAppBar.dart';

class MainScaffold extends StatelessWidget {
  MainAppBar appBar;
  Widget body;
  Widget bottomNavigationBar;
  Color backgroundColor;
  Widget floatingWidget;
  FloatingActionButtonLocation floatingLocation;

  MainScaffold(
      {this.appBar,
      this.body,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.floatingWidget,
      this.floatingLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingWidget,
      floatingActionButtonLocation: floatingLocation,
    );
  }
}
