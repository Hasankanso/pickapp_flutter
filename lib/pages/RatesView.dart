import 'package:flutter/widgets.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/items/RateTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class RatesView extends StatelessWidget {


  List<Rate> rates;

  RatesView(this.rates);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(title: "Rates",),
      body: ListBuilder(
          list: rates,
          itemBuilder: RateTile.itemBuilder(rates)),
    );
  }
}
