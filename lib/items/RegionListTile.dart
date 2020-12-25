import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RegionListTile extends StatelessWidget {
  final MainLocation region;
  bool isDefault;
  int _index;
  Function(int) _removeRegion;
  LocationEditingController regionController;

  RegionListTile(this.region, this.isDefault, this._index, this._removeRegion,
      this.regionController);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: DifferentSizeResponsiveRow(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  LocationFinder(
                    controller: regionController,
                    title: Lang.getString(context, "Region"),
                    hintText: Lang.getString(context, "Region"),
                    initialDescription: regionController.description,
                    language: Lang.getString(context, "lang"),
                    country: App.countryCode,
                    isUnderlineBorder: false,
                  ),
                ],
              ),
            ),
            isDefault
                ? Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.minimize),
                      iconSize: Styles.largeIconSize(),
                      color: Styles.primaryColor(),
                      tooltip: Lang.getString(context, "Remove_region"),
                      onPressed: () {
                        _removeRegion(_index);
                      },
                    ),
                  )
                : Spacer(
                    flex: 2,
                  )
          ],
        ),
      ),
    );
  }
}
