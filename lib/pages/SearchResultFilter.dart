import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/MainRangeSlider.dart';
import 'package:pickapp/utilities/Responsive.dart';

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
        title: Text(
          Lang.getString(context, "Filter"),
          textAlign: TextAlign.center,
        ),
        content: Column(children: [
          FilterSlider(
            controller: sliderController,
            leftValue: 0,
            rightValue: 100000,
            maxValue: 100000,
          ),
          RaisedButton(
              child: Text(Lang.getString(context, "Done")),
              onPressed: () {
                filter();
                onFiltered(rides);
                Navigator.pop(context);
              })
        ]));
  }
}

class FilterSlider extends StatefulWidget {
  MainRangeSliderController controller;
  int leftValue = 0, rightValue = 100;
  int maxValue = 100;
  int step;

  FilterSlider(
      {this.controller,
      this.leftValue = 0,
      this.rightValue = 100,
      this.step = 100,
      this.maxValue = 100});

  @override
  _FilterSliderState createState() => _FilterSliderState();
}

class _FilterSliderState extends State<FilterSlider> {
  TextEditingController minValueController = new TextEditingController();
  TextEditingController maxValueController = new TextEditingController();

  @override
  void initState() {
    minValueController.text = widget.leftValue.toString();
    maxValueController.text = widget.rightValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      width: 260,
      height: 150,
      child: Card(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Lang.getString(context, "Price"),
                    style: Styles.valueTextStyle(),
                  )),
            ),
            Expanded(
              flex: 4,
              child: MainRangeSlider(
                  minSelected: widget.leftValue.toDouble(),
                  maxSelected: widget.rightValue.toDouble(),
                  step: widget.step.toDouble(),
                  min: 0,
                  max: widget.maxValue.toDouble(),
                  controller: widget.controller,
              onChanged: (values){
                    minValueController.text = values.start.toString();
                    maxValueController.text = values.end.toString();
              },),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Spacer(flex: 2),
                  Expanded(
                      flex: 10,
                      child: TextField(
                        style: Styles.valueTextStyle(),
                        keyboardType: TextInputType.number,
                        controller: minValueController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.leftValue = int.parse(value);
                          });
                        },
                      )),
                  Spacer(flex: 1),
                  Expanded(
                      flex: 4,
                      child: Text(
                        "-",
                        textAlign: TextAlign.center,
                      )),
                  Spacer(flex: 1),
                  Expanded(
                      flex: 10,
                      child: TextField(
                        style: Styles.valueTextStyle(),
                        keyboardType: TextInputType.number,
                        controller: maxValueController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.rightValue = int.parse(value);
                          });
                        },
                      )),
                  Spacer(flex: 2),
                ],
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
