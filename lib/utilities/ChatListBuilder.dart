import 'package:flutter/material.dart';
import 'package:pickapp/utilities/ChatListTile.dart';

class ChatListBuilder extends StatelessWidget {
  final List<dynamic> list;

  ChatListBuilder(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      itemBuilder: (_, int index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            print(index);
          },
          background: Container(color: Colors.red),
          child: ChatListTile(list[index]),
        );
      },
      itemCount: list.length,
    );
  }
}
