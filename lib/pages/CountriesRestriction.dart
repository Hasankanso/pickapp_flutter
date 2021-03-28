import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/items/CountryListTile.dart';
import 'package:pickapp/packages/countryPicker/Country.dart';
import 'package:pickapp/packages/countryPicker/CountryPicker.dart';
import 'package:pickapp/packages/countryPicker/all_countries_list.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CountriesRestriction extends StatefulWidget {
  @override
  _CountriesRestrictionState createState() => _CountriesRestrictionState();
}

class _CountriesRestrictionState extends State<CountriesRestriction> {
  List<CountryPickerController> _countriesControllers =
      List<CountryPickerController>();
  List<String> _errorTexts = List<String>();

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getCountries();
  }

  _getCountries() async {
    var a = countryCodes.map((country) => Country.from(json: country)).toList();
    List<String> countries = await Cache.getCountriesList();
    setState(() {
      for (final c in countries) {
        Country country =
            a.where((country) => country.countryCode == c.toUpperCase()).first;
        _countriesControllers.add(CountryPickerController(country: country));
        _errorTexts.add(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Countries Restriction",
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 22 / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DifferentSizeResponsiveRow(
                          children: [
                            Expanded(
                              flex: 10,
                              child: Text(
                                "Search for ride in countries:",
                                style: Styles.valueTextStyle(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                icon: Icon(Icons.add),
                                iconSize: Styles.largeIconSize(),
                                color: Styles.primaryColor(),
                                tooltip: "Add Country",
                                onPressed: !(_countriesControllers != null &&
                                        _countriesControllers.length >= 5)
                                    ? _addCountry
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_countriesControllers != null)
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return CountryListTile(
                    index != 0,
                    index,
                    _removeCountry,
                    _countriesControllers[index],
                    _errorTexts[index],
                  );
                },
                itemCount: _countriesControllers.length,
              ),
            ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: true,
                text_key: "Save",
                onPressed: () async {
                  bool isValid = true;
                  for (int i = 0; i < _countriesControllers.length; i++) {
                    var validate = _countriesControllers[i].validate(context);
                    _errorTexts[i] = validate;
                    if (validate != null) {
                      isValid = false;
                    }
                  }
                  setState(() {});
                  if (isValid) {
                    for (int i = 0; i < _countriesControllers.length; i++) {
                      for (int j = i + 1;
                          j < _countriesControllers.length;
                          j++) {
                        if (_countriesControllers[i].country.countryCode ==
                            _countriesControllers[j].country.countryCode) {
                          _errorTexts[i] = "Countries cannot be duplicated";
                          _errorTexts[j] = "Countries cannot be duplicated";
                          isValid = false;
                        }
                      }
                    }
                    if (isValid == false) return;
                    //validation done
                    List<String> _updatedCountries = List<String>();
                    for (int i = 0; i < _countriesControllers.length; i++) {
                      _updatedCountries
                          .add(_countriesControllers[i].country.countryCode);
                    }
                    await Cache.setCountriesList(_updatedCountries);
                    App.countriesComponents = null;
                    App.setCountriesComponent(_updatedCountries);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addCountry() {
    if (_countriesControllers.length <= 4) {
      setState(() {
        _countriesControllers.add(CountryPickerController());
        _errorTexts.add(null);
      });
    }
  }

  _removeCountry(index) {
    if (_countriesControllers.length > 1) {
      setState(() {
        _countriesControllers.removeAt(index);
        _errorTexts.removeAt(index);
      });
    }
  }
}
