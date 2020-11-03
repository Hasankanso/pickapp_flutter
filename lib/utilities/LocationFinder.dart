import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickapp/classes/App.dart';

class LocationFinder extends StatelessWidget {
  LocationEditingController _controller;
  String _title;
  String _hintText;
  String _language;
  String _country;
  String _API_KEY;

  TextEditingController _textEditingController;

  LocationFinder({LocationEditingController controller, String title, String hintText, String language, String country}) {
    _controller = controller;
    _title = title;
    _hintText = hintText;
    _language = language;
    _country = country;
    _API_KEY = App.googleKey;
  }

  void OpenAutoComplete(BuildContext context) async {
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: _API_KEY,
        mode: Mode.fullscreen,
        // Mode.overlay
        language: _language,
        components: [Component(Component.country, _country)]);

    GoogleMapsPlaces _places =
        new GoogleMapsPlaces(apiKey: _API_KEY); //Same _API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = prediction.description;

    _controller.location = new Location(latitude, longitude);
    _controller.placeId = prediction.placeId;
    _controller.description = prediction.description;

      print(_controller.description);
      _textEditingController.text = _controller.description;
      FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
        child: TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        labelText: _title,
        hintText: _hintText,
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
