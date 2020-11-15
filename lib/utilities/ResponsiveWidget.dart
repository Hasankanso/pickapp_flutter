import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';

class ResponsiveWidget extends StatelessWidget {
  double height = 0,
      width = 0;
  Widget child;

  ResponsiveWidget({this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    Size referScreen = new Size(360, 640); //720x1280 reference screen
    Size screen = App.mediaQuery.size; //get current screen size

    //calculate the difference between current screen and reference screen
    double diffX = screen.width - referScreen.width;
    double diffY = screen.height - referScreen.height;

    //claculate the ratio of width, height and reference screen width, height.
    double xRatio = width / referScreen.width;
    double yRatio = height / referScreen.height;

    //use this ratio to know how much should we occupy of the difference
    diffX = diffX * xRatio;
    diffY = diffY * yRatio;

    //check wicht difference reach its limit first.
    double smallerDiff = diffX.abs() < diffY.abs() ? diffX : diffY;

    //add the smaller difference to the original size (keep the ratio
    return SizedBox(width: xRatio * referScreen.width + diffX,
        height: yRatio * referScreen.height + diffY,
        child: child);
  }
}
