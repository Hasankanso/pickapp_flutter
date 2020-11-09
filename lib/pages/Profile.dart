import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Lang.getString(context, "Profile")),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              tooltip: Lang.getString(context, "Settings"),
              onPressed: () {
                Navigator.of(context).pushNamed("/settings");
              },
            )
          ],
        ),
        body: Column(
          children: [],
        ));
  }
}
