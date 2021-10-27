import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/requests/AutoLogin.dart';
import 'package:path/path.dart' as Path;

enum VoomcarImageType { Car, Profile, Map }

abstract class Request<T> {
  static String host, filesHost;
  String httpPath;

  Map<String, dynamic> getJson();

  T buildObject(json);

  List checkError(http.Response response, dynamic decodedResponse) {
    if (decodedResponse.length != 0 &&
        decodedResponse[0] == null && //why decodedResponse[0] == null?
        decodedResponse["code"] != "null") {
      //extracting code and message
      if (response.body.contains("code")) {
        var jCode = decodedResponse["code"];
        var jMessage = decodedResponse["message"];
        if (jCode == null) {
          var jbody = decodedResponse["body"];
          if (jbody != null) {
            jCode = jbody["code"];
            jMessage = jbody["message"];
          }
        }
        assert(!(jCode != null && jMessage == null));
        assert(!(jCode == null && jMessage != null));

        if (jCode != null && jMessage != null) {
          return [jCode, jMessage];
        }
      }
    }
    return []; // there's no error.
  }

  // return true if there's an error
  Future<bool> handleGeneralErrors(
      http.Response response, dynamic decodedResponse, Function(T, int, String) callback) async {
    //check if there's error
    var codeMessage = checkError(response, decodedResponse);
    if (codeMessage.length != 2) {
      return false;
    }
    print("code and message: " + codeMessage[0].toString() + " " + codeMessage[1].toString());
    var jCode = codeMessage[0];
    var jMessage = codeMessage[1];

    var code = jCode is String ? int.tryParse(jCode) : jCode;

    // 3003 login information are wrong.
    if (code == 3003) {
      return true;
    } else if (App.user != null &&
        (code == 3048 || // 3048 is wrong login information by backendless
            App.user.sessionToken == null ||
            App.user.sessionToken.isEmpty)) {
      //if there's no session token, request it.
      App.user.sessionToken = null;
      String token = await AutoLogin(App.user.id, App.user.password).send((a, b, c) {});

      if (token == null) {
        await App.logout();
        return true;
      } else {
        App.user.sessionToken = token;
        await send(callback);
        return true;
      }
    }

    callback(null, code, jMessage);
    return true;
  }

  Future<T> send(Function(T, int, String) callback) async {
    Map<String, dynamic> data = getJson();
    String jsonData = json.encode(data, toEncodable: _dateToIso8601String);

    //if this is about a register send request, App will not even have a user, nor a sessionToken.
    var header;
    if (App.user == null || App.user.sessionToken == null) {
      header = <String, String>{'Content-Type': 'application/json; charset=utf-8'};
    } else {
      header = <String, String>{
        'user-token': App.user.sessionToken,
        'Content-Type': 'application/json; charset=utf-8'
      };
    }
    print("api::" + host + httpPath);
    print("json body " + data.toString());
    //send request
    http.Response response = await http
        .post(
          Uri.parse(host + httpPath),
          headers: header,
          body: jsonData,
        )
        .timeout(const Duration(seconds: 20))
        .catchError((Object o) {
      callback(null, HttpStatus.networkConnectTimeoutError, "no_internet_connection");
      return null;
    });

    //check response existence
    if (response == null) {
      print("no response");
      callback(null, HttpStatus.expectationFailed, "Something_Wrong");
      return null;
    }

    //decode response
    var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
    print("backendless: " + decodedResponse.toString());

    // deal with backendless errors
    bool isError = await handleGeneralErrors(response, decodedResponse, callback);
    if (isError) {
      return null;
    }

    //parse returned object.
    try {
      T object = buildObject(decodedResponse);

      callback(object, response.statusCode, response.reasonPhrase);
      return object;
    } catch (e) {
      print(e);
      callback(null, HttpStatus.partialContent, "Something_Wrong");
      return null;
    }
  }

  static Future<String> uploadImage(String path, VoomcarImageType imageType,
      {bool fromBytes = false, List<int> bytes}) async {
    String type = imageType == VoomcarImageType.Car
        ? "Car"
        : imageType == VoomcarImageType.Map
            ? ""
                "RideMaps"
            : "ProfileImages";

    var header;
    if (App.user == null || App.user.sessionToken == null) {
      header = <String, String>{'Content-Type': 'multipart/form-data'};
    } else {
      header = <String, String>{
        'user-token': App.user.sessionToken,
        'Content-Type': 'multipart/form-data'
      };
    }

    String url = filesHost +
        "/images/$type/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        Path.extension(path);
    print(url);

    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);

    request.headers.addAll(header);

    if (fromBytes) {
      request.files.add(http.MultipartFile.fromBytes('file', bytes));
    } else {
      try {
        request.files.add(await http.MultipartFile.fromPath('file', path));
      } catch (e) {
        return path;
      }
    }
    var response = await request.send().timeout(const Duration(seconds: 20)).catchError((Object o) {
      return null;
    });

    String imageURL = await response.stream.transform(utf8.decoder).first;
    var json = jsonDecode(imageURL);

    if (json["fileURL"] != null) {
      print(json["fileURL"]);

      return json["fileURL"];
    }
    return "";
  }

  dynamic _dateToIso8601String(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  static void initBackendless() {
    String APPLICATION_ID = "5FB0EA72-A363-4451-FFA5-A56F031D6600";
    String ANDROID_API_KEY = "F19BE3D6-62D4-4AD0-B403-E94276C971C0";
    String IOS_API_KEY = "D2DDEB57-BEBC-48EB-9E07-39A5DB9D8CEF";
    String REST_API_KEY = "A47932AF-43E1-4CDC-9B54-12F8A88FB22E";

    host = "https://api.backendless.com/" + APPLICATION_ID + "/" + REST_API_KEY + "/services";
    filesHost = "https://api.backendless.com/" + APPLICATION_ID + "/" + REST_API_KEY + "/files";
  }

  onError() {}
}
