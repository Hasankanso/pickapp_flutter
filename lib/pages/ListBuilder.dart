import 'package:flutter/material.dart';
import 'package:pickapp/pages/ListTile.dart';

class ListBuilder extends StatelessWidget {
  final List<dynamic> list;

  ListBuilder(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      itemBuilder: (_, int index) => listTile(
        list[index],
      ),
      itemCount: list.length,
    );
  }
}
