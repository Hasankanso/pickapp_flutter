import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

class LanguagesDropdown extends StatefulWidget {
  @override
  _LanguagesDropdownState createState() => _LanguagesDropdownState();
}

class _LanguagesDropdownState extends State<LanguagesDropdown> {
  dynamic _selectedLang;

  void initState() {

    Language l = new Language(code: Cache.locale, flag: null, fullname: null);
    Lang.langs.asMap().forEach((index, element) => {
          if (element == l) {_selectedLang = index}
        });
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
        child: Row(children: [
          Spacer(),
          Text(element.fullname, style: Styles.valueTextStyle()),
          Spacer(flex: 13),
          Text(
            element.flag,
            style: TextStyle(fontSize: Styles.largeIconSize()),
          ),
        ]))));

    return DropdownButton(
      hint: Text("Select Language"),
      underline: Container(color: Colors.transparent),
      isExpanded: true,
      value: _selectedLang,
      items: items,
      onChanged: onChanged,
    );
  }
}
