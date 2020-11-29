import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainExpansionTile.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double _userRate = 3.5;

  int hhhh = 70;
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Profile"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Styles.secondaryColor(),
              size: Styles.largeIconSize(),
            ),
            tooltip: Lang.getString(context, "Settings"),
            onPressed: () {
              Navigator.of(context).pushNamed("/settings");
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(266),
            child: Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(266),
                  width: double.infinity,
                ),
                Container(
                  height: ScreenUtil().setHeight(190),
                  width: double.infinity,
                  color: Styles.primaryColor(),
                ),
                Positioned(
                  left: 15.0,
                  right: 15.0,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Material(
                      color: Styles.secondaryColor(),
                      borderRadius: BorderRadius.circular(7.0),
                      child: Container(
                        height: ScreenUtil().setHeight(254),
                        child: Column(
                          children: <Widget>[
                            VerticalSpacer(height: 10),
                            DifferentSizeResponsiveRow(
                              children: [
                                Expanded(flex: 1, child: SizedBox()),
                                Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      radius: ScreenUtil().setSp(40),
                                      backgroundImage:
                                          AssetImage('lib/images/adel.png'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: ScreenUtil().setHeight(127),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          color: Styles.primaryColor(),
                                          size: Styles.mediumIconSize(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Adel Kanso',
                                  style: Styles.valueTextStyle(
                                      bold: FontWeight.bold),
                                ),
                                Text(
                                  'Lebanon',
                                  style: Styles.labelTextStyle(
                                      bold: FontWeight.bold),
                                ),
                                VerticalSpacer(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    getStar(_userRate, 1),
                                    getStar(_userRate, 2),
                                    getStar(_userRate, 3),
                                    getStar(_userRate, 4),
                                    getStar(_userRate, 5)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/publicInformation");
                      },
                      child: ResponsiveWidget.fullWidth(
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.public,
                                size: Styles.mediumIconSize(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                "Public information",
                                style: Styles.valueTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildDivider(),
                    InkWell(
                      onTap: () {},
                      child: ResponsiveWidget.fullWidth(
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.location_on_outlined,
                                size: Styles.mediumIconSize(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                "Regions",
                                style: Styles.valueTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildDivider(),
                    InkWell(
                      onTap: () {},
                      child: ResponsiveWidget.fullWidth(
                        height: hhhh,
                        child: MainExpansionTile(
                          callBack: settt,
                          leading: Icon(
                            Icons.local_taxi_outlined,
                            size: Styles.mediumIconSize(),
                          ),
                          title: Text(
                            "My cars",
                            style: Styles.valueTextStyle(),
                          ),
                          children: <Widget>[
                            carTile("BMW", "E90", "lib/images/adel.png", 4, 5),
                            carTile("BMW", "E90", "lib/images/adel.png", 4, 5),
                            carTile("BMW", "E90", "lib/images/adel.png", 4, 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  Widget carTile(
      String brand, String name, String imgPath, int seats, int luggage) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          radius: ScreenUtil().setSp(30),
          backgroundImage: AssetImage(imgPath),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brand,
              style: Styles.headerTextStyle(),
            ),
          ],
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: Styles.headerTextStyle(),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              "Seats: ",
                              style: Styles.labelTextStyle(),
                            ),
                            Text(
                              seats.toString(),
                              style:
                                  Styles.valueTextStyle(bold: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              "Luggage: ",
                              style: Styles.labelTextStyle(),
                            ),
                            Text(
                              luggage.toString(),
                              style:
                                  Styles.valueTextStyle(bold: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getStar(double rating, index) {
    if (rating >= index) {
      return Icon(
        Icons.star,
        color: Colors.yellow,
        size: Styles.mediumIconSize(),
      );
    } else if (rating.toInt() == index - 1 && rating.toInt() != rating) {
      return Icon(
        Icons.star_half,
        color: Colors.yellow,
        size: Styles.mediumIconSize(),
      );
    } else {
      return Icon(
        Icons.star,
        color: Colors.grey.withOpacity(0.5),
        size: Styles.mediumIconSize(),
      );
    }
  }

  void settt() {
    if (hhhh == 70)
      hhhh = 270;
    else
      hhhh = 70;
    setState(() {});
  }
}
