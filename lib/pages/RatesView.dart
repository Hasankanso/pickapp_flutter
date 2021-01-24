import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/items/RateTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class RatesView extends StatelessWidget {
  List<Rate> rates = List<Rate>();

  RatesView({this.rates});

  @override
  Widget build(BuildContext context) {
    List<String> reasons = App.getRateReasons(context);
    return MainScaffold(
      appBar: MainAppBar(
        title: "Rates",
      ),
      body: rates != null && rates.length > 0
          ? ListBuilder(
              list: rates, itemBuilder: RateTile.itemBuilder(rates, reasons))
          : Center(child: Text("No Rates!", style: Styles.valueTextStyle())),
    );
  }
}
