import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Chat.g.dart';


@HiveType(typeId : 10)
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chat && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  void addMessage(Message message){
    print("adding message to hive and chat");
    _messages.add(message);

    assert(Hive.isBoxOpen('chat'));

    Hive.box('chat').put(person.id, this);
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
}
