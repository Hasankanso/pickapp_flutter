import 'package:hive/hive.dart';

part 'UserStatistics.g.dart';

@HiveType(typeId: 13)
class UserStatistics {
  @HiveField(1)
  final int ones;
  @HiveField(2)
  final int twos;
  @HiveField(3)
  final int threes;
  @HiveField(4)
  final int fours;
  @HiveField(5)
  final int fives;

  UserStatistics(this.ones, this.twos, this.threes, this.fours, this.fives);

  static UserStatistics fromJson(Map<String, dynamic> json) {
    int ones = json["ones"];
    int twos = json["twos"];
    int threes = json["threes"];
    int fours = json["fours"];
    int fives = json["fives"];
    return new UserStatistics(ones, twos, threes, fours, fives);
  }
}
