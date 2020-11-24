import 'package:flutter/material.dart';

class ListBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final List<Object> list;

  ListBuilder({this.list, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: false, itemBuilder: itemBuilder, itemCount: list.length);
  }
}
