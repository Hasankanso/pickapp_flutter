import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar2 extends StatefulWidget {
  @override
  _AddCar2State createState() => _AddCar2State();
}

class _AddCar2State extends State<AddCar2> {
  String type;
  List<bool> _types = [false, false, false, false];

  selectType(int index) {
    setState(() {
      _types = [false, false, false, false];
      _types[index] = true;
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
                RadioItem(_types[0], 'Sedan', 'lib/images/car2', selectType, 0)
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(_types[1], 'SUV', 'lib/images/car3', selectType, 1),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(
                    _types[2], 'Hatchback', 'lib/images/car1', selectType, 2),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioItem(_types[3], 'Van', 'lib/images/car4', selectType, 3),
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
                  Navigator.pushNamed(context, "/AddCar3");
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
      child: InkWell(
        onTap: () {
          this._isSelected = true;
          _select(_index);
        },
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
