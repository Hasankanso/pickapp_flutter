import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';

class BirthDayPicker extends StatefulWidget {
  DateTime startDate;
  BirthdayController _controller;

  BirthDayPicker(this._controller, {this.startDate});

  @override
  _BirthDayPickerState createState() => _BirthDayPickerState();
}

class _BirthDayPickerState extends State<BirthDayPicker> {
  DateTime _minDate, _maxDate, _initialDate;
  Locale _appLocale;
  DatePickerTheme _theme;

  Map<String, LocaleType> localeType = {
    "en": LocaleType.en,
    "ar": LocaleType.ar,
    "fr": LocaleType.fr,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.startDate == null) {
      //initial age is 18 years
      _initialDate = widget._controller.chosenDate;
    } else {
      _initialDate = widget.startDate;
      widget._controller.chosenDate = widget.startDate;
    }

    DateTime initialDate = DateTime.now();
    //max age 100 year
    _minDate = DateTime(initialDate.year - 100, initialDate.month, initialDate.day);
    //min age 14 years
    _maxDate = DateTime(initialDate.year - 14, initialDate.month, initialDate.day);
    if (App.isAndroid()) {
      _theme = DatePickerTheme(
        headerColor: Styles.primaryColor(),
        doneStyle: Styles.valueTextStyle(color: Colors.white),
        cancelStyle: Styles.valueTextStyle(color: Colors.white),
      );
    }
  }

  _setDate(date) {
    setState(() {
      widget._controller.chosenDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    _appLocale = Localizations.localeOf(context);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            Lang.getString(context, "Birthday"),
            style: Styles.labelTextStyle(),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            child: Text(
              DateFormat(App.birthdayFormat, _appLocale.toString())
                  .format(widget._controller.chosenDate),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.w400,
                color: (!Cache.darkTheme &&
                        MediaQuery.of(context).platformBrightness != Brightness.dark)
                    ? Styles.valueColor()
                    : Colors.white,
              ),
            ),
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                theme: _theme,
                locale: localeType[_appLocale.toString()],
                minTime: _minDate,
                maxTime: _maxDate,
                currentTime: _initialDate,
                onConfirm: (date) {
                  _setDate(date);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BirthdayController {
  DateTime chosenDate;
  BirthdayController() {
    DateTime initialDate = DateTime.now();
    chosenDate = DateTime(initialDate.year - 18, initialDate.month, initialDate.day);
  }
}
