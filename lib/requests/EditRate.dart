import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/requests/Request.dart';

class EditRate extends Request<Rate> {
  Rate _rate;

  EditRate(this._rate) {
    httpPath = "";
  }

  @override
  Rate buildObject(json) {
    // TODO: implement buildObject
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> getJson() {
    return _rate.toJson();
  }
}
