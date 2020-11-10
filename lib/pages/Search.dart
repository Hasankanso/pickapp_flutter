import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/DateTimeRangePicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/DifferentSizeResponsiveRow.dart';

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
        appBar: AppBar(
            title: Text(
          Lang.getString(context, "Search_for_Ride"),
          style: Styles.titleTextStyle(context),
        )),
        body: Column(
          children: [
            DifferentSizeResponsiveRow(children: [
              Expanded(
                flex: 8,
                child: Column(mainAxisAlignment : MainAxisAlignment.spaceBetween, children: [
                  Icon(Icons.panorama_fish_eye,
                      color: Styles.primaryColor(), size: 15),
                  Icon(Icons.more_vert, color: Styles.primaryColor(), size: 15),
                  Icon(Icons.circle, color: Styles.primaryColor(), size: 15)
                ]),
              ),
              Expanded(
                flex: 60,
                child: Column(
                  children: [
                    LocationFinder(
                        controller: fromController,
                        title: Lang.getString(context, "From"),
                        initialDescription: fromController.description,
                        hintText: Lang.getString(context, "From_Where"),
                        language: Lang.getString(context, "lang"),
                        country: "lb"),
                    LocationFinder(
                        controller: toController,
                        title: Lang.getString(context, "To"),
                        initialDescription: toController.description,
                        hintText: Lang.getString(context, "To_Where"),
                        language: Lang.getString(context, "lang"),
                        country: "lb")
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: IconButton(
                  icon: Icon(Icons.sync),
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
                ),
              )
            ]),
            DateTimeRangePicker(dateTimeController),
            NumberPicker(numberController, "Persons", 1, 8),
            MainButton(
              text_key: "Search",
              onPressed: () => print("search"),
            ),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/*
 Expanded(
                      flex: 6,
                      child: LocationFinder(
                          controller: fromController,
                          title: Lang.getString(context, "From"),
                          initialDescription: fromController.description,
                          hintText: Lang.getString(context, "From_Where"),
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
                            toController.description =
                                fromController.description;
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
                          title: Lang.getString(context, "To"),
                          initialDescription: toController.description,
                          hintText: Lang.getString(context, "To_Where"),
                          language: Lang.getString(context, "lang"),
                          country: "lb")),
 */
