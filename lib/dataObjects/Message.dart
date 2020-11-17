class Message {
  bool _owner;
  DateTime _sendDate;
  String _content;

  Message({content, sendDate, owner}) {
    this.owner = owner;
    this.sendDate = sendDate;
    this.content = content;
  }

  bool get owner => _owner;

  set owner(bool value) {
    _owner = value;
  }

  DateTime get sendDate => _sendDate;

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  set sendDate(DateTime value) {
    _sendDate = value;
  }
}
