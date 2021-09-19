import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainRangeSlider extends StatefulWidget {
  double minSelected, maxSelected;
  double min, max, step;
  MainRangeSliderController controller;
  Function(RangeValues) onChanged;

  MainRangeSlider({
    this.min = 0,
    this.max = 100,
    this.minSelected = 20,
    this.maxSelected = 80,
    this.step = 100,
    this.controller,
    this.onChanged,
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
            divisions: widget.controller.maxAbsolute ~/ widget.step,
            labels: RangeLabels(widget.controller.minSelected.toInt().toString(),
                widget.controller.maxSelected.toInt().toString()),
            onChanged: (values) {
              setState(() {
                widget.controller.changedAtLeastOnce = true;
                widget.controller.values = values;
                if (widget.onChanged != null) {
                  widget.onChanged(values);
                }
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
  final MainRangeSliderController controller;
  final Function(RangeLabels) onChanged;

  static final NumberFormat _formatter = new NumberFormat("00");

  static String intToTime(int number) {
    assert(number >= 0);
    assert(number <= 1439);
    var f = new NumberFormat();
    int minutes = number % 60;
    int hours = (number / 60).floor();
    return _formatter.format(hours) + ":" + _formatter.format(minutes);
  }

  static int toMinutes(int number) {
    return number % 60;
  }

  static int toHours(int number) {
    return (number / 60).floor();
  }

  TimeRangeSlider({
    this.minSelected = 20,
    this.maxSelected = 80,
    this.controller,
    this.onChanged,
  });

  @override
  _TimeRangeSliderState createState() => _TimeRangeSliderState();
}

class _TimeRangeSliderState extends State<TimeRangeSlider> {
  RangeLabels labels;

  @override
  void initState() {
    widget.controller.values = RangeValues(
      widget.minSelected.toDouble(),
      widget.maxSelected.toDouble(),
    );
    widget.controller.minAbsolute = 0;
    widget.controller.maxAbsolute = 1439;

    labels = RangeLabels(TimeRangeSlider.intToTime(widget.controller.minSelected.toInt()),
        TimeRangeSlider.intToTime(widget.controller.maxSelected.toInt()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
            rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
          ),
          child: RangeSlider(
            values: widget.controller.values,
            min: 0,
            max: 1439,
            divisions: 288,
            labels: labels,
            onChanged: (values) {
              setState(() {
                widget.controller.changedAtLeastOnce = true;
                widget.controller.values = values;
                labels = RangeLabels(
                    TimeRangeSlider.intToTime(widget.controller.minSelected.toInt()),
                    TimeRangeSlider.intToTime(widget.controller.maxSelected.toInt()));

                if (widget.onChanged != null) {
                  widget.onChanged(labels);
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class MainRangeSliderController {
  RangeValues values;
  double minAbsolute;
  double maxAbsolute;
  bool changedAtLeastOnce;

  double get minSelected => values.start;

  double get maxSelected => values.end;

  MainRangeSliderController() {
    changedAtLeastOnce = false;
  }
}
