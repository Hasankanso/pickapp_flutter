import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Chat.g.dart';

@HiveType(typeId: 10)
class Chat {
  static final int chunkSize = 50;

  ValueNotifier<String> newMessage = new ValueNotifier("");
  @HiveField(0)
  String id;

  @HiveField(1)
  Message lastMessage;

  @HiveField(2)
  Person person;

  @HiveField(3)
  bool isNewMessage;

  @HiveField(4)
  int lastChunkIndex;
  int _currentOldestChunk;

  List<Message> _messages;

  List<Message> get messages => _messages;

  List<Message> get lastMessagesChunk {
    int start = messages.length % chunkSize;
    return messages.sublist(start);
  }

  Chat({String id, DateTime date, Person person, bool isNewMessage}) {
    this.id = id;
    this._messages = [];
    this.person = person;
    this.isNewMessage = isNewMessage;
    this.lastChunkIndex = 0;
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

  Future<void> initMessages() async {
    _currentOldestChunk = lastChunkIndex;
    _messages = [];
    await loadMessages();
    if (_messages == null) _messages = [];
  }

  Future<void> loadMessages() async {
    if (_currentOldestChunk < 0) return;
    Box<Message> box;

    if (_currentOldestChunk <= lastChunkIndex) {
      box = await Hive.openBox<Message>('$id.messages.$_currentOldestChunk');
      _currentOldestChunk -= 1;
      _messages = List<Message>.from(box.values)..addAll(_messages);

      //if the last chunk is small, we need to load more messages.
      if (_currentOldestChunk == lastChunkIndex &&
          _messages.length < chunkSize &&
          _currentOldestChunk > 0) {
        box.close();
        box = await Hive.openBox<Message>('$id.messages.$_currentOldestChunk');
        _currentOldestChunk -= 1;
        _messages = List<Message>.from(box.values)..addAll(_messages);
      }
    }
  }

  void addAndCacheMessage(Message message) async {
    print("adding message to hive and chat");
    if (_messages != null && newMessage != null) {
      _messages.add(message);
      newMessage.value = message.message;
    }

    Box<Message> messagesBox = await Hive.openBox<Message>('$id.messages.$lastChunkIndex');

    //if chunk is full, open new one.
    if (messagesBox.length >= chunkSize) {
      lastChunkIndex += 1;
      messagesBox.close();
      messagesBox = await Hive.openBox<Message>('$id.messages.$lastChunkIndex');
    }

    //need to update chatbox because of newMessage field and lastChunkIndex field.
    Box<Chat> chatBox = await Hive.openBox('chat');
    lastMessage = message;
    chatBox.put(person.id, this);

    messagesBox.add(message);
  }
}
