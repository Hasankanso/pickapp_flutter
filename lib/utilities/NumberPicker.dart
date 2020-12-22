import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

import 'Responsive.dart';

class NumberPicker extends StatefulWidget {
  int _value, _min, _max, counter;
  String _title;
  bool disabled;
  NumberController controller;

  NumberPicker(this.controller, this._title, this._min, this._max,
      {defaultCounter, this.disabled = false}) {
    if (disabled) {
      _value = 0;
      controller.chosenNumber = 0;
    }
    if (defaultCounter != null) {
      _value = defaultCounter;
      controller.chosenNumber = defaultCounter;
    } else {
      _value = _min;
      controller.chosenNumber = _min;
    }
  }

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  void counterUp() {
    if (!(widget._value >= widget._max))
      setState(() {
        widget._value++;
        widget.controller.chosenNumber++;
      });
  }

  void _minus() {
    if (!(widget._value <= widget._min))
      setState(() {
        widget._value--;
        widget.controller.chosenNumber--;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      widget._value = 0;
      widget.controller.chosenNumber = 0;
    }
    return DifferentSizeResponsiveRow(
      children: <Widget>[
        Spacer(
          flex: 8,
        ),
        Expanded(
          flex: 60,
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(Lang.getString(context, widget._title),
                    style: Styles.labelTextStyle()),
              ),
              Expanded(
                flex: 1,
                child: FloatingActionButton(
                  backgroundColor: widget.disabled
                      ? Styles.labelColor()
                      : Styles.primaryColor(),
                  heroTag: widget._title + "minus",
                  elevation: 3,
                  onPressed: () {
                    if (!widget.disabled) _minus();
                  },
                  child: Icon(
                    Icons.remove,
                    color: Styles.secondaryColor(),
                    size: Styles.mediumIconSize(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget._value.toString(),
                  textAlign: TextAlign.center,
                  style: Styles.valueTextStyle(),
                ),
              ),
              Expanded(
                flex: 1,
                child: FloatingActionButton(
                  backgroundColor: widget.disabled
                      ? Styles.labelColor()
                      : Styles.primaryColor(),
                  heroTag: widget._title + "plus",
                  onPressed: () {
                    if (!widget.disabled) counterUp();
                  },
                  elevation: 3,
                  child: Icon(
                    Icons.add,
                    color: Styles.secondaryColor(),
                    size: Styles.mediumIconSize(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(
          flex: 8,
        ),
      ],
    );
  }
}

class NumberController {
  int chosenNumber;
}
