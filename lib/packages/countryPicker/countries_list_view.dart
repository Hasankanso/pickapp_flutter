import 'package:flutter/material.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/packages/countryPicker/Country.dart';
import 'package:just_miles/packages/countryPicker/all_countries_list.dart';
import 'package:just_miles/packages/countryPicker/country_code_to_name.dart';

class CountryListView extends StatefulWidget {
  static String countryCodeToEmoji(String countryCode) {
    if (countryCode == null) return "";
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  final ValueChanged<Country> onSelect;
  final bool showPhoneCode;
  final List<String> exclude;

  final List<String> countryFilter;

  const CountryListView({
    Key key,
    @required this.onSelect,
    this.exclude,
    this.countryFilter,
    this.showPhoneCode = false,
  })  : assert(onSelect != null),
        assert(exclude == null || countryFilter == null,
            'Cannot provide both exclude and countryFilter'),
        super(key: key);

  @override
  _CountryListViewState createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  List<Country> _countryList;
  List<Country> _filteredList;
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _countryList =
        countryCodes.map((country) => Country.from(json: country)).toList();

    //Remove duplicates country if not use phone code
    if (!widget.showPhoneCode) {
      final ids = _countryList.map((e) => e.countryCode).toSet();
      _countryList.retainWhere((country) => ids.remove(country.countryCode));
    }

    if (widget.exclude != null) {
      _countryList.removeWhere(
          (element) => widget.exclude.contains(element.countryCode));
    }
    if (widget.countryFilter != null) {
      _countryList.removeWhere(
          (element) => !widget.countryFilter.contains(element.countryCode));
    }

    _filteredList = <Country>[];
    _filteredList.addAll(_countryList);
  }

  @override
  Widget build(BuildContext context) {
    final String searchLabel = Lang.getString(context, "Search");

    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: searchLabel,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: _filterSearchResults,
          ),
        ),
        Expanded(
          child: ListView(
            children: _filteredList
                .map<Widget>((country) => _listRow(country))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _listRow(Country country) {
    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onSelect(country);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20),
              Text(
                CountryListView.countryCodeToEmoji(country.countryCode),
                style: const TextStyle(fontSize: 25),
              ),
              if (widget.showPhoneCode) ...[
                const SizedBox(width: 15),
                Container(
                  width: 45,
                  child: Text(
                    '+${country.phoneCode}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 5),
              ] else
                const SizedBox(width: 15),
              Expanded(
                child: Text(
                  en[country.countryCode] ?? country.name,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _filterSearchResults(String query) {
    List<Country> _searchResult = <Country>[];

    if (query.isEmpty) {
      _searchResult.addAll(_countryList);
    } else {
      _searchResult = _countryList.where((c) => c.startsWith(query)).toList();
    }

    setState(() => _filteredList = _searchResult);
  }
}
