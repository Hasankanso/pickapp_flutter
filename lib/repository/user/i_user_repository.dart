import 'package:just_miles/dataObjects/User.dart';

abstract class IUserRepository {
  Future<bool> updateUser(User user);
}
