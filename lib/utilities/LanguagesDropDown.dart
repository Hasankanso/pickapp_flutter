import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';

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
      App.changeLanguage(l.code, context);
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
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: Styles.largeIconSize()),
          ),
        ]))));

    return DropdownButton(
      hint: Text(Lang.getString(context, "Select_Language")),
      underline: Container(color: Colors.transparent),
      isExpanded: true,
      value: _selectedLang,
      items: items,
      onChanged: onChanged,
    );
  }
}
