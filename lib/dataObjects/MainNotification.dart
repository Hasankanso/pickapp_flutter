class MainNotification {
  String _title;
  String _description;
  String _id;
  String _action;

  MainNotification({
    String title,
    String description,
    String id,
    String action,
  }) {
    this.id = id;
    this.description = description;
    this.title = title;
    this.action = _action;
  }

  MainNotification.fromJson(Map<String, dynamic> json)
      : _id = json["id"],
        _action = json["action"],
        _title = json["title"],
        _description = json["description"];
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'action': this.action,
        'title': this.title,
        'description': this.description,
      };

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
}
