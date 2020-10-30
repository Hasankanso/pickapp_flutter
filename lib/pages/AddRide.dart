import 'package:flutter/material.dart';
import 'package:pickapp/localization/Language.dart';

class AddRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Lang.getString(context, "add_ride_appbar_title"))),
        body: Column(
          children: [],
        ));
  }
}
