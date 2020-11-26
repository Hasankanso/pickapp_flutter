import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    if (!App.isLoggedIn) {
      return Login();
    }
      return MainScaffold(
          appBar: MainAppBar(
            title: Lang.getString(context, "Profile"),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Styles.secondaryColor(),
                  size: Styles.largeIconSize(),
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
