import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lang {
  final Locale locale;

  Lang(this.locale);

  static Lang of(BuildContext context) {
    return Localizations.of<Lang>(context, Lang);
  }
  static String getString(BuildContext context, String key){
      return Localizations.of<Lang>(context, Lang)._localizedValues[key];
  }
  Map<String, String> _localizedValues;

  Future load() async {
    String jsonStringValues =
        await rootBundle.loadString('lib/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value));
  }



  static const LocalizationsDelegate<Lang> delegate =
      _LangDelegate();
}

class _LangDelegate extends LocalizationsDelegate<Lang> {
  const _LangDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
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
