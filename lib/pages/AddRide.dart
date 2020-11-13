import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';

class AddRide extends StatefulWidget {
  @override
  _AddRideState createState() => _AddRideState();
}

class _AddRideState extends State<AddRide> {
  TextEditingController _textEditingController = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor(),
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            style: Styles.valueTextStyle(),
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: Styles.labelTextStyle(),
              hintText: "test",
              hintStyle: Styles.labelTextStyle(),
              errorText: _validate ? "Value Can't Be Empty" : null,
            ),
          ),
          MainButton(
            text_key: "Search",
            onPressed: () {
              setState(() {
                _textEditingController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
