import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/items/RateTile.dart';
import 'package:pickapp/requests/GetDriverReviews.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class ReviewsListPage extends StatefulWidget {
  final Person person;

  ReviewsListPage(this.person);

  @override
  _ReviewsListPageState createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {

  @override
  void initState() {
    super.initState();
    if (widget.person.rates == null) {
      GetDriverReviews getRated = GetDriverReviews(widget.person);
      getRated.send(response);
    }
  }

  response(List<Rate> rates, int status, String reason) {
    if (status == 200) {
      setState(() {
        widget.person.rates = rates;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> reasons = App.getRateReasons(context);
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Reviews"),
        ),
        body: widget.person.rates != null
            ? widget.person.rates.isNotEmpty ? ListBuilder(
            list: widget.person.rates,
            itemBuilder: RateTile.itemBuilder(widget.person.rates, reasons)) :  Center(child : Text(Lang.getString(context, "no_reviews_message"),style : Styles.valueTextStyle(), textAlign: TextAlign.center,)):Center(child : Spinner()),
    );
  }
}
