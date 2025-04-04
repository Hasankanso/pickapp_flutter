import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/UserStatistics.dart';
import 'package:just_miles/items/RateTile.dart';
import 'package:just_miles/requests/GetUserReviews.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';

class ReviewsListPage extends StatefulWidget {
  final Person person;

  ReviewsListPage(this.person);

  @override
  _ReviewsListPageState createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {
  List<Rate> rates = [];
  List<String> reasons;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      if (widget.person.rates == null) {
        Request<List<Rate>> getRated = GetUserReviews(person: widget.person);
        getRated.send(response);
      } else {
        this.rates = widget.person.rates;
      }
    } else {
      _getRates();
    }
  }

  response(List<Rate> rates, int code, String reason) {
    if (App.handleErrors(context, code, reason)) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      widget.person.rates = rates;
      _filterRates(rates);
    });
  }

  _getRates() async {
    var rates = await Cache.getRates();
    setState(() {
      _filterRates(rates);
    });
  }

  _filterRates(List<Rate> rates) {
    this.rates = [];
    for (int i = rates.length - 1; i >= 0; i--) {
      DateTime before2Days = DateTime.now().add(-App.availableDurationToRate);

      if (rates[i].creationDate.isBefore(before2Days)) this.rates.add(rates[i]);
    }
    App.user.person.rates = this.rates;
  }

  @override
  void didChangeDependencies() {
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
      body: ListBuilder(
        list: rates,
        onPullRefresh: widget.person == null
            ? () async {
                await _getRatesRequest();
              }
            : null,
        itemBuilder: RateTile.itemBuilder(rates, reasons),
        nativeAdHeight: 140,
        nativeAdElevation: 3,
      ),
    );
  }

  getRatesResponse(List<Rate> rates, int status, String message) async {
    if (status != 200) {
    } else {
      UserStatistics userStatistics = UserStatistics(0, 0, 0, 0, 0, 0, 0, 0, 0);
      for (final rate in rates) {
        userStatistics = userStatistics.createNewStatistics(rate);
      }
      App.person.statistics = userStatistics;
      await Cache.setUser(App.user);
      await Cache.setRates(rates);

      setState(() {
        _filterRates(rates);
      });
    }
  }

  Future<void> _getRatesRequest() async {
    Request<List<Rate>> getRates = GetUserReviews();
    await getRates.send(getRatesResponse);
  }
}
