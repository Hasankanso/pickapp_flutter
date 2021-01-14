import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Message.g.dart';


@HiveType(typeId: 11)
@reflector
class Message {

  @HiveField(0)
  DateTime date;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final bool myMessage;

  @HiveField(3)
  String senderId;

  Message({this.senderId, this.message, this.date, this.myMessage}){
    if(date ==null) {
      this.date = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "partnerId": "$senderId",
    "message": "$message",
    "myMessage": "$myMessage",
    "date": "$date"
  };

  Message.fromJson(Map<String, dynamic> json)
      : senderId = json["senderId"],
        message = json["message"],
        myMessage = json["myMessage"],
        date = json['date'];

  @override
  String toString() {
    return '{message: $message, date: $date, senderId: $senderId, myMessage: $myMessage}';
  }
}
