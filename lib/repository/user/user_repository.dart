import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/repository/repository.dart';
import 'package:just_miles/repository/user/i_user_repository.dart';

class UserRepository extends Repository<User> implements IUserRepository {
  @override
  Future<bool> updateUser(User user) async {
    user.person.rates = null;
    return super.updateOneObject(user, keepBoxOpen: true);
  }
}
