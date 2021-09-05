import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/LocationFinder.dart';
import 'package:just_miles/utilities/Responsive.dart';

class FromToPicker extends StatefulWidget {
  final LocationEditingController fromController;
  final LocationEditingController toController;
  final String fromError, toError;
  final bool canPickCurrLocation;

  FromToPicker(
      {this.fromController,
      this.toController,
      this.fromError,
      this.toError,
      this.canPickCurrLocation = true});

  @override
  _FromToPickerState createState() => _FromToPickerState();
}

class _FromToPickerState extends State<FromToPicker> {
  @override
  Widget build(BuildContext context) {
    return DifferentSizeResponsiveRow(children: [
      Expanded(
        flex: 8,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.panorama_fish_eye, color: Styles.primaryColor(), size: Styles.smallIconSize()),
          Icon(Icons.more_vert, color: Styles.primaryColor(), size: Styles.smallIconSize()),
          Icon(Icons.circle, color: Styles.primaryColor(), size: Styles.smallIconSize()),
        ]),
      ),
      Expanded(
        flex: 60,
        child: Column(
          children: [
            Expanded(
              child: LocationFinder(
                  controller: widget.fromController,
                  title: Lang.getString(context, "From"),
                  initialDescription: widget.fromController.description,
                  hintText: Lang.getString(context, "From_Where"),
                  language: Lang.getString(context, "lang"),
                  errorText: widget.fromError,
                  canPickCurrLocation: widget.canPickCurrLocation),
            ),
            Expanded(
              child: LocationFinder(
                  controller: widget.toController,
                  title: Lang.getString(context, "To"),
                  initialDescription: widget.toController.description,
                  hintText: Lang.getString(context, "To_Where"),
                  language: Lang.getString(context, "lang"),
                  errorText: widget.toError,
                  canPickCurrLocation: widget.canPickCurrLocation),
            )
          ],
        ),
      ),
      Expanded(
        flex: 8,
        child: IconButton(
          icon: Icon(Icons.sync),
          iconSize: Styles.mediumIconSize(),
          onPressed: () {
            if (widget.fromController.description != null &&
                widget.toController.description != null) {
              widget.fromController.swap(widget.toController);
              setState(() {});
            }
          },
        ),
      )
    ]);
  }
}
