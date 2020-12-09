import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainRangeSlider extends StatefulWidget {
  double min, max, minSelected, maxSelected, step;
  MainRangeSliderController controller;
  Function(RangeValues) onChanged;

  MainRangeSlider({
    this.min = 0,
    this.max = 100,
    this.minSelected = 20,
    this.maxSelected = 80,
    this.step = 10,
    this.controller,
    this.onChanged,
  });
  @override
  _MainRangeSliderState createState() => _MainRangeSliderState();

}

class _MainRangeSliderState extends State<MainRangeSlider> {
  @override
  void initState() {
    // TODO: implement initState
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
            values: RangeValues(
              widget.minSelected.toDouble(),
              widget.maxSelected.toDouble(),
            ),
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
            divisions: widget.step.toInt(),
            labels: RangeLabels(widget.minSelected.toInt().toString(),
                widget.maxSelected.toInt().toString()),
            onChanged: (values) {
              setState(() {
                widget.controller.values = values;
                widget.minSelected = values.start.roundToDouble();
                widget.maxSelected = values.end.roundToDouble();
                if(widget.onChanged != null) {
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

class MainRangeSliderController {
  RangeValues values;
  get minValue => values.start;
  get maxValue => values.end;
}
