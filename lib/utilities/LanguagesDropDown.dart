

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';

class LanguagesDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = List<DropdownMenuItem>();
    int i = 0;
    Lang.langs.forEach((element) => items.add(DropdownMenuItem(
        value: element.code,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(element.fullname),
          Text(
            element.flag,
            style: TextStyle(fontSize: 30),
          )
        ]))));

    return DropdownButton(
        icon: Icon(Icons.language, color: Colors.white),
        items: items,
        onChanged: (lang) => App.changeLanguage(lang));
  }
}
