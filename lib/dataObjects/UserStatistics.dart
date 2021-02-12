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
  @HiveField(6)
  final int rateCount;
  @HiveField(7)
  final double rateAverage;
  @HiveField(8)
  final int acomplishedRides;
  @HiveField(9)
  final int canceledRides;

  UserStatistics(
      this.ones,
      this.twos,
      this.threes,
      this.fours,
      this.fives,
      this.rateAverage,
      this.rateCount,
      this.acomplishedRides,
      this.canceledRides);

  static UserStatistics fromJson(Map<String, dynamic> json) {
    int ones = json["ones"];
    int twos = json["twos"];
    int threes = json["threes"];
    int fours = json["fours"];
    int fives = json["fives"];
    int rateCount = json["rateCount"];
    double rateAverage = json["rateAverage"].toDouble();
    int acomplishedRides = json["acomplishedRides"];
    int canceledRides = json["canceledRides"];
    return new UserStatistics(ones, twos, threes, fours, fives, rateAverage,
        rateCount, acomplishedRides, canceledRides);
  }

  @override
  String toString() {
    return 'UserStatistics{ones: $ones, twos: $twos, threes: $threes, fours: $fours, fives: $fives, rateCount: $rateCount, rateAverage: $rateAverage, acomplishedRides: $acomplishedRides, canceledRides: $canceledRides}';
  }
}
