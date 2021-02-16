import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Responsive.dart';

class DateTimePicker extends StatefulWidget {
  DateTime startDate;
  final DateTimeController _controller;
  final VoidCallback callBack;
  DateTimePicker(this._controller, {this.callBack, this.startDate});

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
    if (widget.startDate == null) {
      _minDate = DateTime.now();
    } else {
      _minDate = widget.startDate;
    }
    if (_initialDate == null || _initialDate.isAfter(_minDate)) {
      _initialDate = widget._controller.chosenDate;
    } else {
      _initialDate = _minDate;
    }
    //max is one year
    _maxDate = DateTime.now().add(Duration(days: 365));

    if (App.isIphone()) {
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
    } else if (App.isAndroid()) {
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
    if (App.isIphone()) {
      DatePicker.showTime12hPicker(
        context,
        locale: localeType[_appLocale.toString()],
        currentTime: currentTime,
        onConfirm: (time) {
          _setTime(date, time);
        },
      );
    } else if (App.isAndroid()) {
      TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentTime),
      );
      if (time != null) _setTime(date, time);
    }
  }

  _setDate(date) {
    selectTime(context, date);
  }

  _setTime(date, time) {
    setState(() {
      var chosenD =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (chosenD.compareTo(DateTime.now()) >= 0) {
        widget._controller.chosenDate =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
      } else {
        widget._controller.chosenDate = DateTime.now();
      }

      if (widget.callBack != null) widget.callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    _appLocale = Localizations.localeOf(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        color: Theme.of(context).cardColor,
        child: DifferentSizeResponsiveRow(
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
              flex: 18,
              child: Text(
                DateFormat(App.dateFormat, _appLocale.toString())
                    .format(widget._controller.chosenDate),
                style: Styles.valueTextStyle(),
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                Lang.getString(context, "Change"),
                style: Styles.headerTextStyle(),
              ),
            ),
          ],
        ),
        onPressed: () {
          selectDate(context);
        },
      ),
    );
  }
}

class DateTimeController {
  DateTime chosenDate;
  DateTimeController({this.chosenDate}) {
    if (chosenDate == null) {
      this.chosenDate = DateTime.now().add(Duration(
        minutes: 20,
      ));
    } else {
      this.chosenDate = chosenDate;
    }
  }
}
