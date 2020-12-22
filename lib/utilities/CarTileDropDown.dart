import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'MainExpansionTile.dart';

class CarTileDropDown extends StatefulWidget {
  final String carName;
  final Car car;
  final Function a;

  const CarTileDropDown({Key key, this.carName, this.car, this.a}) : super(key: key);

  @override
  _CarTileDropDownState createState() => _CarTileDropDownState(a);
}

class _CarTileDropDownState extends State<CarTileDropDown> {
  final Function a;
  _CarTileDropDownState(this.a);

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 0.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),

        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.directions_car,
              size: Styles.mediumIconSize(), color: Styles.primaryColor()),
        ),
        title: Row(
          children: [
            Text(
              "Car : " + widget.carName,
              style: Styles.labelTextStyle(),
            ),
          ],
        ),
        onTap: () {
          MainExpansionTileState.of(context).collapse();
          a();
          setState(() {});
        },
      ),
    );
  }
}
