import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/items/RateTile.dart';
import 'package:pickapp/requests/GetUserReviews.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Spinner.dart';

class ReviewsListPage extends StatefulWidget {
  final Person person;

  ReviewsListPage(this.person);

  @override
  _ReviewsListPageState createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {
  List<Rate> rates;
  List<String> reasons;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      if (widget.person.rates == null) {
        Request<List<Rate>> getRated = GetUserReviews(widget.person);
        getRated.send(response);
      } else {
        this.rates = widget.person.rates;
      }
    } else {
      _getRates();
    }
  }

  response(List<Rate> rates, int status, String reason) {
    if (status == 200) {
      setState(() {
        widget.person.rates = rates;
        _filterRates(rates);
      });
    }
  }

  _getRates() async {
    var rates = await Cache.getRates();
    setState(() {
      App.user.person.rates = rates;
      _filterRates(rates);
    });
  }

  _filterRates(List<Rate> rates) {
    this.rates = List<Rate>();
    for (int i = rates.length - 1; i >= 0; i--) {
      if (rates[i]
          .creationDate
          .isBefore(DateTime.now().add(Duration(minutes: -App.daysToShowRate))))
        this.rates.add(rates[i]);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    reasons = App.getRateReasons(context);
  }

  @override
  Widget build(BuildContext context) {
    if (rates != null)
      rates.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Reviews"),
      ),
      body: rates != null
          ? rates.isNotEmpty
              ? ListBuilder(
                  list: rates,
                  itemBuilder: RateTile.itemBuilder(rates, reasons))
              : Center(
                  child: Text(
                  Lang.getString(context, "no_reviews_message"),
                  style: Styles.valueTextStyle(),
                  textAlign: TextAlign.center,
                ))
          : Center(child: Spinner()),
    );
  }
}
