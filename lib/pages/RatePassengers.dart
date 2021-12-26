import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/items/PassengerRateTile.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/requests/RatePassengersRequest.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class RatePassengers extends StatelessWidget {
  final Ride ride;
  final List<Rate> rates = [];
  final List<GlobalKey<FormState>> formKeys = [];
  final MainNotification notification;

  RatePassengers({Key key, this.ride, this.notification}) : super(key: key) {
    for (var passenger in ride.reservations) {
      bool isCanceledThenReserve = false;

      if (passenger.status == "CANCELED") {
        for (var pass in ride.reservations) {
          if (pass.person.id == passenger.person.id &&
              pass.person.id != "CANCELED") {
            isCanceledThenReserve = true;
          }
        }
      }
      if (!isCanceledThenReserve) {
        rates.add(new Rate(
            ride: ride,
            rater: App.person,
            grade: 5,
            reason: 0,
            target: passenger.person,
            creationDate: DateTime.now()));
      }
      formKeys.add(new GlobalKey<FormState>());
    }
  }

  Future<void> _response(
      bool p1, int code, String message, BuildContext context) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }
    App.notifications.remove(notification);
    await Cache.updateNotifications(App.notifications);
    App.updateNotifications.value = !App.updateNotifications.value;

    Navigator.of(context).popUntil((route) => route.isFirst);
    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_rated!"));
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Rate_Passengers"),
      ),
      body: ride.reservations.isEmpty
          ? Center(child: Text("No Passengers"))
          : ListBuilder(
              list: rates,
              itemBuilder:
                  PassengerRateTile.createPassengersItems(rates, formKeys)),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: true,
                textKey: "Rate",
                onPressed: () async {
                  for (int i = 0; i < rates.length; i++) {
                    Ride _ride = rates[i].ride;
                    var _formKey = formKeys[i];
                    if (_formKey.currentState.validate()) {
                      if (DateTime.now().isAfter(
                          _ride.leavingDate.add(App.availableDurationToRate))) {
                        return CustomToast().showErrorToast(
                            Lang.getString(context, "Rate_days_validation"));
                      }
                      //any fail above, the return line will not let the program to reach this code
                      Request<bool> request = RatePassengersRequest(rates);
                      await request.send((bool p1, int p2, String p3) =>
                          _response(p1, p2, p3, context));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
