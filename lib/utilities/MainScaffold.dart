import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

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
      this.bottomNavigationBar}) {
    this.backgroundColor ??= Styles.secondaryColor();
  }

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
