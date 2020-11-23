import 'package:flutter/material.dart';
import 'package:pickapp/utilities/MyRidesListTile.dart';

class ListBuilder extends StatelessWidget {
  final List<dynamic> list;
  final Function ListTileBuilder;
  ListBuilder(this.list,this.ListTileBuilder);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      itemBuilder: (_, int index) {
        return ListTileBuilder(
        list[index],
      );
      },
      itemCount: list.length,
    );
  }
}
