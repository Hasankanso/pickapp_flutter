import 'package:flutter/material.dart';

class ListBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final List<Object> list;
  final bool reverse;
  ListController listController = new ListController();
  ScrollController controller = new ScrollController(initialScrollOffset: 1.1);
  ListBuilder(
      {this.list, this.itemBuilder, this.controller, this.reverse = false});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      child: ListView.builder(
          controller: controller,
          reverse: reverse,
          itemBuilder: itemBuilder,
          itemCount: list.length),
    );
  }
}

class ListController {
  int selected = -1;
}
