import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:pickapp/classes/Validation.dart';

abstract class Request<T> {
  static String host;
  String httpPath;

  Map<String, dynamic> getJson();
  String isValid();

  T buildObject(json);

  void send(Function(T, int, String) callback) async {
    String valid = isValid();
    print(valid);
    if (!Validation.isNullOrEmpty(valid)) {
      callback(null, 406, valid);
    } else {
      Map<String, dynamic> data = getJson();
      print(data);
      http.Response response = await http.post(
        host + httpPath,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: json.encode(data, toEncodable: _dateToIso8601String),
      );

      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      print(decodedResponse);
      if (response.body.contains("code")) {
        //extracting code and message
        var jCode =
            response.body.contains("code") ? decodedResponse["code"] : null;
        var jMessage = decodedResponse["message"];

        if (jCode == null) {
          var jbody = decodedResponse["body"];

          if (jbody != null) {
            jCode = jbody["code"];
            jMessage = jbody["message"];
          }
        }
        //check if there's error

        if (jCode != null) {
          callback(null, int.parse(jCode), jMessage);
          return;
        }
      }
      callback(buildObject(decodedResponse), response.statusCode,
          response.reasonPhrase);
    }
  }

  dynamic _dateToIso8601String(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  static void initBackendless() async {
    String APPLICATION_ID = "5FB0EA72-A363-4451-FFA5-A56F031D6600";
    String API_KEY = "C8502745-CB10-4F56-9FD5-3EFCE59F1926";
    Backendless.initApp(APPLICATION_ID, API_KEY, API_KEY);
    host = "https://api.backendless.com/" +
        await Backendless.getApplicationId() +
        "/" +
        await Backendless.getApiKey() +
        "/services";
    print(host);
  }
}
