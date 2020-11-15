import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';

class ResponsiveWidget extends StatelessWidget {
  double height = 0, width = 0;
  Widget child;

  ResponsiveWidget({this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    Size referScreen = new Size(360, 640); //720x1280 reference screen
    Size screen = App.mediaQuery.size; //get current screen size

    //calculate the ratio of new screen relative to the reference one (bigger screen has values larger than 1, smaller less than 1)
    Size screenRatio = new Size(
        screen.width / referScreen.width, screen.height / referScreen.height);

    //calculate the ratio of width, height and reference screen width, height.
    double xRatio = width / referScreen.width;
    double yRatio = height / referScreen.height;

    //calculate how much we'll scale our widget on each dimension
    double relativeRatioX = screenRatio.width * xRatio;
    double relativeRatioY = screenRatio.height * yRatio;

    //take the ratio of the smaller scale
    double smallerRatio = relativeRatioX.abs() < relativeRatioY.abs()
        ? screenRatio.width
        : screenRatio.height;

    //multiply the reference screen size with the smaller ratio on X and Y to keep same ratio
    Size widgetSize = new Size(xRatio * referScreen.width * smallerRatio,
        yRatio * referScreen.height * smallerRatio);

    print("screen size:" + screen.toString());
    print("widget Size: " +
        widgetSize.toString() +
        " ratio: " +
        (widgetSize.width / widgetSize.height).toString());

    return SizedBox(
        width: widgetSize.width, height: widgetSize.height, child: child);
  }
}
