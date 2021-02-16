import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:pickapp/classes/Validation.dart';

abstract class Request<T> {
  static String host;
  String httpPath;

  Map<String, dynamic> getJson();

  String isValid();

  T buildObject(json);

  Future<void> send(Function(T, int, String) callback) async {
    String valid = isValid();
    print("offlineValidator (deprecated) " +
        Validation.isNullOrEmpty(valid).toString());
    if (!Validation.isNullOrEmpty(valid)) {
      callback(null, 406, valid);
    } else {
      Map<String, dynamic> data = getJson();
      String jsonData = json.encode(data, toEncodable: _dateToIso8601String);
      print("request-data: " + jsonData);
      http.Response response = await http
          .post(
            host + httpPath,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonData,
          )
          .timeout(const Duration(seconds: 11))
          .catchError((Object o) {
        callback(null, HttpStatus.networkConnectTimeoutError,
            "no_internet_connection");
        return;
      });

      if (response != null) {
        print(response.body.toString());

        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        print("backendless: " + decodedResponse.toString());

        if (decodedResponse.length != 0 &&
            decodedResponse[0] == null &&
            decodedResponse["code"] != "null") {
          print("response handled as it has an error in Request class");
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
            callback(
                null, jCode is String ? int.tryParse(jCode) : jCode, jMessage);
            return;
          }
        }
        callback(buildObject(decodedResponse), response.statusCode,
            response.reasonPhrase);
      }
    }
  }

  dynamic _dateToIso8601String(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  static Future<void> initBackendless() async {
    String APPLICATION_ID = "5FB0EA72-A363-4451-FFA5-A56F031D6600";
    String ANDROID_API_KEY = "F19BE3D6-62D4-4AD0-B403-E94276C971C0";
    String IOS_API_KEY = "D2DDEB57-BEBC-48EB-9E07-39A5DB9D8CEF";

    await Backendless.initApp(APPLICATION_ID, ANDROID_API_KEY, IOS_API_KEY);
    host = "https://api.backendless.com/" +
        await Backendless.getApplicationId() +
        "/" +
        await Backendless.getApiKey() +
        "/services";
    print(host);
  }

  onError() {}
}
