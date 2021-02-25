import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

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
