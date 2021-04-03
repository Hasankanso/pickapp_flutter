import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/utilities/pickapp_google_places.dart';
import 'package:uuid/uuid.dart';

class LocationFinder extends StatefulWidget {
  LocationEditingController _controller;
  String _title;
  String _hintText;
  String _language;
  String _country;
  String _API_KEY;
  String _initialDescription;
  String errorText;
  String Function(String) onValidate;
  bool isUnderlineBorder;

  LocationFinder(
      {LocationEditingController controller,
      String title,
      String hintText,
      String initialDescription,
      String language,
      String country,
      this.errorText,
      this.onValidate,
      this.isUnderlineBorder = true}) {
    _controller = controller;
    _title = title;
    _hintText = hintText;
    _language = language;
    _country = country;
    _API_KEY = App.googleKey;
    _initialDescription = initialDescription;
    isUnderlineBorder = isUnderlineBorder;
  }

  @override
  _LocationFinderState createState() => _LocationFinderState();
}

class _LocationFinderState extends State<LocationFinder> {
  TextEditingController _textEditingController = new TextEditingController();

  void OpenAutoComplete(BuildContext context) async {
    String sessionToken = Uuid().v4();
    dynamic locPred = await PlacesAutocomplete.show(
        context: context,
        hint: Lang.getString(context, "Search"),
        apiKey: widget._API_KEY,
        mode: Mode.fullscreen,
        language: widget._language,
        sessionToken: sessionToken,
        components: App.countriesComponents);
    if (locPred == null) {
      FocusScope.of(context).requestFocus(new FocusNode());
      return;
    }

    //if user chose current location
    if (locPred.runtimeType == Location) {
      setState(() {
        String curr_loc = Lang.getString(context, "My_Current_Location");
        _textEditingController.text = curr_loc;
        widget._controller.location = new Location(lat : locPred.lat, lng : locPred.lng);
        widget._controller.placeId = null;
        widget._controller.description = curr_loc;
        widget._initialDescription = curr_loc;
        FocusScope.of(context).unfocus();
      });
      return;
    }

    //request longitude and latitude from google_place_details api
    GoogleMapsPlaces _places =
        new GoogleMapsPlaces(apiKey: widget._API_KEY); //Same _API_KEY as above
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
        locPred.placeId,
        sessionToken: sessionToken,
        fields: ["geometry"]);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = locPred.description;

    setState(() {
      widget._controller.location = new Location(lat : latitude, lng : longitude);
      widget._controller.placeId = locPred.placeId;
      widget._controller.description = locPred.description;
      _textEditingController.text = widget._controller.description;
      widget._initialDescription = locPred.description;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._initialDescription == null) _textEditingController.text = "";
    _textEditingController.text = widget._initialDescription;
    return TextField(
      controller: _textEditingController,
      enableInteractiveSelection: false,
      showCursor: false,
      decoration: InputDecoration(
        labelText: widget._title,
        hintText: widget._hintText,
        labelStyle: Styles.labelTextStyle(),
        hintStyle: Styles.labelTextStyle(),
        errorText: widget.errorText,
        border: widget.isUnderlineBorder ? null : InputBorder.none,
        focusedBorder: widget.isUnderlineBorder ? null : InputBorder.none,
        enabledBorder: widget.isUnderlineBorder ? null : InputBorder.none,
        errorBorder: widget.isUnderlineBorder ? null : InputBorder.none,
        disabledBorder: widget.isUnderlineBorder ? null : InputBorder.none,
      ),
      style: Styles.valueTextStyle(),
      focusNode: FocusNode(),
      onTap: () => OpenAutoComplete(context),
    );
  }
}

class LocationEditingController {
  Location location;
  String placeId = "";
  String description = "";

  LocationEditingController({this.location, this.placeId, this.description});

  swap(LocationEditingController x) {
    String temp_desc = x.description;
    String temp_placeId = x.placeId;
    Location temp_location = x.location;

    x.description = this.description;
    x.placeId = this.placeId;
    x.location = this.location;

    this.description = temp_desc;
    this.placeId = temp_placeId;
    this.location = temp_location;
  }

  validate(context, {LocationEditingController x}) {
    String _isEmpty = Validation.validate(this.description, context);
    if (_isEmpty != null) {
      return _isEmpty;
    } else if (x != null &&
        MainLocation.equals(this.location.lat, this.location.lng,
            x.location.lat, x.location.lng)) {
      return Lang.getString(context, "Too_close");
    } else {
      return null;
    }
  }
}
