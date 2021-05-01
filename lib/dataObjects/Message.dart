import 'package:hive/hive.dart';

part 'Message.g.dart';

@HiveType(typeId: 11)
class Message {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final bool myMessage;

  @HiveField(3)
  String senderId;

  String token;

  Message({this.senderId, this.message, this.date, this.myMessage}) {
    if (date == null) {
      this.date = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "senderId": "$senderId",
        "message": "$message",
        "myMessage": "$myMessage",
        "date": "$date"
      };

  Message.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        senderId = json["senderId"],
        message = json["message"],
        myMessage = json["myMessage"],
        date = DateTime.parse(json['date']);

  @override
  String toString() {
    return '{message: $message, date: $date, senderId: $senderId, myMessage: $myMessage}';
  }
}
