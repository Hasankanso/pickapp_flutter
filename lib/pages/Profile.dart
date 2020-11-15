import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> list = List();

  @override
  Widget build(BuildContext context) {
    list.add("samii");
    list.add("samii");
    list.add("samii");
    list.add("samii");
    list.add("samii");
    list.add("samii");
    list.add("samii");
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Profile"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Styles.secondaryColor(),
                size: Styles.primaryIconSize(),
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
