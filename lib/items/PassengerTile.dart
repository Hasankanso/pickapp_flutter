import 'package:flutter/material.dart';
import 'package:pickapp/dataObjects/Passenger.dart';

class PassengerTile extends ListTile {
  Passenger passenger;

  PassengerTile(this.passenger);

  static Function(BuildContext, int) itemBuilder(List<Passenger> p) {
    return (context, index) {
      return PassengerTile(p[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container());
  }
}
