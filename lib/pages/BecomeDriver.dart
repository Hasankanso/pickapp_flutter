import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/items/RegionListTile.dart';
import 'package:just_miles/packages/FlushBar/flushbar.dart';
import 'package:just_miles/requests/EditRegions.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/LocationFinder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/pickapp_google_places.dart';
import 'package:uuid/uuid.dart';

class BecomeDriver extends StatefulWidget {
  final bool isRegionPage;
  final User user;
  final bool isInRegister;

  BecomeDriver(
      {this.isRegionPage = false, this.user, this.isInRegister = false});

  @override
  _BecomeDriverState createState() => _BecomeDriverState();
}

class _BecomeDriverState extends State<BecomeDriver> {
  Driver driver = Driver();
  List<MainLocation> _regions = <MainLocation>[];
  List<String> _errorTexts = <String>[];
  List<LocationEditingController> _regionsControllers =
      <LocationEditingController>[];

  _addRegion() async {
    if (_regions.length <= 2) {
      String sessionToken = Uuid().v4();
      dynamic locPred = await PlacesAutocomplete.show(
        context: context,
        hint: Lang.getString(context, "Search"),
        apiKey: App.googleKey,
        mode: Mode.fullscreen,
        types: [""],
        language: Lang.getString(context, "lang"),
        strictbounds: false,
        sessionToken: sessionToken,
      );
      if (locPred == null) {
        FocusScope.of(context).requestFocus(new FocusNode());
        return;
      }
      //if user chose current location
      if (locPred.runtimeType == Location) {
        setState(() {
          String currLoc = Lang.getString(context, "My_Current_Location");
          _regions.add(MainLocation());
          _regionsControllers.add(LocationEditingController(
              location: Location(lat: locPred.lat, lng: locPred.lng),
              placeId: null,
              description: currLoc));
          _errorTexts.add(null);
          FocusScope.of(context).unfocus();
        });
        return;
      }

      //request longitude and latitude from google_place_details api
      GoogleMapsPlaces _places =
          new GoogleMapsPlaces(apiKey: App.googleKey); //Same _API_KEY as above
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
          locPred.placeId,
          sessionToken: sessionToken,
          fields: ["geometry"]);
      double latitude = detail.result.geometry.location.lat;
      double longitude = detail.result.geometry.location.lng;
      setState(() {
        _regions.add(MainLocation());
        _regionsControllers.add(LocationEditingController(
            location: Location(lat: latitude, lng: longitude),
            placeId: locPred.placeId,
            description: locPred.description));
        _errorTexts.add(null);
        FocusScope.of(context).unfocus();
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
  void initState() {
    super.initState();
    _getRegions();
  }

  Future<void> _getRegions() async {
    if (widget.isRegionPage) {
      _regions.addAll(App.driver.regions);
      for (var region in _regions) {
        _regionsControllers.add(LocationEditingController(
          placeId: region.placeId,
          description: region.name,
          location: Location(lat: region.latitude, lng: region.longitude),
        ));
        _errorTexts.add(null);
      }
      setState(() {});
    } else if (widget.user != null) {
      _regions.add(MainLocation());
      _regionsControllers.add(LocationEditingController());
      _errorTexts.add(null);
      if (widget.isInRegister) {
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
    } else {
      _regions.add(MainLocation());
      _regionsControllers.add(LocationEditingController());
      _errorTexts.add(null);
      if (widget.isInRegister) {
        _showRegionsMessage();
      }
    }
  }

  _showRegionsMessage() {
    Future.delayed(Duration.zero, () async {
      Flushbar(
        message: Lang.getString(context, "Regions_require_message"),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        isDismissible: true,
        duration: Duration(seconds: 4),
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

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(
            context, widget.isRegionPage ? "Regions" : "Become_a_Driver"),
        actions: [
          !widget.isRegionPage
              ? IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: Styles.mediumIconSize(),
                  ),
                  onPressed: _showRegionsMessage)
              : Container(),
        ],
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
            flex: 6,
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
          Expanded(
            flex: 6,
            child: ResponsiveWidget.fullWidth(
              height: 100,
              child: Row(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 120,
                    child: MainNativeAd(),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          Spacer(
            flex: 1,
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
                textKey: widget.isRegionPage ? "Edit" : "Next",
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

  _editRegionsResponse(p1, int code, String message) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }

    App.driver.regions = p1.regions;
    await Cache.setUser(App.user);
    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
  }
}
