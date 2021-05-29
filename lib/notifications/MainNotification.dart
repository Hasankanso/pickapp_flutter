import 'package:hive/hive.dart';

part 'MainNotification.g.dart';

@HiveType(typeId: 12)
class MainNotification {
  @HiveField(0)
  int _id;
  @HiveField(1)
  String _objectId;
  @HiveField(2)
  String _action;
  @HiveField(3)
  String _title;
  @HiveField(4)
  String _body;
  @HiveField(5)
  DateTime _scheduleDate;
  @HiveField(6)
  String _subtitle;
  @HiveField(7)
  String _imagePath;
  @HiveField(8)
  String _imageUrl;
  @HiveField(9)
  Object object;
  @HiveField(10)
  DateTime sentTime;
  @HiveField(11)
  String dictId;

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
      this.dictId}) {
    this.id = id;
    this.objectId = objectId;
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
      : _objectId = json["objectId"],
        dontCache = json["dontCache"] == null
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
        sentTime = json["sentTime"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'objectId': this.objectId,
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

  String get objectId => _objectId;

  set objectId(String value) {
    _objectId = value;
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

  int get id => _id;

  set id(value) {
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
  String toString() {
    return 'MainNotification{_id: $_id, _objectId: $_objectId, _action: $_action, _title: $_title, _body: $_body, _scheduleDate: $_scheduleDate, _subtitle: $_subtitle, _imagePath: $_imagePath, _imageUrl: $_imageUrl}';
  }
}
