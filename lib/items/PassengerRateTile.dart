import 'package:flutter/material.dart';
import 'package:pickapp/dataObjects/Reservation.dart';

class PassengerRateTile extends ListTile {
  final Reservation reservation;

  PassengerRateTile(this.reservation);

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(reservation.toString()));
  }

  static Function(BuildContext, int) createPassengersItems(List<Reservation> passengers) {
    return (context, index) {
      return PassengerRateTile(passengers[index]);
    };
  }
}
