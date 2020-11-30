import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:validators/validators.dart';

class Validation {
  static bool isPhoneNumber(String number) {
    //todo validate phone
    return true;
  }

  static String invalid(context) {
    return Lang.getString(context, "Invalid");
  }

  static String validate(String value, context,
      {bool email,
      bool alphabetic,
      bool alphabeticIgnoreSpaces,
      bool phone,
      bool empty,
      bool short,
      int length}) {
    if (empty == true && isNullOrEmpty(value)) {
      return Lang.getString(context, "Cannot_be_empty");
    }
    if (short == true && value.length < length) {
      return Lang.getString(context, "Too_short");
    }
    if (alphabetic == true && !isAlphabet(value)) {
      //todo need arabic validation
      return Lang.getString(context, "Only_letters");
    }
    if (alphabeticIgnoreSpaces == true) {
      //todo need arabic validation
      if (!isAlphabet(value.replaceAll(RegExp(r"\s+|,|\."), ""))) {
        return Lang.getString(context, "Only_letters");
      }
    }
    if (email == true && !validEmail(value)) {
      return Lang.getString(context, "Invalid");
    }
    if (phone == true && !isPhoneNumber(value)) {
      return Lang.getString(context, "Invalid");
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
    return isEmail(emailaddress);
  }

  static bool isAlphabet(String text) {
    return isAlpha(text);
  }
}
