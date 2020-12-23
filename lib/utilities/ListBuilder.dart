import 'package:flutter/material.dart';

class ListBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final List<Object> list;
  ListController listController = new ListController();

  ListBuilder({this.list, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: false, itemBuilder: itemBuilder, itemCount: list.length);
  }
}

class ListController {
  int selected = -1;
}
