import 'package:flutter/material.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Styles.dart';

class Spinner extends StatelessWidget {
  double strokeWidth;
  Spinner({this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth,
      backgroundColor: (Cache.darkTheme &&
              MediaQuery.of(context).platformBrightness == Brightness.dark)
          ? Styles.primaryColor()
          : null,
    );
  }
}
