import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainRangeSlider extends StatefulWidget {
  double minSelected, maxSelected;
  double min, max, step;
  MainRangeSliderController controller;

  MainRangeSlider({
    this.min = 0,
    this.max = 100,
    this.minSelected = 20,
    this.maxSelected = 80,
    this.step = 10,
    this.controller,
  });

  @override
  _MainRangeSliderState createState() => _MainRangeSliderState();
}

class _MainRangeSliderState extends State<MainRangeSlider> {
  @override
  void initState() {
    widget.controller.values = RangeValues(
      widget.minSelected.toDouble(),
      widget.maxSelected.toDouble(),
    );
    widget.controller.minAbsolute = widget.min;
    widget.controller.maxAbsolute = widget.max;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
          ),
          child: RangeSlider(
            values: widget.controller.values,
            min: widget.controller.minAbsolute,
            max: widget.controller.maxAbsolute,
            divisions: widget.step.toInt(),
            labels: RangeLabels(
                widget.controller.minSelected.toInt().toString(),
                widget.controller.maxSelected.toInt().toString()),
            onChanged: (values) {
              setState(() {
                widget.controller.changedAtLeastOnce = true;
                widget.controller.values = values;
              });
            },
          ),
        ),
      ],
    );
  }
}

class TimeRangeSlider extends StatefulWidget {
  double minSelected, maxSelected;
  MainRangeSliderController controller;

  TimeRangeSlider({
    this.minSelected = 20,
    this.maxSelected = 80,
    this.controller,
  });

  @override
  _TimeRangeSliderState createState() => _TimeRangeSliderState();
}

class _TimeRangeSliderState extends State<TimeRangeSlider> {
  @override
  void initState() {
    widget.controller.values = RangeValues(
      widget.minSelected.toDouble(),
      widget.maxSelected.toDouble(),
    );
    widget.controller.minAbsolute = 0;
    widget.controller.maxAbsolute = 1440;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
          ),
          child: RangeSlider(
            values: widget.controller.values,
            min: 0,
            max: 1440,
            divisions: 288,
            labels: RangeLabels(
                intToTime(widget.controller.minSelected.toInt()),
                intToTime(widget.controller.maxSelected.toInt())),
            onChanged: (values) {
              setState(() {
                widget.controller.changedAtLeastOnce = true;
                widget.controller.values = values;
              });
            },
          ),
        ),
      ],
    );
  }
}

NumberFormat formatter = new NumberFormat("00");
String intToTime(int number) {
  assert(number >= 0);
  assert(number <= 1440);
  var f = new NumberFormat();
  int minutes = number % 60;
  int hours = (number / 60).floor();
  return formatter.format(hours) + ":" + formatter.format(minutes);
}

int toMinutes(int number) {
  return number % 60;
}

int toHours(int number) {
  return (number / 60).floor();
}

class MainRangeSliderController {
  RangeValues values;
  double minAbsolute;
  double maxAbsolute;
  bool changedAtLeastOnce;

  double get minSelected => values.start;

  double get maxSelected => values.end;

  MainRangeSliderController(){
    changedAtLeastOnce = false;
  }

}
