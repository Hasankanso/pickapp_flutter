import 'package:flutter/material.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/utilities/Responsive.dart';

import '../utilities/MainExpansionTile.dart';

class CarTileDropDown extends StatefulWidget {
  final String carName;
  final Car car;
  final Function a;

  const CarTileDropDown({Key key, this.carName, this.car, this.a})
      : super(key: key);

  @override
  _CarTileDropDownState createState() => _CarTileDropDownState(a);
}

class _CarTileDropDownState extends State<CarTileDropDown> {
  final Function a;
  _CarTileDropDownState(this.a);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 70,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          leading: Icon(Icons.directions_car,
              size: Styles.mediumIconSize(), color: Styles.primaryColor()),
          title: Text(
            "Car : " + widget.carName,
            style: Styles.labelTextStyle(),
          ),
          onTap: () {
            MainExpansionTileState.of(context).collapse();
            a();
            setState(() {});
          },
        ),
      ),
    );
  }
}
