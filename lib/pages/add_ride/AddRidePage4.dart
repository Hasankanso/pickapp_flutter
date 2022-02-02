import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_miles/ads/Ads.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/RideRoute.dart';
import 'package:just_miles/items/RouteTile.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Spinner.dart';
import 'package:photo_view/photo_view.dart';

class AddRidePage4 extends StatefulWidget {
  final Ride rideInfo;
  final String appBarTitleKey;

  const AddRidePage4({Key key, this.rideInfo, this.appBarTitleKey})
      : super(key: key);

  @override
  _AddRidePage4State createState() => _AddRidePage4State(rideInfo);
}

class _AddRidePage4State extends State<AddRidePage4> {
  final Ride rideInfo;
  bool mapReady = false;
  final List<RideRoute> rideRoutes = [];
  String mapUrl;
  Uint8List imageBytes;
  ListController listController = new ListController();
  ScrollController controller = new ScrollController();

  _AddRidePage4State(this.rideInfo);

  Future<void> getDirection(String origin, String destination) async {
    var url = 'https://maps.googleapis.com/maps/api/directions/json?';
    var response = await http.get(Uri.parse(url +
        "origin=" +
        origin +
        "&destination=" +
        destination +
        "&mode=driving&alternatives=true" +
        "&key=" +
        App.googleKey));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List<dynamic> roads = jsonResponse["routes"];
      for (int i = 0; i < roads.length; i++) {
        rideRoutes.add(RideRoute(
            roads[i]["summary"], roads[i]["overview_polyline"]["points"]));
      }
    } else {}
  }

  void getMap(String roadPoints) async {
    var staticMapURL = "https://maps.googleapis.com/maps/api/staticmap?";
    var response = await http.get(Uri.parse(staticMapURL +
        "size=640x640" +
        "&path=enc%3A" +
        roadPoints +
        "&key=" +
        App.googleKey));
    if (response.statusCode == 200) {
      mapUrl = staticMapURL +
          "size=640x640&path=enc%3A" +
          roadPoints +
          "&key=" +
          App.googleKey;
      imageBytes = response.bodyBytes;
      if (mounted) {
        setState(() {});
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
    getMapAndDirection();
    listController.selected = 0;
  }

  _loadAd() async {
    await Ads.loadRewardedAd();
  }

  Future<void> getMapAndDirection() async {
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

  _viewImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MainScaffold(
                appBar: MainAppBar(
                  title: "Map",
                ),
                body: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  child: PhotoView(
                    imageProvider: Image.memory(imageBytes).image,
                    maxScale: 1.8,
                    backgroundDecoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    minScale: PhotoViewComputedScale.contained,
                  ),
                ),
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, widget.appBarTitleKey),
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
                        : InkWell(
                            onTap: () {
                              if (imageBytes != null && imageBytes.isNotEmpty) {
                                _viewImage();
                              }
                            },
                            child: imageBytes != null
                                ? Image.memory(imageBytes)
                                : Image(
                                    image: AssetImage("lib/images/map.png"))),
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
                    height: 40,
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
                    child: Center(child: Spinner()),
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
        child: ResponsiveWidget.fullWidth(
          height: 80,
          child: Column(
            children: [
              ResponsiveWidget(
                width: 270,
                height: 50,
                child: MainButton(
                  isRequest: true,
                  textKey: "Next",
                  onPressed: () {
                    rideInfo.imageBytes = imageBytes;
                    Navigator.of(context).pushNamed("/AddRidePage5",
                        arguments: [rideInfo, widget.appBarTitleKey]);
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
