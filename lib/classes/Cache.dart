import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences _prefs;

  static Future<SharedPreferences> Init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future setLocale(String language_code) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString("LANG_CODE", language_code);
  }

  static Future<String> getLocale() async {
    _prefs = await SharedPreferences.getInstance();
    String code = _prefs.getString("LANG_CODE");
    return code;
  }

  static Future setDateTimeRangePicker(String isRangePicker) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString("isRangePicker", isRangePicker);
  }

  static Future<String> getDateTimeRangePicker() async {
    _prefs = await SharedPreferences.getInstance();
    String code = _prefs.getString("isRangePicker");
    return code;
  }
}
