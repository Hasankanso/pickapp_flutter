import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/items/CountryRestrictionListTile.dart';
import 'package:just_miles/packages/countryPicker/Country.dart';
import 'package:just_miles/packages/countryPicker/CountryPicker.dart';
import 'package:just_miles/packages/countryPicker/all_countries_list.dart';
import 'package:just_miles/packages/countryPicker/countries_list_view.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class CountriesRestriction extends StatefulWidget {
  @override
  _CountriesRestrictionState createState() => _CountriesRestrictionState();
}

class _CountriesRestrictionState extends State<CountriesRestriction> {
  List<CountryPickerController> _countriesControllers = <CountryPickerController>[];
  int _countriesMaxNb = 5;

  _getCountries() async {
    var a = countryCodes.map((country) => Country.from(json: country)).toList();
    List<String> countries = await Cache.getCountriesList();
    setState(() {
      for (final c in countries) {
        Country country = a.where((country) => country.countryCode == c.toUpperCase()).first;
        _countriesControllers.add(CountryPickerController(country: country));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Countries_Restriction"),
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
                              flex: 20,
                              child: Text(
                                Lang.getString(context, "Country_rest_desc"),
                                style: Styles.valueTextStyle(),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: IconButton(
                                icon: Icon(Icons.add),
                                iconSize: Styles.largeIconSize(),
                                color: Styles.primaryColor(),
                                tooltip: Lang.getString(context, "Add_country"),
                                onPressed: !(_countriesControllers != null &&
                                        _countriesControllers.length >= _countriesMaxNb)
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
                  return CountryRestrictionListTile(
                    index != 0,
                    index,
                    _removeCountry,
                    _countriesControllers[index],
                  );
                },
                itemCount: _countriesControllers.length,
              ),
            ),
        ],
      ),
    );
  }

  _addCountry() {
    if (_countriesControllers.length <= _countriesMaxNb - 1) {
      showDialog(
          context: context,
          barrierColor: Colors.black12,
          barrierDismissible: false,
          builder: (_) => Center(
                child: Container(
                  width: ScreenUtil().setWidth(330),
                  height: ScreenUtil().setHeight(600),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Spacer(),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              iconSize: 20,
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 23,
                        child: CountryListView(
                          showPhoneCode: false,
                          onSelect: (c) async {
                            _countriesControllers.add(CountryPickerController(country: c));

                            for (int i = 0; i < _countriesControllers.length; i++) {
                              var validate = _countriesControllers[i].validate(context);
                              if (validate != null) {
                                _countriesControllers.removeLast();
                                return;
                              }
                            }
                            for (int i = 0; i < _countriesControllers.length; i++) {
                              for (int j = i + 1; j < _countriesControllers.length; j++) {
                                if (_countriesControllers[j].country != null &&
                                    _countriesControllers[i].country != null &&
                                    _countriesControllers[i].country.countryCode ==
                                        _countriesControllers[j].country.countryCode) {
                                  _countriesControllers.removeLast();
                                  return;
                                }
                              }
                            }
                            //validation done
                            List<String> _updatedCountries = <String>[];
                            for (int i = 0; i < _countriesControllers.length; i++) {
                              _updatedCountries.add(_countriesControllers[i].country.countryCode);
                            }

                            await Cache.setCountriesList(_updatedCountries);
                            App.countriesComponents = null;
                            App.setCountriesComponent(_updatedCountries);
                            setState(() {
                              App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  _removeCountry(index) async {
    if (_countriesControllers.length > 1) {
      _countriesControllers.removeAt(index);

      List<String> _updatedCountries = <String>[];
      for (int i = 0; i < _countriesControllers.length; i++) {
        _updatedCountries.add(_countriesControllers[i].country.countryCode);
      }
      await Cache.setCountriesList(_updatedCountries);
      App.countriesComponents = null;
      App.setCountriesComponent(_updatedCountries);
      setState(() {
        App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
      });
    }
  }
}
