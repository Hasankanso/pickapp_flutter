import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MainRangeSlider extends StatefulWidget {
  double min, max, minSelected, maxSelected, step;
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
    // TODO: implement initState
    widget.controller._values = SfRangeValues(
        widget.minSelected.toDouble(), widget.maxSelected.toDouble());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfRangeSlider(
      min: widget.min.toDouble(),
      max: widget.max.toDouble(),
      stepSize: widget.step.toDouble(),
      showTooltip: true,
      tooltipShape: SfPaddleTooltipShape(),
      values: widget.controller._values,
      onChanged: (SfRangeValues newValues) {
        setState(() {
          widget.controller._values = newValues;
        });
      },
    );
  }
}

class MainRangeSliderController {
  SfRangeValues _values;
  get minValue => _values.start;
  get maxValue => _values.end;
}
