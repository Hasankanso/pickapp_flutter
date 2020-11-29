import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

import 'Responsive.dart';

class NumberPicker extends StatefulWidget {
  int _value, _min, _max;
  String _title;
  NumberController controller;
  NumberPicker(this.controller, this._title, this._min, this._max,
      [defaultCounter]) {
    if (defaultCounter != null) {
      _value = defaultCounter;
    } else {
      _value = _min;
    }
  }
  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _value;
  bool isCounterUpDownDisabled = false;
  @override
  void initState() {
    super.initState();
    _value = widget._value;
    widget.controller.chosenNumber = widget._value;
  }

  void counterUp() {
    if (!(_value >= widget._max))
      setState(() {
        _value++;
        widget.controller.chosenNumber++;
      });
  }

  void _minus() {
    if (!(_value <= widget._min))
      setState(() {
        _value--;
        widget.controller.chosenNumber--;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DifferentSizeResponsiveRow(
      children: <Widget>[
        Expanded(flex: 8, child: SizedBox()),
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
                  heroTag: "minus",
                  onPressed: _minus,
                  child: Icon(
                    Icons.remove,
                    color: Styles.secondaryColor(),
                    size: Styles.mediumIconSize(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('$_value',
                    textAlign: TextAlign.center,
                    style: Styles.valueTextStyle()),
              ),
              Expanded(
                flex: 1,
                child: FloatingActionButton(
                  heroTag: "plus",
                  onPressed: counterUp,
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
        Expanded(flex: 8, child: SizedBox())
      ],
    );
  }
}

class NumberController {
  int chosenNumber;
}
