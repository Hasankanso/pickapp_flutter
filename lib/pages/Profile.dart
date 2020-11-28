import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  int _userRate = 3;
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      backgroundColor: Colors.grey.shade200,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(266),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(266),
                    width: double.infinity,
                    color: Styles.secondaryColor(),
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
                      child: Container(
                        height: ScreenUtil().setHeight(254),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Styles.secondaryColor()),
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
                                    child: Container(
                                      height: ScreenUtil().setHeight(120),
                                      width: ScreenUtil().setHeight(120),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'lib/images/adel.png'),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: ScreenUtil().setHeight(127),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.edit,
                                          color: Styles.primaryColor(),
                                          size: Styles.mediumIconSize(),
                                        )),
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
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Info"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Regions"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("My cars"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWorks(String imgPath) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Container(
        height: 100.0,
        width: 125.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            image:
                DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover)),
      ),
    );
  }

  Widget menuCard(String title, String imgPath, String type, int rating,
      double views, double likes) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(7.0),
        elevation: 4.0,
        child: Container(
          height: 125.0,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0), color: Colors.white),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10.0),
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imgPath), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(7.0)),
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    type,
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 7.0),
                  Row(
                    children: <Widget>[
                      getStar(rating, 1),
                      getStar(rating, 2),
                      getStar(rating, 3),
                      getStar(rating, 4),
                      getStar(rating, 5)
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.remove_red_eye,
                          color: Colors.grey.withOpacity(0.4)),
                      SizedBox(width: 3.0),
                      Text(views.toString()),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      SizedBox(width: 3.0),
                      Text(likes.toString())
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getStar(rating, index) {
    if (rating >= index) {
      return Icon(
        Icons.star,
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
}
