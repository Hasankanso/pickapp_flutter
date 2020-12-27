import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';

class Chat {
  int _id;
  DateTime _date;
  List<Message> _messages = new List<Message>();
  Person _person;
  bool _isNewMessage;

  Chat(
      {String id,
      DateTime date,
      List<Message> messages,
      Person person,
      bool isNewMessage}) {
    id = id;
    date = date;
    messages = messages;
    person = person;
    isNewMessage = isNewMessage;
  }
  @override
  String toString() {
    return 'Chat{id: $id, date: $date, messages: $messages, person: $person, isNewMessage: $isNewMessage}';
  }

  int get id => _id;

  set id(int value) {
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


  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }
}
