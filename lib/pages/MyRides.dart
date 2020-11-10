import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';

class MyRides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Lang.getString(context, "my_rides"))),
        body: Column(
          children: [],
        ));
  }
}
