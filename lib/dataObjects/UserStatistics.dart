
class UserStatistics {

  final int ones;
  final int twos;
  final int threes;
  final int fours;
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