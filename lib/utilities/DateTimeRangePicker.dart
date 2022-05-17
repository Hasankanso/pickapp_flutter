import 'package:flutter/material.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/utilities/DateTimePicker.dart';
import 'package:just_miles/utilities/Responsive.dart';

class DateTimeRangePicker extends StatefulWidget {
  DateTimeRangeController _controller;
  bool showRange;

  DateTimeRangePicker(this._controller, {this.showRange});
  @override
  DateTimeRangePickerState createState() => DateTimeRangePickerState();
}

class DateTimeRangePickerState extends State<DateTimeRangePicker> {
  bool _isEndDateChanged = false;

  _startDatePicked() {
    setState(() {
      if (widget._controller.endDateController.chosenDate
          .isBefore(widget._controller.startDateController.chosenDate)) {
        widget._controller.endDateController.chosenDate = widget
            ._controller.startDateController.chosenDate
            .add(Duration(days: 1));
      } else if (!_isEndDateChanged) {
        widget._controller.endDateController.chosenDate = widget
            ._controller.startDateController.chosenDate
            .add(Duration(days: 1));
      }
    });
  }

  _endDatePicked() {
    _isEndDateChanged = true;
    if (widget._controller.endDateController.chosenDate
        .isBefore(widget._controller.startDateController.chosenDate)) {
      setState(() {
        widget._controller.endDateController.chosenDate = widget
            ._controller.startDateController.chosenDate
            .add(Duration(days: 1));
      });
    }
  }

  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: [
        Column(
          children: [
            Expanded(
              flex: 10,
              child: DateTimePicker(widget._controller.startDateController,
                  callBack: _startDatePicked),
            ),
            Visibility(
              visible:
                  widget.showRange != true ? Cache.dateTimeRangePicker : true,
              child: Spacer(
                flex: 3,
              ),
            ),
            Visibility(
              visible:
                  widget.showRange != true ? Cache.dateTimeRangePicker : true,
              child: Expanded(
                flex: 10,
                child: DateTimePicker(
                  widget._controller.endDateController,
                  startDate: widget._controller.startDateController.chosenDate,
                  callBack: _endDatePicked,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class DateTimeRangeController {
  DateTimeController startDateController = new DateTimeController();
  DateTimeController endDateController = new DateTimeController();
  DateTimeRangeController() {
    this.startDateController.chosenDate =
        DateTimePicker.nowWithoutSec().add(Duration(
      minutes: 20,
    ));
    this.endDateController.chosenDate =
        this.startDateController.chosenDate.add(Duration(days: 1));
  }
}
