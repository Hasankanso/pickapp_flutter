import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';

class AddRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Lang.getString(context, "Add_Ride"))),
        body: Column(
          children: [],
        ));
  }
}
