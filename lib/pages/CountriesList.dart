import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/items/CountryListTile.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CountriesList extends StatefulWidget {
  @override
  _CountriesListState createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  List<CountryCode> _countries = List<CountryCode>();
  List<String> _errorTexts = List<String>();

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getCountries();
  }

  _getCountries() async {
    List<String> coutriesl = await Cache.getCountriesList();
    setState(() {
      for (final c in coutriesl) {
        _countries.add(CountryCode(code: c));
        _errorTexts.add(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Countries List",
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
                                onPressed: !(_countries != null &&
                                        _countries.length >= 5)
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
          if (_countries != null)
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return CountryListTile(
                    index != 0,
                    index,
                    _removeCountry,
                    _countries[index],
                    _errorTexts[index],
                  );
                },
                itemCount: _countries.length,
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
                  for (int i = 0; i < _countries.length; i++) {
                    print(_countries[i].code);
                    var validate = "lllllll";
                    _errorTexts[i] = validate;
                    if (validate != null) {
                      isValid = false;
                    }
                  }
                  setState(() {});
                  if (isValid) {
                    //work
                    print("tamem");
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
    if (_countries.length <= 4) {
      setState(() {
        _countries.add(CountryCode());
        _errorTexts.add(null);
      });
    }
  }

  _removeCountry(index) {
    if (_countries.length > 1) {
      setState(() {
        _countries.removeAt(index);
        _errorTexts.removeAt(index);
      });
    }
  }
}
