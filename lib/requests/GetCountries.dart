import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/requests/Request.dart';

class GetCountries extends Request<List<CountryInformations>> {
  GetCountries() {
    httpPath = "/PersonBusiness/GetCountries";
  }

  @override
  buildObject(json) {
    return List<CountryInformations>.from(
        json.map((x) => CountryInformations.fromJson(x)));
  }

  @override
  Map<String, dynamic> getJson() {
    return {};
  }

  @override
  String isValid() {
    return null;
  }
}
