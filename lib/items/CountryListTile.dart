import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CountryListTile extends StatelessWidget {
  bool isDefault;
  int _index;
  Function(int) _removeCountry;
  CountryCode country;
  String _errorText;
  CountryListTile(this.isDefault, this._index, this._removeCountry,
      this.country, this._errorText);

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
                  CountryCodePicker(
                    onChanged: (v) {
                      country = v;
                      print(country.code);
                    },
                    initialSelection: country.code,
                    textStyle: Styles.valueTextStyle(),
                    searchStyle: Styles.valueTextStyle(),
                    backgroundColor: Colors.transparent,
                    boxDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    barrierColor: Colors.black12,
                    dialogTextStyle: Styles.valueTextStyle(),
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    alignLeft: false,
                  ),
                  if (_errorText != null)
                    Text(
                      _errorText,
                      style: Styles.valueTextStyle(color: Colors.red, size: 14),
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
