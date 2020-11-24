import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/LocationFinder.dart';

import 'Responsive.dart';

class FromToPicker extends StatefulWidget {
  LocationEditingController fromController;
  LocationEditingController toController;

  FromToPicker({this.fromController, this.toController});

  @override
  _FromToPickerState createState() => _FromToPickerState();
}

class _FromToPickerState extends State<FromToPicker> {
  @override
  Widget build(BuildContext context) {
    return DifferentSizeResponsiveRow(children: [
      Expanded(
        flex: 8,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VerticalSpacer(height: ScreenUtil().setHeight(20)),
              Icon(Icons.panorama_fish_eye,
                  color: Styles.primaryColor(), size: Styles.smallIconSize()),
              Icon(Icons.more_vert,
                  color: Styles.primaryColor(), size: Styles.smallIconSize()),
              Icon(Icons.circle,
                  color: Styles.primaryColor(), size: Styles.smallIconSize()),
              VerticalSpacer(height: ScreenUtil().setHeight(20)),
            ]),
      ),
      Expanded(
        flex: 60,
        child: Column(
          children: [
            LocationFinder(
                controller: widget.fromController,
                title: Lang.getString(context, "From"),
                initialDescription: widget.fromController.description,
                hintText: Lang.getString(context, "From_Where"),
                language: Lang.getString(context, "lang"),
                country: App.countryCode),
            LocationFinder(
                controller: widget.toController,
                title: Lang.getString(context, "To"),
                initialDescription: widget.toController.description,
                hintText: Lang.getString(context, "To_Where"),
                language: Lang.getString(context, "lang"),
                country: App.countryCode),
          ],
        ),
      ),
      Expanded(
        flex: 8,
        child: IconButton(
          icon: Icon(Icons.sync),
          iconSize: Styles.mediumIconSize(),
          onPressed: () {
            setState(() {
              widget.fromController.swap(widget.toController);
            });
          },
        ),
      )
    ]);
  }
}
