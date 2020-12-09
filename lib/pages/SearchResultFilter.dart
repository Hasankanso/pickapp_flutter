import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/MainRangeSlider.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Switcher.dart';

class SearchResultsFilter extends StatefulWidget {
  Function(List<Ride>) onFiltered;
  List<Ride> rides;

  SearchResultsFilter({this.rides, this.onFiltered});

  @override
  _SearchResultsFilterState createState() => _SearchResultsFilterState();
}

class _SearchResultsFilterState extends State<SearchResultsFilter> {
  MainRangeSliderController sliderController = new MainRangeSliderController();
  MainRangeSliderController timeController = new MainRangeSliderController();

  List<bool Function(Ride)> constraints = new List<bool Function(Ride)>();

  var smokeController = new _BooleanFilterController();
  var petsController = new _BooleanFilterController();
  var acController = new _BooleanFilterController();
  var musicController = new _BooleanFilterController();

  void init() {
    constraints.add(priceConstraint);
    constraints.add(smokeConstraint);
    constraints.add(petsConstraint);
    constraints.add(musicConstraint);
    constraints.add(acConstraint);
  }

  bool priceConstraint(Ride r) {
    return r.price <= sliderController.maxValue &&
        r.price >= sliderController.minValue;
  }

  bool smokeConstraint(Ride r) {
    return !smokeController.filter || r.smokingAllowed == smokeController.allowed;
  }

  bool petsConstraint(Ride r) {
    return !petsController.filter || r.petsAllowed == petsController.allowed;
  }

  bool musicConstraint(Ride r) {
    return !musicController.filter || r.musicAllowed== musicController.allowed;
  }

  bool acConstraint(Ride r) {
    return !acController.filter || r.acAllowed == acController.allowed;
  }

  bool validate(Ride r) {
    for (var constraint in constraints) {
      if (!constraint(r)) return false;
    }
    return true;
  }

  void filter() {
    widget.rides = widget.rides.where((element) => validate(element)).toList();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return AlertDialog(
      title: Text(
        Lang.getString(context, "Filter"),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(children: [
          _SliderFilter(
            title: Lang.getString(context, "Price"),
            controller: sliderController,
            leftValue: 0,
            rightValue: 100000,
            aboluteMaxValue: 100000,
          ),
          _SliderFilter(
            title: Lang.getString(context, "Time"),
            controller: timeController,
            leftValue: 0,
            rightValue: 2359,
            aboluteMaxValue: 2359,
          ),
          _BooleanFilter(
              onIcon: Icons.smoking_rooms,
              offIcon: Icons.smoke_free,
              controller: smokeController),
          _BooleanFilter(
              onIcon: Icons.pets,
              offIcon: Icons.pets,
              controller: petsController),
          _BooleanFilter(
              onIcon: Icons.ac_unit,
              offIcon: Icons.ac_unit,
              controller: acController),
          _BooleanFilter(
              onIcon: Icons.music_note,
              offIcon: Icons.music_off,
              controller: musicController),
        ]),
      ),
      actions: [
        RaisedButton(
            child: Text(Lang.getString(context, "Reset")),
            onPressed: () {
              filter();
              widget.onFiltered(widget.rides);
              Navigator.pop(context);
            }),
        RaisedButton(
            child: Text(Lang.getString(context, "Done")),
            onPressed: () {
              filter();
              widget.onFiltered(widget.rides);
              Navigator.pop(context);
            }),
      ],
    );
  }
}

class _BooleanFilterController {
  bool filter = false, allowed = false;
}

class _BooleanFilter extends StatefulWidget {
  IconData onIcon, offIcon;
  _BooleanFilterController controller;

  @override
  State<StatefulWidget> createState() => _BooleanFilterState();

  _BooleanFilter(
      {this.onIcon = Icons.flash_on,
      this.offIcon = Icons.flash_off,
      this.controller});
}

class _BooleanFilterState extends State<_BooleanFilter> {
  Color iconColor = Colors.grey;
  IconData currIcon;

  @override
  void initState() {
    currIcon = widget.offIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              value: widget.controller.filter,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onChanged: (bool newValue) {
                setState(() {
                  widget.controller.filter = newValue;
                  if (!newValue) {
                    widget.controller.allowed = false;
                    currIcon = widget.offIcon;
                    iconColor = Colors.grey;
                  } else {
                    iconColor = Styles.primaryColor();
                  }
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Icon(
            currIcon,
            color: iconColor,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AbsorbPointer(
            absorbing: !widget.controller.filter,
            child: Switcher(
              isOn: widget.controller.allowed,
              onChanged: (value) {
                setState(() {
                  currIcon = value == true ? widget.onIcon : widget.offIcon;
                  widget.controller.allowed = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SliderFilter extends StatefulWidget {
  MainRangeSliderController controller;
  int leftValue = 0, rightValue = 100;
  int aboluteMaxValue = 100;
  int step;
  String title;

  _SliderFilter(
      {this.title = "title",
      this.controller,
      this.leftValue = 0,
      this.rightValue = 100,
      this.step = 100,
      this.aboluteMaxValue = 100});

  @override
  _SliderFilterState createState() => _SliderFilterState();
}

class _SliderFilterState extends State<_SliderFilter> {
  TextEditingController minValueController = new TextEditingController();
  TextEditingController maxValueController = new TextEditingController();

  @override
  void initState() {
    widget.controller.values = new RangeValues(widget.leftValue.toDouble(), widget.rightValue.toDouble());
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
                    widget.title,
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
                max: widget.aboluteMaxValue.toDouble(),
                controller: widget.controller,
                onChanged: (values) {
                  int start = values.start.toInt();
                  int end = values.end.toInt();

                  minValueController.text = start.toString();
                  maxValueController.text = end.toString();
                  widget.leftValue = start;
                  widget.rightValue = end;
                },
              ),
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
                            print("triggered");
                            int newValue = int.parse(value);
                            if (newValue < widget.rightValue && newValue > 0) {
                              widget.leftValue = newValue;
                            } else {
                              minValueController.text =
                                  widget.leftValue.toString();
                              minValueController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: minValueController.text.length));
                            }
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
                            int newValue = int.parse(value);
                            if (newValue > widget.leftValue &&
                                newValue < widget.aboluteMaxValue) {
                              widget.rightValue = newValue;
                            } else {
                              maxValueController.text =
                                  widget.rightValue.toString();
                              maxValueController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: maxValueController.text.length));
                            }
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
