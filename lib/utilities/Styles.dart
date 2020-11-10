import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//for app bar text
titleTextStyle(context) {
  final _deviceSize = MediaQuery.of(context);
  return TextStyle(fontSize: _deviceSize.size.width * 0.049);
}

//for header text(Persons:) and value(3) ex: header:'Persons: 3'
headerTextStyle({context, isTitle, isValue}) {
  final _deviceSize = MediaQuery.of(context);
  if (isValue == true)
    return TextStyle(
        color: primaryColor(),
        fontSize: _deviceSize.size.width * 0.06,
        fontWeight: FontWeight.w400);
  else if (isTitle == true)
    return TextStyle(
        color: labelColor(),
        fontSize: _deviceSize.size.width * 0.06,
        fontWeight: FontWeight.w400);
}

//primary color of app
primaryColor() {
  return Colors.blue;
}

secondaryColor() {
  return Colors.white;
}

labelColor() {
  return Colors.grey;
}

valueColor() {
  return Colors.black;
}

backgroundColor() {
  return Colors.white;
}

//icons size navigationbottomicons ...
iconSize(context) {
  final _deviceSize = MediaQuery.of(context);
  return _deviceSize.size.width * 0.075;
}
