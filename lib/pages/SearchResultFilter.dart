import 'package:flutter/material.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/MainRangeSlider.dart';

class SearchResultsFilter extends StatelessWidget {
  MainRangeSliderController sliderController = new MainRangeSliderController();

  Function(List<Ride>) onFiltered;
  List<Ride> rides;
  List<bool Function(Ride)> constraints = new List<bool Function(Ride)>();

  SearchResultsFilter({this.rides, this.onFiltered});

  //add boolean function here, see priceConstraint example
  void init() {
    constraints.add(priceConstraint);
  }

  bool priceConstraint(Ride r) {
    return r.price <= sliderController.maxValue &&
        r.price >= sliderController.minValue;
  }


  bool validate(Ride r) {
    for (var constraint in constraints) {
      if (!constraint(r)) return false;
    }
    return true;
  }

  void filter() {
    rides = rides.where((element) => validate(element)).toList();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return AlertDialog(
        title: Text("filter"),
        content: Column(children: [
          Text("price"),
          MainRangeSlider(
              min: 0,
              max: 100000,
              step: 100,
              maxSelected: 10000,
              controller: sliderController),
          RaisedButton(
              child: Text("Done"),
              onPressed: () {
                filter();
                onFiltered(rides);
                Navigator.pop(context);
              })
        ]));
  }
}
