import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/repository/repository.dart';
import 'package:just_miles/repository/ridesHistory/i_rides_history_repository.dart';

class RidesHistoryRepository extends Repository<Ride>
    implements IRidesHistoryRepository {}
