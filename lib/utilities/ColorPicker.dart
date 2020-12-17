import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

class ColorPicker extends StatefulWidget {
  ColorController _controller;
  ColorPicker(this._controller);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color _tempMainColor;
  Color _mainColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainColor = widget._controller.pickedColor;
  }

  void _OpenColorPicker() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            Lang.getString(context, "Pick_a_Color"),
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
          content: MaterialColorPicker(
            colors: fullMaterialColors,
            selectedColor: _mainColor,
            allowShades: false,
            onMainColorChange: (color) => setState(() {
              _tempMainColor = color;
            }),
          ),
          actions: [
            FlatButton(
              child: Text(Lang.getString(context, 'CANCEL')),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text(Lang.getString(context, 'DONE')),
              onPressed: () {
                Navigator.of(context).pop();
                widget._controller.pickedColor = _tempMainColor;
                setState(() {
                  _mainColor = _tempMainColor;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _OpenColorPicker,
      backgroundColor: _mainColor,
      tooltip: Lang.getString(context, "Pick_a_Color"),
    );
  }
}

class ColorController {
  Color pickedColor = Styles.primaryColor();
}
