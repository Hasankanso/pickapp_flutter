library flutter_google_places.src;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/requests/Request.dart' as req;
import 'package:just_miles/requests/get_location_request.dart';
import 'package:just_miles/utilities/GPSTile.dart';
import 'package:rxdart/rxdart.dart';

class PlacesAutocompleteWidget extends StatefulWidget {
  final String apiKey;
  final String startText;
  final String hint;
  final BorderRadius overlayBorderRadius;
  final Location location;
  final num offset;
  final num radius;
  final String language;
  final String sessionToken;
  final List<String> types;
  final bool strictbounds;
  final String region;
  final Mode mode;
  final Widget logo;
  final ValueChanged<PlacesAutocompleteResponse> onError;
  final int debounce;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient httpClient;
  final bool canPickCurrLocation;

  PlacesAutocompleteWidget({
    @required this.apiKey,
    this.mode = Mode.fullscreen,
    this.hint = "Search",
    this.overlayBorderRadius,
    this.offset,
    this.location,
    this.radius,
    this.language,
    this.sessionToken,
    this.types,
    this.strictbounds,
    this.region,
    this.logo,
    this.onError,
    Key key,
    this.proxyBaseUrl,
    this.httpClient,
    this.startText,
    this.debounce = 300,
    this.canPickCurrLocation = true,
  }) : super(key: key);

  @override
  State<PlacesAutocompleteWidget> createState() {
    return _PlacesAutocompleteScaffoldState();
  }

  static PlacesAutocompleteState of(BuildContext context) =>
      context.findAncestorStateOfType<PlacesAutocompleteState>();
}

class _PlacesAutocompleteScaffoldState extends PlacesAutocompleteState {
  bool destroyed = false;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(),
      actions: [
        IconButton(
          icon: Icon(
            Icons.language,
            color: Styles.secondaryColor(),
            size: Styles.largeIconSize(),
          ),
          tooltip: Lang.getString(context, "Countries_Restriction"),
          onPressed: () {
            Navigator.of(context).pushNamed("/CountriesRestriction");
          },
        ),
      ],
    );
    final body = PlacesAutocompleteResult(
      onTap: (value) async {
        if (_isLoading) {
          return;
        }

        ReturnLocation returnLocation;
        if (value is Prediction) {
          Prediction prediction = value;
          double latitude;
          double longitude;
          req.Request getLocationRequest =
              GetLocation(MainLocation(placeId: prediction.placeId));
          setState(() {
            _isLoading = true;
          });
          MainLocation backendFoundLocation =
              await getLocationRequest.send(null);
          if (backendFoundLocation != null) {
            latitude = backendFoundLocation.latitude;
            longitude = backendFoundLocation.longitude;
          } else {
            //request longitude and latitude from google_place_details api
            GoogleMapsPlaces _places =
                new GoogleMapsPlaces(apiKey: App.googleKey);

            //Same _API_KEY as above
            PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
                prediction.placeId,
                sessionToken: widget.sessionToken,
                fields: ["geometry"]);
            //Same _API_KEY as above
            latitude = detail.result.geometry.location.lat;
            longitude = detail.result.geometry.location.lng;
          }

          returnLocation = ReturnLocation(
              Location(lat: latitude, lng: longitude), false,
              description: prediction.description, placeId: prediction.placeId);
        } else {
          returnLocation = ReturnLocation(value, true);
        }
        _isLoading = false;
        if (mounted) {
          Navigator.pop(context, returnLocation);
        }
      },
      logo: widget.logo,
      canPickCurrLocation: widget.canPickCurrLocation,
    );
    return Scaffold(appBar: appBar, body: body);
  }
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxHeight: 2.0),
        child: LinearProgressIndicator());
  }
}

class PlacesAutocompleteResult extends StatefulWidget {
  final ValueChanged<dynamic> onTap;
  final Widget logo;
  final bool canPickCurrLocation;

  PlacesAutocompleteResult(
      {this.onTap, this.logo, this.canPickCurrLocation = true});

  @override
  _PlacesAutocompleteResult createState() => _PlacesAutocompleteResult();
}

class _PlacesAutocompleteResult extends State<PlacesAutocompleteResult> {
  bool isDestroyed = false;

  @override
  void dispose() {
    isDestroyed = true;
    super.dispose();
  }

  void onTap(dynamic r) {
    if (!isDestroyed) {
      widget.onTap(r);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context);
    assert(state != null);

    if (state._queryTextController.text.isEmpty ||
        state._response == null ||
        state._response.predictions.isEmpty) {
      final children = <Widget>[];
      if (state._searching) {
        children.add(_Loader());
      }
      children.add(GPSListView(
        predictions: [],
        onTap: onTap,
        canPickCurrLocation: widget.canPickCurrLocation,
      ));
      return Stack(children: children);
    }
    if (state._isLoading) {
      return LoadingListView(
        predictions: state._response.predictions,
      );
    }
    return GPSListView(
      predictions: state._response.predictions,
      onTap: onTap,
      canPickCurrLocation: widget.canPickCurrLocation,
    );
  }
}

class AppBarPlacesAutoCompleteTextField extends StatefulWidget {
  final InputDecoration textDecoration;
  final TextStyle textStyle;

  AppBarPlacesAutoCompleteTextField(
      {Key key, this.textDecoration, this.textStyle})
      : super(key: key);

  @override
  _AppBarPlacesAutoCompleteTextFieldState createState() =>
      _AppBarPlacesAutoCompleteTextFieldState();
}

class _AppBarPlacesAutoCompleteTextFieldState
    extends State<AppBarPlacesAutoCompleteTextField> {
  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context);
    assert(state != null);

    return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 4.0),
        child: TextField(
          controller: state._queryTextController,
          autofocus: true,
          style: widget.textStyle ?? _defaultStyle(),
          decoration:
              widget.textDecoration ?? _defaultDecoration(state.widget.hint),
        ));
  }

  InputDecoration _defaultDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white30
          : Colors.black38,
      hintStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black38
            : Colors.white30,
        fontSize: 16.0,
      ),
      border: InputBorder.none,
    );
  }

  TextStyle _defaultStyle() {
    return TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black.withOpacity(0.9)
          : Colors.white.withOpacity(0.9),
      fontSize: 16.0,
    );
  }
}

class PoweredByGoogleImage extends StatelessWidget {
  final _poweredByGoogleWhite =
      "packages/flutter_google_places/assets/google_white.png";
  final _poweredByGoogleBlack =
      "packages/flutter_google_places/assets/google_black.png";

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
          padding: EdgeInsets.all(16.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? _poweredByGoogleWhite
                : _poweredByGoogleBlack,
            scale: 2.5,
          ))
    ]);
  }
}

class PredictionsListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<Prediction> onTap;

  PredictionsListView({@required this.predictions, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: predictions
          .map((Prediction p) => PredictionTile(prediction: p, onTap: onTap))
          .toList(),
    );
  }
}

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction> onTap;

  PredictionTile({@required this.prediction, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text(prediction.description),
      onTap: () {
        if (onTap != null) {
          onTap(prediction);
        }
      },
    );
  }
}

enum Mode { overlay, fullscreen }

abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  TextEditingController _queryTextController;
  PlacesAutocompleteResponse _response;
  GoogleMapsPlaces _places;
  bool _searching;
  bool _isLoading = false;
  Timer _debounce;

  final _queryBehavior = BehaviorSubject<String>.seeded('');

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController(text: widget.startText);

    _places = GoogleMapsPlaces(
        apiKey: widget.apiKey,
        baseUrl: widget.proxyBaseUrl,
        httpClient: widget.httpClient);
    _searching = false;

    _queryTextController.addListener(_onQueryChange);

    _queryBehavior.stream.listen(doSearch);
  }

  Future<Null> doSearch(String value) async {
    if (mounted && value.isNotEmpty) {
      setState(() {
        _searching = true;
      });
      var res;
      try {
        res = await _places.autocomplete(
          value,
          offset: widget.offset,
          location: widget.location,
          radius: widget.radius,
          language: widget.language,
          sessionToken: widget.sessionToken,
          types: widget.types,
          components: App.countriesComponents,
          strictbounds: widget.strictbounds,
          region: widget.region,
        );
      } catch (e) {}
      if (res == null) {
        onResponse(null);
        return;
      }
      if (res.errorMessage?.isNotEmpty == true ||
          res.status == "REQUEST_DENIED") {
        onResponseError(res);
      } else {
        onResponse(res);
      }
    } else {
      onResponse(null);
    }
  }

  void _onQueryChange() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounce), () {
      if (!_queryBehavior.isClosed) {
        _queryBehavior.add(_queryTextController.text);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _places.dispose();
    _debounce.cancel();
    _queryBehavior.close();
    _queryTextController.removeListener(_onQueryChange);
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    if (widget.onError != null) {
      widget.onError(res);
    }
    setState(() {
      _response = null;
      _searching = false;
    });
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    setState(() {
      _response = res;
      _searching = false;
    });
  }
}

class PlacesAutocomplete {
  static Future<dynamic> show(
      {@required BuildContext context,
      @required String apiKey,
      Mode mode = Mode.fullscreen,
      String hint = "Search",
      BorderRadius overlayBorderRadius,
      num offset,
      Location location,
      num radius,
      String language,
      String sessionToken,
      List<String> types,
      bool strictbounds,
      String region,
      Widget logo,
      ValueChanged<PlacesAutocompleteResponse> onError,
      String proxyBaseUrl,
      Client httpClient,
      String startText = "",
      canPickCurrLocation = true}) {
    final builder = (BuildContext ctx) => PlacesAutocompleteWidget(
          apiKey: apiKey,
          mode: mode,
          overlayBorderRadius: overlayBorderRadius,
          language: language,
          sessionToken: sessionToken,
          types: types,
          location: location,
          radius: radius,
          strictbounds: strictbounds,
          region: region,
          offset: offset,
          hint: hint,
          logo: logo,
          onError: onError,
          proxyBaseUrl: proxyBaseUrl,
          httpClient: httpClient,
          startText: startText,
          canPickCurrLocation: canPickCurrLocation,
        );
    if (mode == Mode.overlay) {
      return showDialog(context: context, builder: builder);
    }
    return Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}

class ReturnLocation {
  Location location;
  bool isMyLocation = false;
  String placeId, description;
  ReturnLocation(this.location, this.isMyLocation,
      {this.placeId, this.description});
}
