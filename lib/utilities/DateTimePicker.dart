import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

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
      DateTime initialDate = DateTime.now();
      //max age 100 year
      _minDate =
          DateTime(initialDate.year - 100, initialDate.month, initialDate.day);
      //initial age is 18 years
      _initialDate = widget._controller.chosenDate;
      //min age 14 years
      _maxDate =
          DateTime(initialDate.year - 14, initialDate.month, initialDate.day);
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

  _setDate(date) {
    setState(() {
      widget._controller.chosenDate = date;
      if (widget.callBack != null) widget.callBack();
    });
  }

  Widget build(BuildContext context) {
    _appLocale = Localizations.localeOf(context);
    final _deviceSize = MediaQuery.of(context);
    return Container(
      height: _deviceSize.size.height * 0.075,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(-1, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(
              Icons.date_range_rounded,
              size: Styles.mediumIconSize(),
              color: Styles.primaryColor(),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              DateFormat(App.dateFormat, _appLocale.toString())
                  .format(widget._controller.chosenDate),
              style: Styles.valueTextStyle(),
            ),
          ),
          GestureDetector(
            onTap: () {
              selectDate(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 7.0, left: 7.0),
              child: Text(
                Lang.getString(context, "Change"),
                style: Styles.headerTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeController {
  DateTime chosenDate;
  DateTimeController() {
    DateTime initialDate = DateTime.now();
    chosenDate =
        DateTime(initialDate.year - 18, initialDate.month, initialDate.day);
  }
}
