import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/CountryInformations.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/Message.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/dataObjects/UserStatistics.dart';
import 'package:just_miles/dataObjects/baseModel.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/repository/i_repository.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

abstract class Repository<T extends BaseModel> implements IRepository<T> {
  // Add Box name(table)
  final boxName = {
    User: User.boxName,
    Person: Person.boxName,
    Driver: Driver.boxName,
    Chat: Chat.boxName,
    Rate: Rate.boxName,
    Ride: Ride.boxName,
  };

  static Future<void> initializeHive() async {
    final path = await pathProvider.getApplicationDocumentsDirectory();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.init(path.path);
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(PersonAdapter());
      Hive.registerAdapter(DriverAdapter());
      Hive.registerAdapter(CountryInformationsAdapter());
      Hive.registerAdapter(CarAdapter());
      Hive.registerAdapter(MainLocationAdapter());
      Hive.registerAdapter(RideAdapter());
      Hive.registerAdapter(RateAdapter());
      Hive.registerAdapter(ReservationAdapter());
      Hive.registerAdapter(ChatAdapter());
      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(MainNotificationAdapter());
      Hive.registerAdapter(UserStatisticsAdapter());
    }
  }

  openBox(String tableName) async {
    var box;
    if (!Hive.isBoxOpen(tableName)) {
      box = await Hive.openBox(tableName);
    } else {
      box = Hive.box(tableName);
    }
    return box;
  }

  @override
  Future<bool> insert(T object) async {
    if (object == null) {
      return false;
    }
    try {
      String boxName = this.boxName[T];
      var box = await openBox(boxName);

      List<T> listToSave = [];

      var savedObjects = box.get(boxName);
      if (savedObjects != null) savedObjects = savedObjects.cast<T>();
      List<T> listObjects = savedObjects;
      if (listObjects != null) listToSave.addAll(listObjects);
      listToSave.add(object);

      await box.put(boxName, listToSave);
      await box.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> insertAll(List<T> objects) async {
    if (objects == null) {
      return false;
    }
    try {
      String boxName = this.boxName[T];
      var box = await openBox(boxName);

      List<T> listToSave = [];

      var savedObjects = box.get(boxName);
      if (savedObjects != null) savedObjects = savedObjects.cast<T>();
      List<T> listObjects = savedObjects;
      if (listObjects != null) listToSave.addAll(listObjects);
      listToSave.addAll(objects.toList());

      await box.put(boxName, listToSave);
      await box.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<T>> getAll() async {
    String boxName = this.boxName[T];
    var box = await openBox(boxName);

    List<T> returnedObjects = [];

    var objects = box.get(boxName);
    if (objects != null) {
      objects = objects.cast<T>();
      returnedObjects = new List<T>.from(objects);
    }
    await box.close();
    return returnedObjects;
  }

  @override
  Future<List<T>> upsert(List<T> objects) async {
    try {
      String boxName = this.boxName[T];
      Box box = await openBox(boxName);

      List<T> listToSave = [];

      var savedObjects = box.get(boxName);
      if (savedObjects != null) {
        savedObjects = savedObjects.cast<T>();
        listToSave.addAll(savedObjects);
      }
      bool needsUpdate = false;
      if (objects.isNotEmpty) {
        needsUpdate = true;
        if (listToSave.isNotEmpty) {
          List<T> toRemoveObjects = [];
          for (int i = 0; i < listToSave.length; i++) {
            for (int j = 0; j < objects.length; j++) {
              if (objects[j].id == listToSave[i].id) {
                listToSave[i] = objects[j];
                toRemoveObjects.add(objects[j]);
                break;
              }
            }
          }
          if (toRemoveObjects.isNotEmpty) {
            objects.removeWhere((object) => toRemoveObjects.contains(object));
          }
        }
      }
      listToSave.addAll(objects);
      if (needsUpdate) {
        await box.put(boxName, listToSave);
      }
      await box.close();
      return listToSave;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<T>> update(List<T> objects) async {
    try {
      String boxName = this.boxName[T];
      var box = await openBox(boxName);
      await box.put(boxName, objects);
      await box.close();
      return objects;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<T>> updateById(T t) async {
    try {
      String boxName = this.boxName[T];
      var box = await openBox(boxName);
      List<T> objects = [];
      var dbObjects = box.get(boxName);
      if (dbObjects != null) {
        dbObjects = dbObjects.cast<T>();
        objects = new List<T>.from(dbObjects);
      }
      objects.remove(t);
      objects.add(t);
      await box.put(boxName, objects);
      await box.close();
      return objects;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<T> getById(String id) async {
    if (id == null) {
      return null;
    }
    try {
      List<T> objects = await this.getAll();
      for (final object in objects) {
        if (object.id == id) {
          return object;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<T>> deleteById(String id) async {
    if (id == null) {
      return [];
    }
    try {
      List<T> allObjects = [];
      String boxName = this.boxName[T];

      var box = await openBox(boxName);

      var objects = box.get(boxName);
      if (objects != null) {
        objects = objects.cast<T>();
        allObjects = new List<T>.from(objects);
      }

      allObjects.removeWhere((object) => object.id == id);

      await box.put(boxName, allObjects);
      await box.close();
      return allObjects;
    } catch (e) {
      return [];
    }
  }

  Future<List<T>> deleteByListId(List<T> list) async {
    if (list == null) {
      return [];
    }
    try {
      List<T> allObjects = [];
      String boxName = this.boxName[T];

      var box = await openBox(boxName);

      var objects = box.get(boxName);
      if (objects != null) {
        objects = objects.cast<T>();
        allObjects = new List<T>.from(objects);
      }
      for (int i = 0; i < list.length; i++) {
        allObjects.removeWhere((object) => object.id == list[i].id);
      }

      await box.put(boxName, allObjects);
      await box.close();
      return allObjects;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateOneObject(T object, {bool keepBoxOpen = false}) async {
    if (object == null) {
      return false;
    }
    try {
      String boxName = this.boxName[T];
      var box = await openBox(boxName);
      await box.put(boxName, object);
      if (!keepBoxOpen) {
        await box.close();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<T> get() async {
    try {
      String boxName = this.boxName[T];
      var box = await openBox(boxName);

      var object = box.get(boxName);
      await box.close();
      return object;
    } catch (e) {
      return null;
    }
  }
}
