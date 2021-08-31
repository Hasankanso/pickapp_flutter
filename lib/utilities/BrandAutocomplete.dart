import 'package:flutter/material.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Styles.dart';

class BrandAutocomplete extends SearchDelegate<List<String>> {
  BrandAutocomplete({context, this.carBrands})
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.none,
          searchFieldStyle: Styles.titleTextStyle(),
        );

  Map<String, String> _filtered;
  bool valid;
  Map<String, String> carBrands;

  @override
  ThemeData appBarTheme(BuildContext context) {
    super.appBarTheme(context);
    return ThemeData(
      primaryColor: Styles.primaryColor(),
      cursorColor: Styles.secondaryColor(),
      hintColor: Styles.secondaryColor(),
      textTheme: Theme.of(context).textTheme.copyWith(
            headline6: Styles.titleTextStyle(),
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      CloseButton(onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != '') {
      _filtered = Map<String, String>();
      for (final item in carBrands.entries) {
        valid = false;
        for (int i = 0; i < query.length; i++) {
          if (item.value.toLowerCase().contains(query[i].toLowerCase())) {
            valid = true;
          } else {
            valid = false;
            break;
          }
        }
        if (valid) _filtered[item.key] = item.value;
      }
    } else {
      _filtered = carBrands;
    }
    return FutureBuilder(
        builder: (context, snapshot) => Container(
              color: (Cache.darkTheme ||
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark)
                  ? Color(0xFF212121)
                  : Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var item = _filtered.entries.elementAt(index);
                  return ListTile(
                    title: Text(
                      item.value,
                      style: Styles.valueTextStyle().copyWith(
                          color: (Cache.darkTheme ||
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark)
                              ? Colors.white
                              : Colors.black),
                    ),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context, [item.key, item.value]);
                    },
                  );
                },
                itemCount: _filtered.length,
              ),
            ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }
}
