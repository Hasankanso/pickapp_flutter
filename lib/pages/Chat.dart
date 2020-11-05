import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(Lang.getString(context, "chats"))),
        body: Column(
          children: [],
        ));
  }
}
