import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

class AddRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          Lang.getString(context, "Add_Ride"),
          style: Styles.titleTextStyle(context),
        )),
        body: Column(
          children: [],
        ));
  }
}
