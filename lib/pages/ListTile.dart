import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Ride.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/pages/CustomToast.dart';
import 'package:pickapp/pages/PopUp.dart';

class listTile extends ListTile {
  final Object o;

  listTile(this.o);

  void a() {
    CustomToast().showColoredToast("Deletion Cancelled !", Colors.red);
  }

  void b() {
    CustomToast()
        .showColoredToast("Ride Deleted Successfully", Colors.greenAccent);
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          isThreeLine: true,
          leading: CircleAvatar(
            child: Icon(Icons.location_on_outlined),
          ),
          title: Text(r.from+" To "+r.to),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Available Seats : "+r.availableSeats.toString()),
                    Text('Availabe Luggage : '+ r.availableLuggage.toString()),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Price :"+r.price),
                    Text("Type : Car"),
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
                      onPressed: () {
                        PopUp.name(
                                "Cancel",
                                "Delete",
                                "Warning !",
                                "Are you sure you want to delete this car",
                                a,
                                b,
                                Colors.red,
                                Colors.grey,
                                Colors.blue)
                            .confirmationPopup(context);
                      },
                      icon: Icon(Icons.delete),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
}
