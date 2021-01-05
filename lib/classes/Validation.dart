import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/User.dart';

class Validation {
  static String invalid(context) {
    return Lang.getString(context, "Invalid");
  }

  static String isPhoneNumber(context, String number) {
    //only numbers ex:70458013
    if (!RegExp(r"^[\u0660-\u06690-9]*$").hasMatch(number)) {
      return Lang.getString(context, "Invalid");
    }
    return null;
  }

  static String isEmail(context, String email) {
    if (!RegExp(
            r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
        .hasMatch(email)) {
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
    if (!RegExp(r"^[\u0621-\u064Aa-zA-Z\‎\ \‏]*$").hasMatch(value)) {
      return Lang.getString(context, "Only_letters");
    }
    return null;
  }

  static String isAlphaNumericIgnoreSpaces(context, String value) {
    if (!RegExp(
      r"^[\u0621-\u064A\u0660-\u0669a-zA-Z0-9\.\؛\٫\,\!\?\،\:\'\ \‎\-\_\;\(\)\`\‏]*$",
      unicode: false,
      multiLine: true,
    ).hasMatch(value)) {
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
}
