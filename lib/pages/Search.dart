import 'package:flutter/material.dart';
import 'package:pickapp/Utilities/DateTimePicker.dart';
import 'package:pickapp/localization/Language.dart';

class Search extends StatelessWidget {
  DateTimeController d = new DateTimeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Lang.getString(context, "search_for_ride"))),
        body: Column(
          children: [
            Text(Lang.getString(context, "to")),
            Text(Lang.getString(context, "from")),
          ],
        ));
  }
}
