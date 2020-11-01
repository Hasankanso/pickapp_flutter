import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  bool _isBirthdayPicker;
  String _title;
  DateTimeController _controller;
  DateTimePicker(this._isBirthdayPicker, this._title, this._controller);
  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime _chosenDate;
  bool _isBirthdayPicker;
  String _dateHolder;
  DateTime _minDate, _maxDate, _initialDate;
  Locale _appLocale;
  Map<String, LocaleType> localeType = {
    "en": LocaleType.en,
    "ar": LocaleType.ar,
    "fr": LocaleType.fr,
  };

  selectDate(BuildContext context) async {
    _isBirthdayPicker = widget._isBirthdayPicker;
    if (_isBirthdayPicker == true) {
      //max 100 year
      _minDate = DateTime.now().subtract(Duration(days: 36500));
      //initial date is 18 years
      _initialDate = DateTime.now().subtract(Duration(days: 6570));
      //min 13 years
      _maxDate = DateTime.now().subtract(Duration(days: 5110));
    } else {
      _initialDate = DateTime.now();
      _minDate = DateTime.now();
      //max is one year
      _maxDate = DateTime.now().add(Duration(days: 365));
    }

    if (!Platform.isIOS) {
      DatePicker.showDatePicker(context,
          showTitleActions: true,
          locale: localeType[_appLocale.toString()],
          minTime: _minDate,
          maxTime: _maxDate,
          currentTime: _initialDate, onConfirm: (date) {
        _setDate(date);
      });
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
    if (!Platform.isIOS) {
      DatePicker.showTime12hPicker(
        context,
        locale: localeType[_appLocale.toString()],
        currentTime: DateTime.now(),
        onConfirm: (time) {
          _setTime(date, time);
        },
      );
    } else if (Platform.isAndroid) {
      TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) _setTime(date, time);
    }
  }

  _setTime(date, time) {
    setState(() {
      _chosenDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      widget._controller._chosenDate = _chosenDate;
      _dateHolder = DateFormat('dd/MM/yyyy hh:mm a', _appLocale.toString())
          .format(_chosenDate);
    });
  }

  _setDate(date) {
    setState(() {
      if (_isBirthdayPicker == true) {
        _chosenDate = date;
        widget._controller._chosenDate = _chosenDate;
        _dateHolder =
            DateFormat('dd/MM/yyyy', _appLocale.toString()).format(date);
      } else {
        selectTime(context, date);
      }
    });
  }

  Widget build(BuildContext context) {
    _appLocale = Localizations.localeOf(context);
    final _deviceSize = MediaQuery.of(context);
    _dateHolder = widget._title;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                  "$_dateHolder",
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
  DateTime _chosenDate;
}
