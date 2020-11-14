import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  TextEditingController _textEditingController = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "My_Rides"),
        ),
        body: Column(
          children: [],
        ));
  }
}
