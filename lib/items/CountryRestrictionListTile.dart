import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/packages/countryPicker/CountryPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CountryRestrictionListTile extends StatelessWidget {
  bool isDefault;
  int _index;
  Function(int) _removeCountry;
  CountryPickerController _controller;

  CountryRestrictionListTile(
      this.isDefault, this._index, this._removeCountry, this._controller);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountryPicker(
                    controller: _controller,
                  ),
                ],
              ),
            ),
            isDefault
                ? Expanded(
                    flex: 2,
                    child: IconButton(
                      alignment: Alignment.topCenter,
                      icon: Icon(
                        Icons.minimize,
                        color: Styles.primaryColor(),
                        size: Styles.largeIconSize(),
                      ),
                      iconSize: Styles.largeIconSize(),
                      color: Styles.primaryColor(),
                      tooltip: Lang.getString(context, "Remove_country"),
                      onPressed: () async {
                        await _removeCountry(_index);
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
