import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/Message.dart';
import 'package:just_miles/repository/chat/i_chat_repository.dart';
import 'package:just_miles/repository/repository.dart';

class ChatRepository extends Repository<Chat> implements IChatRepository {
  Future<Chat> insertChat(Chat chat) async {
    Box<Chat> box = await Repository.openBox(Chat.boxName);
    await box.put(chat.id, chat);
    await box.close();
    return chat;
  }

  //will get chat correspondent to key, if not found and toStoreChat is provided, toStoreChat
  // will be cached instead, and returned
  Future<Chat> getChat(String key, {Chat toStoreChat}) async {
    Box<Chat> box = await Repository.openBox(Chat.boxName);

    Chat chat = box.get(key);

    if (chat == null && toStoreChat != null) {
      chat = toStoreChat;
      await box.put(key, toStoreChat);
    }
    await box.close();

    return chat;
  }

  Future<List<Chat>> getChats() async {
    Box<Chat> box = await Repository.openBox(Chat.boxName);
    var values = box.values;
    assert(values != null);
    List<Chat> chats = values.toList();
    if (chats == null) return [];
    return chats;
  }

  Future<void> deleteChats() async {
    Box<Chat> box = await Repository.openBox(Chat.boxName);

    Iterable<Chat> iterable = box.values;
    for (Chat chat in iterable) {
      await _clearHiveChat(chat); // delete chat chunks.
    }

    await box.deleteFromDisk();
  }

  Future<void> deleteChat(String key) async {
    Box<Chat> box = await Repository.openBox(Chat.boxName);
    Chat chat = box.get(key);
    await _clearHiveChat(chat);
    await box.delete(key);
    await box.close();
  }

  static Future<void> _clearHiveChat(Chat chat) async {
    if (chat == null) return;

    for (int i = chat.lastChunkIndex; i >= 0; i--) {
      var messageBox = await Hive.openBox<Message>('${chat.id}.messages.$i');
      await messageBox.deleteFromDisk();
    }
  }
}
