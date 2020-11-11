import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';

class LanguagesDropdown extends StatefulWidget {
  @override
  _LanguagesDropdownState createState() => _LanguagesDropdownState();
}

class _LanguagesDropdownState extends State<LanguagesDropdown> {
  dynamic _selectedLang;

  void initState() {
    Cache.getLocale().then(
      (value) => setState(
        () {
          Language l = new Language(code: value, flag: null, fullname: null);
          Lang.langs.asMap().forEach((index, element) => {
                if (element == l) {_selectedLang = index}
              });
        },
      ),
    );
    super.initState();
  }

  void onChanged(dynamic value) {
    setState(() {
      Language l = Lang.langs[value];
      App.changeLanguage(l.code);
      _selectedLang = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = List<DropdownMenuItem>();
    Lang.langs.asMap().forEach((index, element) => items.add(DropdownMenuItem(
        value: index,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(element.fullname),
          Text(
            element.flag,
            style: TextStyle(fontSize: 30),
          )
        ]))));

    return DropdownButton(
      hint: Text("Select Language"),
      value: _selectedLang,
      items: items,
      onChanged: onChanged,
    );
  }
}
