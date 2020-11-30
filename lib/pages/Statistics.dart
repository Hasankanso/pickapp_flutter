import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(title: Lang.getString(context, "Statistics")),
      body: Column(
        children: [],
      ),
    );
  }
}
