import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:validators/validators.dart';

class Validation {
  static bool validPhoneNumber(String number) {
    //todo validate phone
    return true;
  }

  static String invalid(context) {
    return Lang.getString(context, "Invalid");
  }

  static String isPhoneNumber(context, String number) {
    //todo validate phone
    if (false) {
      return Lang.getString(context, "Invalid");
    }
    return null;
  }

  static String isEmail(context, String number) {
    //todo validate email
    if (false) {
      return Lang.getString(context, "Invalid");
    }
    return null;
  }

  static String validate(String value, context) {
    if (isNullOrEmpty(value)) {
      return Lang.getString(context, "Cannot_be_empty");
    }
    return null;
  }

  static String isAlphabeticIgnoreSpaces(context, value) {
    //todo need arabic validation
    if (!isAlpha(value.replaceAll(RegExp(r"\s+|,|\."), ""))) {
      return Lang.getString(context, "Only_letters");
    }
    return null;
  }

  static String isShort(context, value, length) {
    if (value.length < length) {
      return Lang.getString(context, "Too_short");
    }
    return null;
  }

  static bool isNullOrEmpty(String toCheck) {
    if (["", null].contains(toCheck)) return true;
    return false;
  }

  static String validateLogin(User user) {
    if (Validation.isNullOrEmpty(user.id)) {
      return "Please login";
    }
    return null;
  }

  static bool validEmail(String emailaddress) {
    return true;
  }

  static bool validAlphabet(String text) {
    return isAlpha(text);
  }

  static String isAlphabet(context, String text) {
    //todo need arabic validation
    if (!isAlpha(text)) {
      return Lang.getString(context, "Only_letters");
    }
    return null;
  }
}
