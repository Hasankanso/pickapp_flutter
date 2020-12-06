import 'package:flutter/material.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/utilities/DateTimePicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class DateTimeRangePicker extends StatefulWidget {
  DateTimeRangeController _controller;
  DateTimeRangePicker(this._controller);
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
              child: DateTimePicker(
                  false, widget._controller.startDateController,
                  callBack: _startDatePicked),
            ),
            Visibility(
              visible: Cache.dateTimeRangePicker,
              child: Spacer(
                flex: 3,
              ),
            ),
            Visibility(
              visible: Cache.dateTimeRangePicker,
              child: Expanded(
                flex: 10,
                child: DateTimePicker(
                  false,
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
    this.startDateController.chosenDate = DateTime.now().add(Duration(
      minutes: 20,
    ));
    this.endDateController.chosenDate =
        this.startDateController.chosenDate.add(Duration(days: 1));
  }
}
