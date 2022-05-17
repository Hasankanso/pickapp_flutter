import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/utilities/CustomToast.dart';

class MyRidesListTile extends ListTile {
  final Ride o;

  MyRidesListTile(this.o);

  static Function(BuildContext, int) itemBuilder(List<Ride> rides) {
    return (context, index) {
      return MyRidesListTile(rides[index]);
    };
  }

  void deletationResponse(bool result) {
    if (result) {
      CustomToast()
          .showShortToast("Deletion Cancelled !", backgroundColor: Colors.red);
    } else {
      CustomToast().showShortToast("Ride Deleted Successfully",
          backgroundColor: Colors.greenAccent);
    }
  }

  void cc(String item) {
    CustomToast()
        .showShortToast("You clicked : " + item, backgroundColor: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    if (o.runtimeType == Ride) {
      Ride r = o;
      return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.grey[50],
        shadowColor: Styles.primaryColor(),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          isThreeLine: true,
          leading: CircleAvatar(
            backgroundColor: Styles.primaryColor(),
            child: Icon(
              Icons.location_on_outlined,
              size: Styles.mediumIconSize(),
            ),
          ),
          title: Text(
            r.from.name + " To " + r.to.name,
            style: Styles.valueTextStyle(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Available Seats : " + r.availableSeats.toString(),
                      style: Styles.subValueTextStyle(),
                    ),
                    Text(
                      'Availabe Luggage : ' + r.availableLuggages.toString(),
                      style: Styles.subValueTextStyle(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Price :" + r.price.toString(),
                      style: Styles.subValueTextStyle(),
                    ),
                    Text(
                      "Type : Car",
                      style: Styles.subValueTextStyle(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete, color: Colors.red[500]),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            cc(r.from.name);
          },
        ),
      );
    }
  }
}
