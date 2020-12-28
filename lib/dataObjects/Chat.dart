import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';


@HiveType(typeId: 10)
class Chat{
  @HiveField(0)
  String _id;

  @HiveField(1)
  DateTime _lastMessagedate;

  @HiveField(2)
  List<Message> _messages = new List<Message>();

  @HiveField(3)
  Person _person;

  @HiveField(4)
  bool _isNewMessage;

  Chat(
      {String id,
      DateTime date,
      List<Message> messages,
      Person person,
      bool isNewMessage}) {
    _id = id;
    _lastMessagedate = date;
    _messages = messages?? new List<Message>();
    _person = person;
    _isNewMessage = isNewMessage;
  }

  @override
  String toString() {
    return 'Chat{id: $id, date: $date, messages: $messages, person: $person, isNewMessage: $isNewMessage}';
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  void addMessage(String message){
    _messages.add(Message(message : message, date : DateTime.now(), person : _person));
  }

  bool get isNewMessage => _isNewMessage;

  set isNewMessage(bool value) {
    _isNewMessage = value;
  }

  Person get person => _person;

  set person(Person value) {
    _person = value;
  }

  List<Message> get messages => _messages;


  DateTime get date => _lastMessagedate;

  set date(DateTime value) {
    _lastMessagedate = value;
  }

  @override
  Chat read(BinaryReader reader) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  // TODO: implement typeId
  int get typeId => throw UnimplementedError();

  @override
  void write(BinaryWriter writer, Chat obj) {
    // TODO: implement write
  }
}
