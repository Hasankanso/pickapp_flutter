import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/Responsive.dart';

class FromToPicker extends StatefulWidget {
  LocationEditingController fromController;
  LocationEditingController toController;

  FromToPicker({this.fromController, this.toController});

  @override
  _FromToPickerState createState() => _FromToPickerState();
}

class _FromToPickerState extends State<FromToPicker> {
  String _fromError = null;
  String _toError = null;

  @override
  Widget build(BuildContext context) {
    return DifferentSizeResponsiveRow(children: [
      Expanded(
        flex: 8,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.panorama_fish_eye,
              color: Styles.primaryColor(), size: Styles.smallIconSize()),
          Icon(Icons.more_vert,
              color: Styles.primaryColor(), size: Styles.smallIconSize()),
          Icon(Icons.circle,
              color: Styles.primaryColor(), size: Styles.smallIconSize()),
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
                country: App.countryCode,
                errorText: _fromError,
                onValidate: validate,
              ),
            ),
            Expanded(
              child: LocationFinder(
                controller: widget.toController,
                title: Lang.getString(context, "To"),
                initialDescription: widget.toController.description,
                hintText: Lang.getString(context, "To_Where"),
                language: Lang.getString(context, "lang"),
                country: App.countryCode,
                errorText: _toError,
                onValidate: validate,
              ),
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
            setState(() {
              widget.fromController.swap(widget.toController);
            });
          },
        ),
      )
    ]);
  }

  String validate(String text) {
    if (widget.toController.description == widget.fromController.description) {
      return "Same Location";
    }
  }
}
