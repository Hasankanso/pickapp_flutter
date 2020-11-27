import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:http/http.dart' as http;

abstract class Request<T> {
  static String host;

  String getPath();
  String getJson();
  T buildObject(String);

  void send(Function(T, int, String) callback) async {
    String json = getJson();
    print(json);
    http.Response response = await http.post(
      host + getPath(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: getJson(),
    );
    print(response.body.toString());
    callback(buildObject(response.body.toString()), response.statusCode,
        response.reasonPhrase);
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
