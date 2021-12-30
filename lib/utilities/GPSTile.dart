import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Spinner.dart';

class GPSTile extends StatefulWidget {
  final ValueChanged<Location> onTap;

  GPSTile({@required this.onTap});

  @override
  _GPSTileState createState() => _GPSTileState();
}

class _GPSTileState extends State<GPSTile> {
  Location location;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.gps_fixed),
      title: Text(Lang.getString(context, "My_Current_Location")),
      trailing: isLoading
          ? ResponsiveWidget(
              height: 20,
              width: 20,
              child: Spinner(
                strokeWidth: 3.0,
              ))
          : null,
      onTap: () {
        if (widget.onTap != null && !isLoading) {
          setState(() {
            isLoading = true;
          });
          getLocation().then((value) {
            setState(() {
              isLoading = false;
            });
            if (value != null) {
              widget.onTap(value);
            }
          });
        }
      },
    );
  }

  Future<Location> getLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (PlatformException) {
      Geolocator.openAppSettings();
      return null;
    }
    return new Location(lat: position.latitude, lng: position.longitude);
  }
}

class GPSListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<dynamic> onTap;
  final canPickCurrLocation;

  GPSListView(
      {@required this.predictions,
      this.onTap,
      this.canPickCurrLocation = true});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (canPickCurrLocation) {
      list.add(GPSTile(onTap: onTap));
    }
    list.addAll(predictions
        .map((Prediction p) => PredictionTile(prediction: p, onTap: onTap)));
    return ListView(
      children: list,
    );
  }
}

class LoadingListView extends StatelessWidget {
  final List<Prediction> predictions;
  final canPickCurrLocation;

  LoadingListView(
      {@required this.predictions, this.canPickCurrLocation = true});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(Container(
        constraints: BoxConstraints(maxHeight: 2.0),
        child: LinearProgressIndicator()));
    if (canPickCurrLocation) {
      list.add(GPSTile());
    }
    list.addAll(
        predictions.map((Prediction p) => PredictionTile(prediction: p)));
    return ListView(
      children: list,
    );
  }
}
