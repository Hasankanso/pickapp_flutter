import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/requests/Request.dart';

class GetCountries extends Request<Map<String, CountryInformations>> {
  Map<String, CountryInformations> _countryInformations;
  GetCountries() {
    httpPath = "/PersonBusiness/GetCountries";
  }
  @override
  buildObject(json) {
    this._countryInformations = Map<String, CountryInformations>();
    App.countriesInformationsNames = new List<String>();
    json != null
        ? json.map((x) {
            var c = CountryInformations.fromJson(x);
            this._countryInformations[c.name] = c;
            App.countriesInformationsNames.add(c.name);
          })
        : null;
    return _countryInformations;
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
