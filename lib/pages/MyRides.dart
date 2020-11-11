import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/MainAppBar.dart';

class MyRides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor(),
        appBar: MainAppBar(title:
            Lang.getString(context, "My_Rides"),
        ),
        body: Column(
          children: [],
        ));
  }
}
