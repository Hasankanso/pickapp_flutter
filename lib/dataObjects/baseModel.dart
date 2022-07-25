abstract class BaseModel {
  String id;
  static String get boxName => "Box name is not registered";
  Map<String, dynamic> toJson();
}
