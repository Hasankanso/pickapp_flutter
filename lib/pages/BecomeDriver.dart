import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/items/RegionListTile.dart';
import 'package:pickapp/requests/EditRegions.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/LineDevider.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class BecomeDriver extends StatefulWidget {
  bool isRegionPage;

  BecomeDriver({this.isRegionPage = false});

  @override
  _BecomeDriverState createState() => _BecomeDriverState();
}

class _BecomeDriverState extends State<BecomeDriver> {
  final _formKey = GlobalKey<FormState>();
  var regionsBox;
  List<MainLocation> _regions = List<MainLocation>();
  List<RegionListTile> _regionTiles = List<RegionListTile>();
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
  void dispose() {
    // TODO: implement dispose
    regionsBox.close();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.isRegionPage) {
      await Hive.openBox("regions");
      regionsBox = Hive.box("regions");
      if (regionsBox.length != 0) {
        App.user.driver.regions = regionsBox.getAt(0).cast<MainLocation>();
      }
      _regions = App.driver.regions;
      for (var region in _regions) {
        _regionsControllers.add(LocationEditingController(
          placeId: region.placeId,
          description: region.name,
          location: Location(region.latitude, region.longitude),
        ));
      }
      setState(() {});
    } else {
      _regions.add(MainLocation());
      _regionsControllers.add(LocationEditingController());

      Future.delayed(Duration.zero, () async {
        Flushbar(
          message:
              "Your living regions are required, to make it easier for passengers to reach you",
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.decelerate,
          icon: Icon(
            Icons.info_outline,
            color: Styles.primaryColor(),
            size: Styles.mediumIconSize(),
          ),
          mainButton: IconButton(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              color: Styles.secondaryColor(),
              size: Styles.mediumIconSize(),
            ),
          ),
        )..show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(
            context, widget.isRegionPage ? "Regions" : "Become_a_Driver"),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 25 / 4,
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
                              Lang.getString(context, "My_living_regions:"),
                              style: Styles.valueTextStyle(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: Icon(Icons.add_location_alt),
                              iconSize: Styles.largeIconSize(),
                              color: Styles.primaryColor(),
                              tooltip: Lang.getString(context,
                                  "Add_a_region"), //Lang.getString(context, "Settings"),
                              onPressed:
                                  !(_regions.length >= 3) ? _addRegion : null,
                            ),
                          ),
                        ],
                      ),
                      LineDevider(
                        margin: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView.builder(
                reverse: false,
                itemBuilder: (context, index) {
                  var _tile = RegionListTile(
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
                isRequest: true,
                text_key: widget.isRegionPage ? "Edit" : "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    for (int i = 0; i < _regionsControllers.length; i++) {
                      _regions[i].name = _regionsControllers[i].description;
                      _regions[i].placeId = _regionsControllers[i].placeId;
                      _regions[i].longitude =
                          _regionsControllers[i].location.lng;
                      _regions[i].latitude =
                          _regionsControllers[i].location.lat;
                    }
                    if (widget.isRegionPage) {
                      Request request = EditRegions(Driver(regions: _regions));
                      await request.send(_editRegionsResponse);
                    } else {
                      Navigator.pushNamed(context, "/AddCarDriver",
                          arguments: Driver(regions: _regions));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _editRegionsResponse(p1, int code, String p3) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(p3);
    } else {
      App.driver.regions = p1.regions;

      if (regionsBox.containsKey(0)) {
        await regionsBox.put(0, p1.regions);
      } else {
        await regionsBox.add(p1.regions);
      }
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }
}
