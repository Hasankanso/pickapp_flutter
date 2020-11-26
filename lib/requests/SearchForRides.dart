import 'dart:convert';

import 'package:http/http.dart' as http;
import "package:pickapp/dataObjects/Ride.dart";
import "package:pickapp/dataObjects/SearchInfo.dart";

import 'Request.dart';

class SearchForRides extends Request<List<Ride>> {
  SearchInfo c;
  SearchForRides(this.c);
  @override
  String getPath() {
    return "/ReserveBusiness/SearchRides";
  }

  @override
  List<Ride> buildObject(dynamic string) {
    return string != null && string != "[]"
        ? List<Ride>.from(string.map((x) => Ride.fromJson(x)))
        : null;
  }

  @override
  String getJson() {
    // TODO: implement getJson
    return json.encode(c.toJson(), toEncodable: myDateSerializer);
  }

  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  Future searchForRides() async {
    http.Response response = await http.post(
      "https://api.backendless.com/5FB0EA72-A363-4451-FFA5-A56F031D6600/C8502745-CB10-4F56-9FD5-3EFCE59F1926/services/ReserveBusiness/SearchRides",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'from': "hello",
        'to': "hello",
      }),
    );
    print(response.body.toString());
  }
}
