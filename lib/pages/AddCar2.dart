import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar2 extends StatefulWidget {
  Driver driver;
  AddCar2({this.driver});
  @override
  _AddCar2State createState() => _AddCar2State();
}

class _AddCar2State extends State<AddCar2> {
  String _type;
  List<bool> _typesBool = [false, false, false, false];
  List<String> _typesNames = ["Sedan", "SUV", "Hatchback", "Van"];

  selectType(int index) {
    setState(() {
      _typesBool = [false, false, false, false];
      _typesBool[index] = true;
      _type = _typesNames[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Add Car", //Lang.getString(context, "Become_a_driver"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResponsiveWidget.fullWidth(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select your car type:",
                  style: Styles.labelTextStyle(),
                ),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(_typesBool[0], _typesNames[0], 'lib/images/car2',
                    selectType, 0)
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(_typesBool[1], _typesNames[1], 'lib/images/car3',
                    selectType, 1),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(_typesBool[2], _typesNames[2], 'lib/images/car1',
                    selectType, 2),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(_typesBool[3], _typesNames[3], 'lib/images/car4',
                    selectType, 3),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: false,
                text_key: "Next",
                onPressed: () {
                  if (_type == null) {
                    return CustomToast().showErrorToast("Please select type");
                  }
                  widget.driver.cars[0].type = _type;
                  Navigator.pushNamed(
                    context,
                    "/AddCar3",
                    arguments: widget.driver,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  int _index;
  bool _isSelected;
  final String _text;
  final String _image;
  Function(int) _select;

  RadioItem(
      this._isSelected, this._text, this._image, this._select, this._index);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.846153846153847),
      ),
      margin: EdgeInsets.all(10),
      child: Container(
        width: 64,
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.846153846153847),
          gradient: _isSelected
              ? LinearGradient(
                  colors: [Styles.lightPrimaryColor(), Styles.primaryColor()],
                )
              : null,
        ),
        child: InkWell(
          onTap: () {
            this._isSelected = true;
            _select(_index);
          },
          borderRadius: BorderRadius.circular(9.846153846153847),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: _isSelected
                          ? AssetImage(_image + '_white.png')
                          : AssetImage(_image + '_black.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _text,
                      style: Styles.subValueTextStyle(
                          color: _isSelected ? Colors.white : null),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
