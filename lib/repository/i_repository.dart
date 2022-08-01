import 'package:just_miles/dataObjects/BaseDataObject.dart';

abstract class IRepository<T extends BaseDataObject> {
  Future<bool> insert(T values);
  Future<List<T>> upsert(List<T> list);
  Future<List<T>> update(List<T> objects);
  Future<List<T>> updateById(T t);
  Future<List<T>> deleteById(String id);
  Future<T> getById(String id);
  Future<List<T>> getAll();
  Future<bool> updateOneObject(T object, {bool keepBoxOpen = false});
  Future<T> get();
  Future<bool> insertAll(List<T> objects);
}
