import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/pages/PersonView.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class PassengerTile extends ListTile {
  final Passenger passenger;

  PassengerTile(this.passenger);

  List<String> _chattinessItems;

  static Function(BuildContext, int) itemBuilder(List<Passenger> p) {
    return (context, index) {
      return PassengerTile(p[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    _chattinessItems = App.getChattiness(context);

    if (passenger.person.networkImage == null) {
      passenger.person.setNetworkImage();
    }
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: "/UserView"),
                  builder: (context) => MainScaffold(
                        appBar: MainAppBar(
                          title: Lang.getString(context, "Passenger"),
                        ),
                        body: PersonView(
                          person: passenger.person,
                        ),
                      )));
        },
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 28,
          backgroundImage: passenger.person.networkImage,
        ),
        title: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    flex: 80,
                    child: Text(
                      passenger.person.firstName +
                          " " +
                          passenger.person.lastName +
                          ", " +
                          App.calculateAge(passenger.person.birthday)
                              .toString(),
                      style: Styles.headerTextStyle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 80,
                    child: Text(
                      _chattinessItems[passenger.person.chattiness],
                      style: Styles.valueTextStyle(),
                    ),
                  ),
                ],
              ),
              VerticalSpacer(
                height: 8,
              ),
              Row(
                children: [
                  RateStars(
                    passenger.person.statistics.rateAverage,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Expanded(
                    flex: 9,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        DateFormat(App.birthdayFormat,
                                Localizations.localeOf(context).toString())
                            .format(passenger.person.creationDate),
                        style: Styles.labelTextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
