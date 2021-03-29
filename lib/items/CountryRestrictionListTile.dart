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
  String _errorText;

  CountryRestrictionListTile(this.isDefault, this._index, this._removeCountry,
      this._controller, this._errorText);

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
                  if (_errorText != null)
                    Row(
                      children: [
                        Spacer(
                          flex: 2,
                        ),
                        Expanded(
                          flex: 18,
                          child: Text(
                            _errorText,
                            style: Styles.valueTextStyle(
                                color: Colors.red, size: 14),
                          ),
                        ),
                      ],
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
                      onPressed: () {
                        _removeCountry(_index);
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
