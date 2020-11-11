import 'package:flutter/material.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/utilities/DateTimePicker.dart';

class DateTimeRangePicker extends StatefulWidget {
  DateTimeRangeController _controller;
  DateTimeRangePicker(this._controller);
  @override
  DateTimeRangePickerState createState() => DateTimeRangePickerState();
}

class DateTimeRangePickerState extends State<DateTimeRangePicker> {
  bool _show = false;
  bool _isEndDateChanged = false;
  @override
  initState() {
    Cache.getDateTimeRangePicker().then((String isRangePicker) => setState(() {
          if (isRangePicker == null) {
            _show = false;
            return;
          }
          _show = isRangePicker == "true";
        }));
  }

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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 8,
              child: DateTimePicker(
                  false, widget._controller.startDateController,
                  callBack: _startDatePicked),
            ),
          ],
        ),
        Visibility(
          visible: true,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: DateTimePicker(
                  false,
                  widget._controller.endDateController,
                  startDate: widget._controller.startDateController.chosenDate,
                  callBack: _endDatePicked,
                ),
              ),
            ],
          ),
        ),
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
