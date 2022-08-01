import 'package:just_miles/dataObjects/Chat.dart';

abstract class IChatRepository {
  Future<Chat> getChat(String key, {Chat toStoreChat});
  Future<List<Chat>> getChats();
  Future<void> deleteChats();
  Future<Chat> insertChat(Chat chat);
  Future<void> deleteChat(String key);
}
