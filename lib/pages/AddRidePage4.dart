import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/RideRoute.dart';
import 'package:pickapp/requests/AddRide.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/RouteTile.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AddRidePage4 extends StatefulWidget {
  final Ride rideInfo;

  const AddRidePage4({Key key, this.rideInfo}) : super(key: key);

  @override
  _AddRidePage4State createState() => _AddRidePage4State(rideInfo);
}


class _AddRidePage4State extends State<AddRidePage4> {

  final Ride rideInfo;
  final List<RideRoute> rideRoutes = new List();

  String mapUrl;
  _AddRidePage4State(this.rideInfo);

  void getDirection(String origin,String destination) async {
    String googleMapsApiKey = 'AIzaSyCjEHxPme3OLzDwsnkA8Tl5QF8_B9f70U0';
    var url = 'https://maps.googleapis.com/maps/api/directions/json?';
    var response = await http.get(url+ "origin=" + origin + "&destination=" + destination + "&mode=driving&alternatives=true" + "&key=" +googleMapsApiKey);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List<dynamic> roads = jsonResponse["routes"];
      for(int i=0;i<roads.length;i++){
        rideRoutes.add(RideRoute(roads[i]["summary"],roads[i]["overview_polyline"]["points"]));
      }
    } else {
       print('Request failed with status: ${response.statusCode}.');
    }
  }


  Future<String> getMap(String roadPoints) async {
    String googleMapsApiKey = 'AIzaSyCjEHxPme3OLzDwsnkA8Tl5QF8_B9f70U0';
    var staticMapURL = "https://maps.googleapis.com/maps/api/staticmap?";
    var response = await http.get(staticMapURL + "size=640x640" + "&path=enc%3A" + roadPoints +"&key=" + googleMapsApiKey);
    if (response.statusCode == 200) {
      mapUrl=staticMapURL + "size=640x640&path=enc%3A" +roadPoints+"&key=" + googleMapsApiKey;
      return mapUrl;
    } else {
      print("Error");
      return null;
    }
  }

  response(Ride result, int code, String message) {
    print(result);
  }
@override
  Future<void> initState() async {
    super.initState();
    await getDirection(rideInfo.from.placeId.toString(),rideInfo.to.placeId.toString());
    if(rideRoutes.length>0){
      getMap(rideRoutes[0].points);
    }

}


  @override
  Widget build(BuildContext context) {

    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 40,
              child: ResponsiveRow(
                children: [
                  Text(
                    Lang.getString(
                            context, "Choose_A_Route_From_The_List_Below") +
                        " :",
                    style: Styles.labelTextStyle(),
                  )
                ],
              ),
            ),
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 220,
              child: Container(
                color: Colors.grey[100],
                child: ListBuilder(
                    list: rideRoutes,
                    itemBuilder: RouteTile.itemBuilder(rideRoutes)),
              ),
            ),
            ResponsiveWidget(
              width: 250,
              height: 250,
              child: Image(
                image: NetworkImage(mapUrl),
              ),
            ),
            VerticalSpacer(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveWidget(
        width: 270,
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "DONE",
                onPressed: () {
                  String routeId = "";
                  rideInfo.setMap(null) ;
                  Request<Ride> request=AddRide(rideInfo);
                  request.send(response);
                  Navigator.of(context).pushNamed("/");
                  CustomToast().showShortToast(
                      Lang.getString(context, "Ride_Added"),
                      backgroundColor : Colors.greenAccent);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
