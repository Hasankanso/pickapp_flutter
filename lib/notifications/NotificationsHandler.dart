

import 'package:flutter/cupertino.dart';

abstract class NotificationHandler<T> {

  void cache(T object);
  void updateApp(T object);
  void display(NavigatorState state, T object);
}