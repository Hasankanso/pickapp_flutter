import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/baseModel.dart';

part 'UserStatistics.g.dart';

@HiveType(typeId: 13)
class UserStatistics extends BaseModel {
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
  final int ratesCount;
  @HiveField(7)
  final double rateAverage;
  @HiveField(8)
  int acomplishedRides;
  @HiveField(9)
  int canceledRides;

  UserStatistics(
      this.ones,
      this.twos,
      this.threes,
      this.fours,
      this.fives,
      this.rateAverage,
      this.ratesCount,
      this.acomplishedRides,
      this.canceledRides);

  static UserStatistics fromJson(Map<String, dynamic> json) {
    int ones = json["ones"];
    int twos = json["twos"];
    int threes = json["threes"];
    int fours = json["fours"];
    int fives = json["fives"];
    int ratesCount = json["ratesCount"];
    double rateAverage = json["rateAverage"].toDouble();
    int acomplishedRides = json["acomplishedRides"];
    int canceledRides = json["canceledRides"];

    return new UserStatistics(ones, twos, threes, fours, fives, rateAverage,
        ratesCount, acomplishedRides, canceledRides);
  }

  UserStatistics createNewStatistics(Rate rate) {
    int grade = rate.grade.floor();
    int ones = this.ones;
    int twos = this.twos;
    int threes = this.threes;
    int fours = this.fours;
    int fives = this.fives;
    int ratesCount = this.ratesCount;
    double rateAverage = this.rateAverage;
    switch (grade) {
      case 1:
        ones += 1;
        break;
      case 2:
        twos += 1;
        break;
      case 3:
        threes += 1;
        break;
      case 4:
        fours += 1;
        break;
      case 5:
        fives += 1;
        break;
    }
    rateAverage = (rateAverage * ratesCount + rate.grade) / (ratesCount + 1);
    ratesCount += 1;
    return UserStatistics(ones, twos, threes, fours, fives, rateAverage,
        ratesCount, acomplishedRides, canceledRides);
  }

  @override
  String toString() {
    return 'UserStatistics{ones: $ones, twos: $twos, threes: $threes, fours: $fours, fives: $fives, rateCount: $ratesCount, rateAverage: $rateAverage, acomplishedRides: $acomplishedRides, canceledRides: $canceledRides}';
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
}
