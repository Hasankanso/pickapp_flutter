import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/Line.dart';
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
  List<RegionsListTile> _regionTiles = List<RegionsListTile>();
  List<LocationEditingController> _regionsControllers =
      List<LocationEditingController>();

  _addRegion() {
    if (_regions.length <= 2) {
      setState(() {
        _regions.add(MainLocation());
        _regionsControllers.add(LocationEditingController());
      });
    }
  }

  removeRegion(int index) {
    if (_regions.length > 1) {
      setState(() {
        _regions.removeAt(index);
        _regionTiles.removeAt(index);
        _regionsControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_regions.isEmpty) {
      _regions.add(MainLocation());
      _regionsControllers.add(LocationEditingController());
    }
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Become_a_driver"),
      ),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                    shape: RoundedRectangleBorder(),
                    child: Column(
                      children: [
                        DifferentSizeResponsiveRow(
                          children: [
                            Expanded(
                              flex: 10,
                              child: Text(
                                "My living regions:",
                                style: Styles.valueTextStyle(),
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
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemBuilder: (context, index) {
                var _tile = RegionsListTile(
                    _regions[index],
                    _regions.length != 1,
                    index,
                    removeRegion,
                    _regionsControllers[index]);
                _regionTiles.add(_tile);
                return _tile;
              },
              itemCount: _regions.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: false,
                text_key: "Next",
                onPressed: () {
                  Navigator.pushNamed(context, "/AddCar");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegionsListTile extends StatelessWidget {
  final MainLocation region;
  bool isDefault;
  int _index;
  Function(int) _removeRegion;
  LocationEditingController regionController;

  RegionsListTile(this.region, this.isDefault, this._index, this._removeRegion,
      this.regionController);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
        child: DifferentSizeResponsiveRow(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  LocationFinder(
                    controller: regionController,
                    title: Lang.getString(context, "Region"),
                    hintText: Lang.getString(context, "Region"),
                    initialDescription: regionController.description,
                    language: Lang.getString(context, "lang"),
                    country: App.countryCode,
                  ),
                ],
              ),
            ),
            isDefault
                ? Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.minimize),
                      iconSize: Styles.largeIconSize(),
                      color: Styles.primaryColor(),
                      tooltip:
                          "Remove region", //Lang.getString(context, "Settings"),
                      onPressed: () {
                        _removeRegion(_index);
                      },
                    ),
                  )
                : Spacer(
                    flex: 2,
                  )
          ],
        ),
      ),
    );
  }
}
