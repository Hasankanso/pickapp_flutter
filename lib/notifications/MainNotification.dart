import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/BaseDataObject.dart';

part 'MainNotification.g.dart';

@HiveType(typeId: 12)
class MainNotification extends BaseDataObject {
  @HiveField(0)
  int _id;
  @HiveField(1)
  String _action;
  @HiveField(2)
  String _title;
  @HiveField(3)
  String _body;
  @HiveField(4)
  DateTime _scheduleDate;
  @HiveField(5)
  String _subtitle;
  @HiveField(6)
  String _imagePath;
  @HiveField(7)
  String _imageUrl;
  @HiveField(8)
  Object object;
  @HiveField(9)
  DateTime sentTime;
  @HiveField(10)
  String dictId;

  bool isMinimized;
  bool dontCache;

  static List<MainNotification> notifications = [];

  MainNotification(
      {String title,
      String body,
      int id,
      String objectId,
      String action,
      DateTime scheduleDate,
      String imagePath,
      String subtitle,
      String imageUrl,
      Object object,
      DateTime sentTime,
      this.isMinimized,
      this.dictId}) {
    this.notificationId = id;
    this.body = body;
    this.title = title;
    this.action = action;
    this.scheduleDate = scheduleDate;
    this.imagePath = imagePath;
    this.subtitle = subtitle;
    this.imageUrl = imageUrl;
    this.object = object;
    this.sentTime = sentTime;
  }

  MainNotification.fromJson(Map<String, dynamic> json)
      : dontCache = json["dontCache"] == null
            ? false
            : json["dontCache"] == "true"
                ? true
                : false,
        _action = json["action"],
        _title = json["title"],
        _subtitle = json["subtitle"],
        dictId = json["dictId"],
        _body = json["body"],
        _scheduleDate = json["scheduleDate"],
        _imagePath = json["imagePath"],
        _imageUrl = json["imageUrl"],
        object = json["object"],
        isMinimized = json["isMinimized"].toString().toLowerCase() == "true",
        sentTime = json["sentTime"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'action': this.action,
        'title': this.title,
        'body': this.body,
        'subtitle': this.subtitle,
        'imagePath': this.imagePath,
        'imageUrl': this.imageUrl,
        'dictId': this.dictId
      };

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get imageUrl => _imageUrl;

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get body => _body;

  set body(value) {
    _body = value;
  }

  get action => _action;

  set action(value) {
    _action = value;
  }

  String get id => _id.toString();

  set id(value) {
    _id = int.parse(value);
  }

  int get notificationId => _id;

  set notificationId(value) {
    _id = value;
  }

  String get subtitle => _subtitle;

  set subtitle(String value) {
    _subtitle = value;
  }

  DateTime get scheduleDate => _scheduleDate;

  set scheduleDate(DateTime value) {
    _scheduleDate = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainNotification &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() {
    return 'MainNotification{_id: $_id, _action: $_action, _title: $_title, _body: $_body, _scheduleDate: $_scheduleDate, _subtitle: $_subtitle, _imagePath: $_imagePath, _imageUrl: $_imageUrl}';
  }

  static String get boxName => "notifications";
}
