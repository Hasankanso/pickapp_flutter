import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/items/RateTile.dart';
import 'package:pickapp/requests/GetDriverReviews.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class RatesListPage extends StatefulWidget {
  final Person person;

  RatesListPage(this.person);

  @override
  _RatesListPageState createState() => _RatesListPageState();
}

class _RatesListPageState extends State<RatesListPage> {


  @override
  void initState(){
    super.initState();
    if(widget.person.rates == null){
      Request getRated = GetDriverReviews(widget.person);
      getRated.send(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> reasons = App.getRateReasons(context);
    return MainScaffold(
        appBar: MainAppBar(
          title: "Rates",
        ),
        body: ListBuilder(
            list: widget.person.rates, itemBuilder: RateTile.itemBuilder(widget.person.rates, reasons)));
  }
}
