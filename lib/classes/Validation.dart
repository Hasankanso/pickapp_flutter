import 'package:pickapp/dataObjects/User.dart';

class Validation {
  static bool isPhoneNumber(String number) {
    //todo validate phone
    return true;
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
    //todo validate email
    return true;
  }

  static bool isAlphabet(String text) {
    //todo validate alphabet
  }
}
