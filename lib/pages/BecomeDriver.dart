import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/items/RegionListTile.dart';
import 'package:pickapp/requests/EditRegions.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class BecomeDriver extends StatefulWidget {
  bool isRegionPage;
  bool isForceRegister;
  User user;

  BecomeDriver({this.isRegionPage = false, this.isForceRegister, this.user});

  @override
  _BecomeDriverState createState() => _BecomeDriverState();
}

class _BecomeDriverState extends State<BecomeDriver> {
  Driver driver = Driver();
  List<MainLocation> _regions = List<MainLocation>();
  List<String> _errorTexts = List<String>();
  List<LocationEditingController> _regionsControllers =
      List<LocationEditingController>();

  _addRegion() {
    if (_regions.length <= 2) {
      setState(() {
        _regions.add(MainLocation());
        _regionsControllers.add(LocationEditingController());
        _errorTexts.add(null);
      });
    }
  }

  _removeRegion(int index) {
    if (_regions.length > 1) {
      setState(() {
        _regions.removeAt(index);
        _regionsControllers.removeAt(index);
        _errorTexts.removeAt(index);
      });
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.isRegionPage) {
      _regions = App.driver.regions;
      for (var region in _regions) {
        _regionsControllers.add(LocationEditingController(
          placeId: region.placeId,
          description: region.name,
          location: Location(lat : region.latitude, lng: region.longitude),
        ));
        _errorTexts.add(null);
      }
      setState(() {});
    } else if (widget.user != null) {
      _regions.add(MainLocation());
      _regionsControllers.add(LocationEditingController());
      _errorTexts.add(null);
      Future.delayed(Duration.zero, () async {
        Flushbar(
          message: Lang.getString(context, "Regions_require_message"),
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
    } else {
      _regions.add(MainLocation());
      _regionsControllers.add(LocationEditingController());
      _errorTexts.add(null);
      Future.delayed(Duration.zero, () async {
        Flushbar(
          message: Lang.getString(context, "Regions_require_message"),
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
            aspectRatio: 22 / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                tooltip:
                                    Lang.getString(context, "Add_a_region"),
                                onPressed:
                                    !(_regions.length >= 3) ? _addRegion : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return RegionListTile(
                  _regions.length != 1,
                  index,
                  _removeRegion,
                  _regionsControllers[index],
                  _errorTexts[index],
                );
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
                isRequest: true,
                text_key: widget.isRegionPage ? "Edit" : "Next",
                onPressed: () async {
                  bool isValid = true;
                  for (int i = 0; i < _regionsControllers.length; i++) {
                    var validate = _regionsControllers[i].validate(context);
                    _errorTexts[i] = validate;
                    if (validate != null) {
                      isValid = false;
                    }
                  }
                  setState(() {});
                  if (isValid) {
                    for (int i = 0; i < _regionsControllers.length; i++) {
                      _regions[i].name = _regionsControllers[i].description;
                      _regions[i].placeId = _regionsControllers[i].placeId;
                      _regions[i].longitude =
                          _regionsControllers[i].location.lng;
                      _regions[i].latitude =
                          _regionsControllers[i].location.lat;
                    }

                    for (int i = 0; i < _regions.length; i++) {
                      for (int j = i + 1; j < _regions.length; j++) {
                        if (_regions[i].latitude == _regions[j].latitude &&
                            _regions[i].longitude == _regions[j].longitude) {
                          _errorTexts[i] =
                              Lang.getString(context, "Region_validation");
                          _errorTexts[j] =
                              Lang.getString(context, "Region_validation");
                          isValid = false;
                        }
                      }
                    }
                    if (isValid == false) return;
                    //validation done
                    if (widget.isRegionPage) {
                      driver.regions = _regions;
                      Request request = EditRegions(driver);
                      await request.send(_editRegionsResponse);
                    } else if (widget.user != null) {
                      widget.user.driver.regions = _regions;
                      Navigator.pushNamed(context, "/AddCarRegister",
                          arguments: [
                            widget.user,
                            widget.isForceRegister,
                          ]);
                    } else {
                      driver.regions = _regions;
                      Navigator.pushNamed(context, "/AddCarDriver",
                          arguments: driver);
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

      await Cache.setUser(App.user);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }
}
