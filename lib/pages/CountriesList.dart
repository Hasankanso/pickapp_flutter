import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class CountriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Broadcast_Alert"),
        ),
        body: Column(children: []));
  }
}
