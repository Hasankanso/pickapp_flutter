import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/utilities/Line.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class BecomeDriver extends StatefulWidget {
  @override
  _BecomeDriverState createState() => _BecomeDriverState();
}

class _BecomeDriverState extends State<BecomeDriver> {
  List<MainLocation> _regions = List<MainLocation>();

  _addRegion() {
    setState(() {
      _regions.add(MainLocation());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_regions.isEmpty) {
      _regions.add(MainLocation(name: "beirut"));
    }
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Become_a_driver"),
      ),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Text(
                        "Regions",
                        style: Styles.labelTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.add_location_alt),
                        iconSize: Styles.largeIconSize(),
                        color: Styles.primaryColor(),
                        tooltip:
                            "Add a region", //Lang.getString(context, "Settings"),
                        onPressed: _addRegion,
                      ),
                    ),
                  ],
                ),
                Line(
                  margin: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListBuilder(
                list: _regions,
                itemBuilder: RegionsListTile.itemBuilder(_regions)),
          ),
        ],
      ),
    );
  }
}

class RegionsListTile extends StatelessWidget {
  final MainLocation region;
  LocationEditingController regionController = LocationEditingController();
  RegionsListTile(this.region);

  static Function(BuildContext, int) itemBuilder(List<MainLocation> r) {
    return (context, index) {
      return RegionsListTile(r[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.all(3),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: LocationFinder(
          controller: regionController,
          hintText: "Region",
        ),
      ),
    );
  }
}
