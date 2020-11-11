import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lang {
  final Locale locale;
  static List<Language> langs = [
    new Language(code: "en", fullname: "English", flag: "🇬🇧"),
    new Language(code: "ar", fullname: "العربية", flag: "🇱🇧"),
    new Language(code: "fr", fullname: "Français", flag: "🇫🇷")
  ];
  Lang(this.locale);

  static String getString(context, String key) {
    return Localizations.of<Lang>(context, Lang)._localizedValues[key];
  }

  Map<String, String> _localizedValues;

  Future load() async {
    String jsonStringValues = await rootBundle
        .loadString('lib/languages/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value));
  }

  static const LocalizationsDelegate<Lang> delegate = _LangDelegate();
}

class _LangDelegate extends LocalizationsDelegate<Lang> {
  const _LangDelegate();

  @override
  bool isSupported(Locale locale) {
    return Lang.langs.any((element) => element.code == locale.languageCode);
  }

  @override
  Future<Lang> load(Locale locale) async {
    Lang localization = new Lang(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Lang> old) => false;
}

class Language {
  String code;
  String fullname;
  String flag;

  Language({this.code, this.fullname, this.flag});

  bool operator ==(o) => o is Language && code == o.code;

  @override
  String toString() {
    return this.fullname + " " + this.flag;
  }
}
