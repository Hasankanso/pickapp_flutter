import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/pickapp_google_places.dart';

class LocationFinder extends StatefulWidget {
  LocationEditingController _controller;
  String _title;
  String _hintText;
  String _language;
  String _country;
  String _API_KEY;
  String _initialDescription;

  LocationFinder(
      {LocationEditingController controller,
      String title,
      String hintText,
      String initialDescription,
      String language,
      String country}) {
    _controller = controller;
    _title = title;
    _hintText = hintText;
    _language = language;
    _country = country;
    _API_KEY = App.googleKey;
    _initialDescription = initialDescription;
  }

  @override
  _LocationFinderState createState() => _LocationFinderState();
}

class _LocationFinderState extends State<LocationFinder> {
  TextEditingController _textEditingController = new TextEditingController();

  void OpenAutoComplete(BuildContext context) async {
    dynamic locPred = await PlacesAutocomplete.show(
        context: context,
        hint: Lang.getString(context, "Search"),
        apiKey: widget._API_KEY,
        mode: Mode.fullscreen,
        // Mode.overlay
        language: widget._language,
        components: [Component(Component.country, widget._country)]);

    if (locPred == null) return;
    //if user chose current location
    if (locPred.runtimeType == Location) {
      setState(() {
        String curr_loc = Lang.getString(context, "My_Current_Location");
        _textEditingController.text = curr_loc;
        widget._controller.location = new Location(locPred.lat, locPred.lng);
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
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(locPred.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = locPred.description;

    setState(() {
      widget._controller.location = new Location(latitude, longitude);
      widget._controller.placeId = locPred.placeId;
      widget._controller.description = locPred.description;
      _textEditingController.text = widget._controller.description;
      widget._initialDescription = locPred.description;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget._initialDescription;
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
    labelText: widget._title,
    hintText: widget._hintText,
      ),
      focusNode: FocusNode(),
      enableInteractiveSelection: false,
      onTap: () => OpenAutoComplete(context),
    );
  }
}

class LocationEditingController {
  Location location;
  String placeId = "";
  String description = "";
}
