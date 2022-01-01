import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/pages/PersonView.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class PassengerTile extends ListTile {
  final Reservation passenger;

  PassengerTile(this.passenger);

  List<String> _chattinessItems;

  static Function(BuildContext, int) itemBuilder(List<Reservation> p) {
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
        side: passenger.status == "CANCELED"
            ? (!Cache.darkTheme &&
                    MediaQuery.of(context).platformBrightness !=
                        Brightness.dark)
                ? BorderSide(color: Colors.red.shade200, width: 2)
                : BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          if (passenger.status != "CANCELED") {
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
          }
        },
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 28,
          backgroundImage: passenger.person.networkImage,
        ),
        title: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (passenger.status == "CANCELED")
                          Expanded(
                            flex: 30,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                Lang.getString(context, "Canceled"),
                                style: Styles.valueTextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.airline_seat_recline_extra_rounded,
                            color: Styles.primaryColor(),
                            size: Styles.mediumIconSize(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            passenger.seats.toString(),
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                        Expanded(
                          child: Icon(
                            Icons.home_repair_service,
                            color: Styles.primaryColor(),
                            size: Styles.mediumIconSize(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            passenger.luggage.toString(),
                            style: Styles.valueTextStyle(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  )
                ],
              ),
              VerticalSpacer(
                height: 8,
              ),
              if (passenger.status == "CANCELED" && passenger.reason != null)
                Row(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 80,
                      child: Text(
                        Lang.getString(context, "Cancellation_reason:"),
                        style:
                            Styles.labelTextStyle().copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              if (passenger.status == "CANCELED" && passenger.reason != null)
                Row(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 80,
                      child: Text(
                        passenger.reason,
                        style: Styles.valueTextStyle(),
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
