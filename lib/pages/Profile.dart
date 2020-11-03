import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Lang.getString(context, "profile"))),
        body: Column(
          children: [],
        ));
  }
}
