import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          Lang.getString(context, "Chats"),
          style: Styles.titleTextStyle(context),
        )),
        body: Column(
          children: [],
        ));
  }
}
