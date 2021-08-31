import 'package:flutter/material.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/LocationFinder.dart';
import 'package:just_miles/utilities/Responsive.dart';

class RegionListTile extends StatelessWidget {
  bool isDefault;
  int _index;
  Function(int) _removeRegion;
  LocationEditingController regionController;
  String errorText;

  RegionListTile(this.isDefault, this._index, this._removeRegion,
      this.regionController, this.errorText);

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
                    isUnderlineBorder: false,
                    errorText: errorText,
                  ),
                ],
              ),
            ),
            isDefault
                ? Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(
                        Icons.minimize,
                        color: Styles.primaryColor(),
                        size: Styles.largeIconSize(),
                      ),
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
