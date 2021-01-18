class MainNotification {
  int _id;
  String _objectId;
  String _action;
  String _title;
  String _description;
  String _subtitle;
  DateTime _scheduleDate;

  MainNotification(
      {String title,
      String description,
      int id,
      String objectId,
      String action,
      DateTime scheduleDate,
      String subtitle}) {
    this.id = id;
    this.objectId = objectId;
    this.description = description;
    this.title = title;
    this.action = action;
    this.scheduleDate = scheduleDate;
    this.subtitle = subtitle;
  }

  MainNotification.fromJson(Map<String, dynamic> json)
      : _objectId = json["objectId"],
        _action = json["action"],
        _title = json["title"],
        _subtitle = json["subtitle"],
        _description = json["description"];
  Map<String, dynamic> toJson() => <String, dynamic>{
        'objectId': this.objectId,
        'action': this.action,
        'title': this.title,
        'description': this.description,
        'subtitle': this.subtitle,
      };

  String get objectId => _objectId;

  set objectId(String value) {
    _objectId = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  get action => _action;

  set action(value) {
    _action = value;
  }

  get id => _id;

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
}
