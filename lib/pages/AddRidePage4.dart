import 'dart:convert';
import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/RideRoute.dart';
import 'package:pickapp/items/RouteTile.dart';
import 'package:pickapp/requests/AddRide.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class AddRidePage4 extends StatefulWidget {
  final Ride rideInfo;

  const AddRidePage4({Key key, this.rideInfo}) : super(key: key);

  @override
  _AddRidePage4State createState() => _AddRidePage4State(rideInfo);
}

class _AddRidePage4State extends State<AddRidePage4> {
  final Ride rideInfo;
  bool mapReady = false;
  final List<RideRoute> rideRoutes = new List();
  String mapUrl;
  String base64Map;
  ListController listController = new ListController();

  _AddRidePage4State(this.rideInfo);

  void getDirection(String origin, String destination) async {
    var url = 'https://maps.googleapis.com/maps/api/directions/json?';
    var response = await http.get(url +
        "origin=" +
        origin +
        "&destination=" +
        destination +
        "&mode=driving&alternatives=true" +
        "&key=" +
        App.googleKey);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List<dynamic> roads = jsonResponse["routes"];
      for (int i = 0; i < roads.length; i++) {
        rideRoutes.add(RideRoute(
            roads[i]["summary"], roads[i]["overview_polyline"]["points"]));
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void getMap(String roadPoints) async {
    var staticMapURL = "https://maps.googleapis.com/maps/api/staticmap?";
    var response = await http.get(staticMapURL +
        "size=640x640" +
        "&path=enc%3A" +
        roadPoints +
        "&key=" +
        App.googleKey);
    if (response.statusCode == 200) {
      var base64String = base64.encode(response.bodyBytes);
      //print("The base64 is :"+base64String);
      mapUrl = staticMapURL +
          "size=640x640&path=enc%3A" +
          roadPoints +
          "&key=" +
          App.googleKey;
      base64Map = base64String;
      setState(() {});
    } else {
      print("Error");
      return null;
    }
  }

  response(Ride result, int code, String message) {
    print(result);
  }

  @override
  void initState() {
    super.initState();
    getMapAndDirection();
  }

  void getMapAndDirection() async {
    await getDirection(
        rideInfo.from.latitude.toString() +
            "," +
            rideInfo.from.longitude.toString(),
        rideInfo.to.latitude.toString() +
            "," +
            rideInfo.to.longitude.toString());
    if (rideRoutes.length > 0) {
      mapReady = true;
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
        child: mapReady == true
            ? Column(
                children: [
                  VerticalSpacer(
                    height: 20,
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 250,
                    child: mapUrl == null
                        ? null
                        : CachedNetworkImage(
                            imageUrl: mapUrl,
                            imageBuilder: (context, imageProvider) {
                              return Image(image: imageProvider);
                            },
                            placeholder: (context, url) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.all(5),
                                    child: Spinner(),
                                  ),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) {
                              return Image(
                                  image: AssetImage("lib/images/user.png"));
                            },
                          ),
                  ),
                  VerticalSpacer(
                    height: 20,
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 25,
                    child: Center(
                      child: Text(
                        Lang.getString(
                                context, "Choose_A_Route_From_The_List_Below") +
                            " :",
                        style: Styles.labelTextStyle(),
                      ),
                    ),
                  ),
                  VerticalSpacer(
                    height: 20,
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 220,
                    child: Container(
                      child: ListBuilder(
                        list: rideRoutes,
                        itemBuilder: RouteTile.itemBuilder(
                            rideRoutes, getMap, listController),
                      ),
                    ),
                  ),
                  VerticalSpacer(
                    height: 20,
                  ),
                ],
              )
            : Column(
                children: [
                  VerticalSpacer(
                    height: 250,
                  ),
                  Center(
                      child: ResponsiveWidget(
                    width: 60,
                    height: 60,
                    child: Spinner(),
                  )),
                  VerticalSpacer(height: 25),
                  Text(
                    Lang.getString(context, "Loading_Map"),
                    style: Styles.labelTextStyle(),
                  )
                ],
              ),
      ),
      bottomNavigationBar: Visibility(
        visible: mapReady,
        child: ResponsiveWidget(
          width: 270,
          height: 100,
          child: Column(
            children: [
              ResponsiveWidget(
                width: 270,
                height: 50,
                child: MainButton(
                  isRequest: true,
                  text_key: "Next",
                  onPressed: () {
                    rideInfo.mapBase64 = base64Map;
                    Navigator.of(context)
                        .pushNamed("/AddRidePage5", arguments: rideInfo);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
