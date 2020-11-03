import 'package:flutter/material.dart';
import 'package:pickapp/Utilities/DateTimePicker.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/ResponsiveRow.dart';

class Search extends StatelessWidget {
  DateTimeController d = new DateTimeController();
  LocationEditingController fromController = new LocationEditingController();
  LocationEditingController toController = new LocationEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Lang.getString(context, "search_for_ride"))),
        body: Column(
          children: [
            ResponsiveRow(children: [
              LocationFinder(controller : fromController,title : Lang.getString(context, "from"), hintText : Lang.getString(context, "fromHint"), language : Lang.getString(context, "lang"), country : "lb"),
              LocationFinder(controller : toController,title : Lang.getString(context, "to"), hintText : Lang.getString(context, "toHint"), language : Lang.getString(context, "lang"), country : "lb"),
            ])
          ],
        ));
  }
}
