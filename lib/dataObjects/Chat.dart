import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Chat.g.dart';

@HiveType(typeId: 10)
class Chat {
  @HiveField(0)
  String id;

  @HiveField(1)
  Message lastMessage;

  @HiveField(2)
  List<Message> messages = [];

  @HiveField(3)
  Person person;

  @HiveField(4)
  bool isNewMessage;

  Chat({String id, DateTime date, List<Message> messages, Person person, bool isNewMessage}) {
    this.id = id;
    this.messages = messages ?? [];
    this.person = person;
    this.isNewMessage = isNewMessage;
  }

  @override
  String toString() {
    return 'Chat{id: $id, messages: $messages, person: $person, isNewMessage: '
        '$isNewMessage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Chat && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  void cacheMessage(Message message) {
    print("adding message to hive and chat");
    messages.add(message);

    assert(Hive.isBoxOpen('chat'));

    Hive.box('chat').put(person.id, this);
  }
}
