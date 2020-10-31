import 'package:flutter/material.dart';
import 'package:pickapp/localization/Language.dart';

class MyRides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Lang.getString(context, "my_rides_appbar_title"))),
        body: Column(
          children: [],
        ));
  }
}
