import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/Styles.dart';

import 'Responsive.dart';

class BirthDayPicker extends StatefulWidget {
  final String value;
  final Function ShowDatePicker;

  const BirthDayPicker({Key key, this.value, this.ShowDatePicker})
      : super(key: key);

  @override
  _BirthDayPickerState createState() => _BirthDayPickerState(value);
}

class _BirthDayPickerState extends State<BirthDayPicker> {
  String value;

  _BirthDayPickerState(this.value);

  @override
  Widget build(BuildContext context) {
    _setDate(date) {
      setState(() {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(date);
        value = formatted;
      });
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Birthday",
            style: Styles.labelTextStyle(),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            child: Text(
              value,
              style: Styles.valueTextStyle(),
            ),
            onPressed: () {
              DatePicker.showDatePicker(
                context,
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
