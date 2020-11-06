import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  bool _isBirthdayPicker;
  DateTime startDate;
  final DateTimeController _controller;
  final VoidCallback callBack;
  DateTimePicker(this._isBirthdayPicker, this._controller,
      {this.callBack, this.startDate});

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime _minDate, _maxDate, _initialDate;
  Locale _appLocale;
  Map<String, LocaleType> localeType = {
    "en": LocaleType.en,
    "ar": LocaleType.ar,
    "fr": LocaleType.fr,
  };


  selectDate(BuildContext context) async {
    if (widget._isBirthdayPicker) {
      //max 100 year
      _minDate = DateTime.now().subtract(Duration(days: 36500));
      //initial date is 18 years
      _initialDate = widget._controller.chosenDate;
      //min 13 years
      _maxDate = DateTime.now().subtract(Duration(days: 5110));
    } else {
      if (widget.startDate == null) {
        _minDate = DateTime.now();
      } else {
        _minDate = widget.startDate;
      }
      _initialDate = widget._controller.chosenDate;
      //max is one year
      _maxDate = DateTime.now().add(Duration(days: 365));
    }

    if (Platform.isIOS) {
      DatePicker.showDatePicker(
        context,
        locale: localeType[_appLocale.toString()],
        minTime: _minDate,
        maxTime: _maxDate,
        currentTime: _initialDate,
        onConfirm: (date) {
          _setDate(date);
        },
      );
    } else if (Platform.isAndroid) {
      DateTime date = await showDatePicker(
        context: context,
        firstDate: _minDate,
        locale: _appLocale,
        lastDate: _maxDate,
        initialDate: _initialDate,
      );
      if (date != null) _setDate(date);
    }
  }

  selectTime(BuildContext context, date) async {
    DateTime currentTime;
    currentTime = widget._controller.chosenDate;
    if (Platform.isIOS) {
      DatePicker.showTime12hPicker(
        context,
        locale: localeType[_appLocale.toString()],
        currentTime: currentTime,
        onConfirm: (time) {
          _setTime(date, time);
        },
      );
    } else if (Platform.isAndroid) {
      TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentTime),
      );
      if (time != null) _setTime(date, time);
    }
  }

  _setDate(date) {
    setState(() {
      if (widget._isBirthdayPicker) {
        widget._controller.chosenDate = date;
      } else {
        selectTime(context, date);
      }
    });
  }

  _setTime(date, time) {
    setState(() {
      widget._controller.chosenDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (widget.callBack != null) widget.callBack();
    });
  }

  Widget build(BuildContext context) {
    _appLocale = Localizations.localeOf(context);
    final _deviceSize = MediaQuery.of(context);
    String dateFormat;
    if (widget._isBirthdayPicker) {
      dateFormat = 'dd/MM/yyyy';
    } else {
      dateFormat = 'dd/MM/yyyy hh:mm a';
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
          onTap: () {
            selectDate(context);
          },
          child: Container(
            height: _deviceSize.size.height * 0.09,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(
                      3.0) //                 <--- border radius here
                  ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(9.0),
                  child: Icon(
                    Icons.date_range_rounded,
                    size: _deviceSize.size.height * 0.04,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat(dateFormat, _appLocale.toString())
                      .format(widget._controller.chosenDate),
                  style: TextStyle(
                      fontSize: _deviceSize.size.height * 0.03,
                      color: Colors.blue),
                ),
              ],
            ),
          )),
    );
  }
}

class DateTimeController {
  DateTime chosenDate;
  DateTimeController([isBirthdayPicker]) {
    if (isBirthdayPicker == true) {
      DateTime initialDate = DateTime.now();
      chosenDate =
          DateTime(initialDate.year - 18, initialDate.month, initialDate.day);
    }
  }
}
