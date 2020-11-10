import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

class MyRides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          Lang.getString(context, "My_Rides"),
          style: Styles.titleTextStyle(context),
        )),
        body: Column(
          children: [],
        ));
  }
}
