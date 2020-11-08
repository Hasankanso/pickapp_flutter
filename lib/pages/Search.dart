import 'package:flutter/material.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/ResponsiveRow.dart';

import '../utilities/DateTimeRangePicker.dart';
import '../utilities/NumberPicker.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  LocationEditingController fromController = LocationEditingController();
  LocationEditingController toController = LocationEditingController();
  DateTimeRangeController dateTimeController = DateTimeRangeController();
  NumberController numberController = NumberController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Lang.getString(context, "search_for_ride"))),
        body: Column(
          children: [
            ResponsiveRow(children: [
              Expanded(
                  flex: 6,
                  child: LocationFinder(
                      controller: fromController,
                      title: Lang.getString(context, "from"),
                      initialDescription: fromController.description,
                      hintText: Lang.getString(context, "fromHint"),
                      language: Lang.getString(context, "lang"),
                      country: "lb")),
              Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(Icons.sync_alt),
                    onPressed: () {
                      String temp_desc = toController.description;
                      String temp_placeId = toController.placeId;
                      Location temp_location = toController.location;

                      setState(() {
                        toController.description = fromController.description;
                        toController.placeId = fromController.placeId;
                        toController.location = fromController.location;

                        fromController.description = temp_desc;
                        fromController.placeId = temp_placeId;
                        fromController.location = temp_location;
                      });
                    },
                  )),
              Expanded(
                  flex: 6,
                  child: LocationFinder(
                      controller: toController,
                      title: Lang.getString(context, "to"),
                      initialDescription: toController.description,
                      hintText: Lang.getString(context, "toHint"),
                      language: Lang.getString(context, "lang"),
                      country: "lb")),
            ]),
            DateTimeRangePicker(dateTimeController),
            NumberPicker(numberController, "Persons", 1, 8),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
