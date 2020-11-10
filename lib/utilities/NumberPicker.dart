import 'package:flutter/material.dart';
import 'package:pickapp/utilities/Styles.dart';

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
    final _deviceSize = MediaQuery.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(widget._title,
                style: headerTextStyle(context: context, isTitle: true)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            width: _deviceSize.size.width * 0.11,
            height: _deviceSize.size.width * 0.11,
            child: FloatingActionButton(
              heroTag: "minus",
              onPressed: _minus,
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: iconSize(context),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
          child: Text('$_value',
              style: headerTextStyle(context: context, isValue: true)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
          child: Container(
            width: _deviceSize.size.width * 0.11,
            height: _deviceSize.size.width * 0.11,
            child: FloatingActionButton(
              heroTag: "plus",
              onPressed: counterUp,
              child: new Icon(
                Icons.add,
                color: Colors.white,
                size: iconSize(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NumberController {
  int chosenNumber;
}
