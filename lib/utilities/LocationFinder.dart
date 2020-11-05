import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';

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
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        hint: Lang.getString(context, "search"),
        apiKey: widget._API_KEY,
        mode: Mode.fullscreen,
        // Mode.overlay
        language: widget._language,
        components: [Component(Component.country, widget._country)]);

    GoogleMapsPlaces _places =
        new GoogleMapsPlaces(apiKey: widget._API_KEY); //Same _API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = prediction.description;

    widget._controller.location = new Location(latitude, longitude);
    widget._controller.placeId = prediction.placeId;
    widget._controller.description = prediction.description;

    setState(() {
      _textEditingController.text = widget._controller.description;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget._initialDescription;
    return LimitedBox(
        child: TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        labelText: widget._title,
        hintText: widget._hintText,
      ),
      focusNode: FocusNode(),
      enableInteractiveSelection: false,
      onTap: () => OpenAutoComplete(context),
    ));
  }
}

class LocationEditingController {
  Location location;
  String placeId;
  String description;
}
