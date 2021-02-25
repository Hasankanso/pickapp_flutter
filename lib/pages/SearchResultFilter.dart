import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/MainRangeSlider.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Switcher.dart';

class SearchResultsFilter extends StatefulWidget {
  Function(List<Ride>) onFiltered;
  List<Ride> rides;
  FilterController controller;

  SearchResultsFilter({this.rides, this.onFiltered, this.controller});

  @override
  _SearchResultsFilterState createState() => _SearchResultsFilterState();
}

class _SearchResultsFilterState extends State<SearchResultsFilter> {
  ScrollController _scrollController = new ScrollController();
  List<bool Function(Ride)> constraints = List<bool Function(Ride)>();
  FlushbarStatus _flushbarStatus = FlushbarStatus.DISMISSED;

  @override
  void initState() {
    super.initState();
    constraints.add(priceConstraint);
    constraints.add(timeConstraint);
    constraints.add(acConstraint);
    constraints.add(smokeConstraint);
    constraints.add(petsConstraint);
    constraints.add(musicConstraint);
  }

  void reset() {
    setState(() {
      widget.controller.init();
    });
  }

  bool priceConstraint(Ride r) {
    FilterController controller = widget.controller;

    return !controller.priceController.changedAtLeastOnce ||
        r.price <= controller.priceController.maxSelected &&
            r.price >= controller.priceController.minSelected;
  }

  bool timeConstraint(Ride r) {
    FilterController controller = widget.controller;

    DateTime curr = r.leavingDate;
    DateTime maxDate = new DateTime(
        curr.year,
        curr.month,
        curr.day,
        TimeRangeSlider.toHours(controller.timeController.maxSelected.toInt()),
        TimeRangeSlider.toMinutes(controller.timeController.maxSelected.toInt()));
    DateTime minDate = new DateTime(
        curr.year,
        curr.month,
        curr.day,
        TimeRangeSlider.toHours(controller.timeController.minSelected.toInt()),
        TimeRangeSlider.toMinutes(controller.timeController.minSelected.toInt()));

    return !controller.timeController.changedAtLeastOnce ||
        r.leavingDate.isBefore(maxDate) && r.leavingDate.isAfter(minDate);
  }

  // return true means the ride should stay in the list.

  bool smokeConstraint(Ride r) {
    FilterController controller = widget.controller;
    return !controller.smokeController.filter ||
        r.smokingAllowed == controller.smokeController.allowed;
  }

  bool petsConstraint(Ride r) {
    FilterController controller = widget.controller;
    return !controller.petsController.filter ||
        r.petsAllowed == controller.petsController.allowed;
  }

  bool musicConstraint(Ride r) {
    FilterController controller = widget.controller;
    return !controller.musicController.filter ||
        r.musicAllowed == controller.musicController.allowed;
  }

  bool acConstraint(Ride r) {
    FilterController controller = widget.controller;
    return !controller.acController.filter ||
        r.acAllowed == controller.acController.allowed;
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
    FilterController controller = widget.controller;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        Lang.getString(context, "Filter"),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        controller: _scrollController,
        reverse: true,
        child: Column(children: [
          _SliderTextFilter(
            title: Lang.getString(context, "Price"),
            step: (App.stepPriceFilter as double).toInt(),
            controller: controller.priceController,
            minSelected: controller.priceController.minSelected.toInt(),
            maxSelected: controller.priceController.maxSelected.toInt(),
            absoluteMaxValue: controller.priceController.maxAbsolute.toInt(),
            key: UniqueKey(),
          ),
          _SliderTextFilter(
            title: Lang.getString(context, "Time"),
            controller: controller.timeController,
            isTime: true,
            minSelected: controller.timeController.minSelected.toInt(),
            maxSelected: controller.timeController.maxSelected.toInt(),
          ),
          ExpansionTile(
            title: Text(
              Lang.getString(context, "Advanced"),
              style: Styles.valueTextStyle(),
            ),
            initiallyExpanded: controller.isExpanded,
            children: [
              ResponsiveWidget.fullWidth(
                height: 30,
                child: Row(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 40,
                      child: IconButton(
                          alignment: Alignment.centerLeft,
                          icon: Icon(
                            Icons.info,
                            color: Styles.primaryColor(),
                            size: Styles.mediumIconSize(),
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            _showPermissionFilterHint(context);
                          }),
                    ),
                  ],
                ),
              ),
              _BooleanFilter(
                onIcon: Icons.smoking_rooms,
                offIcon: Icons.smoke_free,
                controller: controller.smokeController,
              ),
              _BooleanFilter(
                onIcon: Icons.pets,
                offIcon: Icons.pets,
                controller: controller.petsController,
              ),
              _BooleanFilter(
                onIcon: Icons.ac_unit,
                offIcon: Icons.ac_unit,
                controller: controller.acController,
              ),
              _BooleanFilter(
                onIcon: Icons.music_note,
                offIcon: Icons.music_off,
                controller: controller.musicController,
              ),
            ],
            onExpansionChanged: (newValue) {
              controller.isExpanded = newValue;
              if (newValue) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              }
            },
          ),
        ]),
      ),
      actions: [
        RaisedButton(
            child: Text(Lang.getString(context, "Reset")),
            onPressed: () {
              reset();
            }),
        RaisedButton(
            child: Text(Lang.getString(context, "Done")),
            onPressed: () {
              filter();
              widget.onFiltered(widget.rides);
              Navigator.popUntil(context, ModalRoute.withName("/RideResults"));
            }),
      ],
    );
  }

  void _showPermissionFilterHint(context) {
    if (_flushbarStatus == FlushbarStatus.DISMISSED) {
      Flushbar(
        message: Lang.getString(context, "Permission_filter_hint_text"),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        duration: Duration(seconds: 7),
        icon: Icon(
          Icons.info_outline,
          color: Styles.primaryColor(),
          size: Styles.mediumIconSize(),
        ),
        onStatusChanged: (a) {
          _flushbarStatus = a;
        },
        mainButton: IconButton(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Styles.secondaryColor(),
            size: Styles.mediumIconSize(),
          ),
        ),
      )..show(context);
    }
  }
}

class _BooleanFilterController {
  bool filter = false, allowed = false;
}

class _BooleanFilter extends StatefulWidget {
  final IconData onIcon, offIcon;
  final _BooleanFilterController controller;

  @override
  State<StatefulWidget> createState() => _BooleanFilterState();

  _BooleanFilter(
      {this.onIcon = Icons.flash_on,
      this.offIcon = Icons.flash_off,
      this.controller});
}

class _BooleanFilterState extends State<_BooleanFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: App.isLTR ? Alignment.centerLeft : Alignment.centerRight,
            child: Checkbox(
              value: widget.controller.filter,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              activeColor: Styles.primaryColor(),
              onChanged: (bool newValue) {
                setState(() {
                  widget.controller.filter = newValue;
                  widget.controller.allowed = false;
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Icon(
            widget.controller.allowed ? widget.onIcon : widget.offIcon,
            color:
                widget.controller.filter ? Styles.primaryColor() : Colors.grey,
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

class _SliderTextFilter extends StatefulWidget {
  final MainRangeSliderController controller;
  final int minSelected, maxSelected;
  final int absoluteMaxValue;
  final int step;
  final String title;
  final bool isTime;

  _SliderTextFilter({
    this.title = "title",
    this.controller,
    this.minSelected = 0,
    this.maxSelected = 100,
    this.step = 100,
    this.absoluteMaxValue = 100,
    this.isTime = false,
    Key key,
  }) : super (key : key);

  @override
  _SliderTextFilterState createState() => _SliderTextFilterState();
}

class _SliderTextFilterState extends State<_SliderTextFilter> {

  RangeLabels labels;

  void initState(){
    if(widget.isTime){
      labels = RangeLabels(TimeRangeSlider.intToTime(widget.minSelected.toInt()), TimeRangeSlider.intToTime(widget.maxSelected.toInt()));
    } else {
      labels = RangeLabels(widget.minSelected.toString(), widget.maxSelected.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveWidget(
      width: 260,
      height: 150,
      child: Card(
        color: Theme.of(context).cardColor,
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
              child: !widget.isTime
                  ? MainRangeSlider(
                      minSelected: widget.controller.minSelected,
                      maxSelected: widget.controller.maxSelected,
                      step: widget.step.toDouble(),
                      min: 0,
                      max: widget.absoluteMaxValue.toDouble(),
                      controller: widget.controller,
                onChanged : (values){
                        setState(() {
                          labels = RangeLabels(values.start.toInt().toString(), values.end.toInt().toString());
                        });
                  }
                    )
                  : TimeRangeSlider(
                      controller: widget.controller,
                      minSelected: widget.controller.minSelected,
                      maxSelected: widget.controller.maxSelected,
                  onChanged : (values){
                    setState(() {
                      labels = values;
                    });
                  }
                    ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Spacer(flex: 2),
                  Expanded(
                      flex: 10,
                      child: Center(child: Text(labels.start,  style : Styles.valueTextStyle()))),
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
                      child: Center(child: Text(labels.end , style : Styles.valueTextStyle()))),
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

class _SliderFilter extends StatefulWidget {
  final MainRangeSliderController controller;
  final int minSelected, maxSelected;
  final int absoluteMaxValue;
  final int step;
  final String title;
  final bool isTime;

  _SliderFilter({
    this.title = "title",
    this.controller,
    this.minSelected = 0,
    this.maxSelected = 100,
    this.step = 100,
    this.absoluteMaxValue = 100,
    this.isTime = false,
  });

  @override
  _SliderFilterState createState() => _SliderFilterState();
}

class _SliderFilterState extends State<_SliderFilter> {
  @override
  void initState() {
    widget.controller.values = new RangeValues(
        widget.minSelected.toDouble(), widget.maxSelected.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      width: 260,
      height: 150,
      child: Card(
        color: Theme.of(context).cardColor,
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
              child: !widget.isTime
                  ? MainRangeSlider(
                      minSelected: widget.controller.minSelected,
                      maxSelected: widget.controller.maxSelected,
                      step: widget.step.toDouble(),
                      min: 0,
                      max: widget.absoluteMaxValue.toDouble(),
                      controller: widget.controller,
                    )
                  : TimeRangeSlider(
                      controller: widget.controller,
                      minSelected: widget.controller.minSelected,
                      maxSelected: widget.controller.maxSelected,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterController {
  MainRangeSliderController priceController;
  MainRangeSliderController timeController;
  var smokeController;
  var petsController;
  var acController;
  var musicController;
  bool isExpanded;

  void init() {
    priceController.values = RangeValues(0, App.maxPriceFilter);
    priceController.changedAtLeastOnce = false;
    priceController.maxAbsolute = App.maxPriceFilter;

    timeController.values = RangeValues(0, 1439);
    timeController.changedAtLeastOnce = false;

    smokeController.filter = false;
    smokeController.allowed = false;
    petsController.filter = false;
    petsController.allowed = false;
    acController.filter = false;
    acController.allowed = false;
    musicController.filter = false;
    musicController.allowed = false;
    isExpanded = false;
  }

  FilterController() {
    priceController = new MainRangeSliderController();
    timeController = new MainRangeSliderController();
    smokeController = new _BooleanFilterController();
    petsController = new _BooleanFilterController();
    acController = new _BooleanFilterController();
    musicController = new _BooleanFilterController();
    isExpanded = false;
    init();
  }
}
