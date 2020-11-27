import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class GetUserReviews extends Request<List<Rate>> {
  User _user;

  GetUserReviews(this._user) {
    httpPath = "/RateBusiness/GetRate";
  }

  @override
  List<Rate> buildObject(json) {
    return json ? List<Rate>.from(json.map((x) => Rate.fromJson(x))) : null;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'user': _user.id,
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(_user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    return null;
  }
}
