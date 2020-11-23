import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

import 'MainAppBar.dart';

class MainScaffold extends StatelessWidget {
  MainAppBar appBar;
  Widget body;
  Color backgroundColor = Styles.secondaryColor();
  MainScaffold({this.appBar, this.body, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: body,
    );
  }
}
