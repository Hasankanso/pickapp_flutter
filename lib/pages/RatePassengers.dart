import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/PassengerRateTile.dart';
import 'package:pickapp/requests/AddRateRequest.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RatePassengers extends StatelessWidget {
  final Ride ride;
  final List<Rate> rates = [];
  final List<GlobalKey<FormState>> formKeys = [];

  RatePassengers({Key key, this.ride}) : super(key: key) {
    for (var passenger in ride.passengers) {
      rates.add(new Rate(
          ride: ride, rater: ride.person, target: passenger.person, creationDate: DateTime.now()));
      formKeys.add(new GlobalKey<FormState>());
    }
  }

  void _response(bool p1, int p2, String p3, BuildContext context) {
    if (p2 == 200) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      CustomToast().showSuccessToast(Lang.getString(context, "Successfully_rated!"));
    } else {
      CustomToast().showErrorToast(Lang.getString(context, "Something_Wrong") + p2.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Rate_Passengers"),
      ),
      body: ride.passengers.isEmpty
          ? Center(child: Text("No Passengers"))
          : ListBuilder(
              list: ride.passengers,
              itemBuilder: PassengerRateTile.createPassengersItems(rates, formKeys)),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: true,
                text_key: "Rate",
                onPressed: () async {
                  for (int i = 0; i < rates.length; i++) {
                    Ride _ride = rates[i].ride;
                    var _formKey = formKeys[i];

                    if (_formKey.currentState.validate()) {
                      if (DateTime.now()
                          .isAfter(_ride.leavingDate.add(App.availableDurationToRate))) {
                        return CustomToast()
                            .showErrorToast(Lang.getString(context, "Rate_days_validation"));
                      }
                    }
                  }
                  //any fail above, the return line will not let the code below get executed
                  Request<bool> request = AddRateRequest(rates);
                  await request
                      .send((bool p1, int p2, String p3) => _response(p1, p2, p3, context));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
