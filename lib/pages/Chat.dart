import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Chats"),
        ),
        body: Column(
          children: [],
        ));
  }
}
