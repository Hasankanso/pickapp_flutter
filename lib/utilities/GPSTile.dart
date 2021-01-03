import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickapp/classes/Localizations.dart';

class GPSTile extends StatelessWidget {
  Location location;
  final ValueChanged<Location> onTap;

  GPSTile({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.gps_fixed),
      title: Text(Lang.getString(context, "My_Current_Location")),
      onTap: () {
        if (onTap != null) {
          getLocation().then((value) => {
                if (value != null) {onTap(value)}
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
      return null;
    }
    print(position.latitude);
    return new Location(position.latitude, position.longitude);
  }
}

class GPSListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<dynamic> onTap;

  GPSListView({@required this.predictions, this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    list.add(GPSTile(onTap: onTap));
    list.addAll(predictions
        .map((Prediction p) => PredictionTile(prediction: p, onTap: onTap)));
    return ListView(
      children: list,
    );
  }
}
