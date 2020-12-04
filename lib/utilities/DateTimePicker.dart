import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Responsive.dart';

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
      if (widget.startDate == null) {
        //initial age is 18 years
        _initialDate = widget._controller.chosenDate;
      } else {
        _initialDate = widget.startDate;
      }

      DateTime initialDate = DateTime.now();
      //max age 100 year
      _minDate =
          DateTime(initialDate.year - 100, initialDate.month, initialDate.day);
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

  _setDate(date) {
    setState(() {
      widget._controller.chosenDate = date;
      if (widget.callBack != null) widget.callBack();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget._isBirthdayPicker && widget.startDate != null) {
      _initialDate = widget.startDate;
      widget._controller.chosenDate = widget.startDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    _appLocale = Localizations.localeOf(context);
    return ResponsiveWidget(
      height: 60,
      width: 270,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          color: Theme.of(context).cardColor,
          child: DifferentSizeResponsiveRow(
            children: [
              Expanded(
                flex: 3,
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
                flex: 8,
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
      ),
    );
    ;
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
