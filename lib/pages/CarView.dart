import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CarView extends StatelessWidget {
  Car car;
  List<String> _typeItems;

  CarView({this.car});

  @override
  Widget build(BuildContext context) {
    _typeItems = <String>[
      Lang.getString(context, "Sedan"),
      Lang.getString(context, "SUV"),
      Lang.getString(context, "Hatchback"),
      Lang.getString(context, "Van")
    ];
    return MainScaffold(
      appBar: MainAppBar(
        title: "Car detassils",
      ),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 300,
            child: GridTile(
              child: FittedBox(
                fit: BoxFit.fill,
                child: CachedNetworkImage(
                  imageUrl: car.carPictureUrl,
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: Styles.secondaryColor(),
                    child: CircularProgressIndicator(
                      backgroundColor: Styles.primaryColor(),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Image(
                      image: AssetImage("lib/images/car.png"),
                    );
                  },
                ),
              ),
              footer: Container(
                height: ScreenUtil().setHeight(40),
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: Text(
                  car.brand + " " + car.name,
                  style: Styles.titleTextStyle(),
                ),
              ),
            ),
          ),
          VerticalSpacer(
            height: 20,
          ),
          ResponsiveWidget.fullWidth(
            height: 40,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Year:",
                            style: Styles.labelTextStyle(),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            car.year.toString(),
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 40,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Type:",
                            style: Styles.labelTextStyle(),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _typeItems[car.type],
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 40,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Seats:",
                            style: Styles.labelTextStyle(),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            car.maxSeats.toString(),
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 40,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Luggage:",
                            style: Styles.labelTextStyle(),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            car.maxLuggage.toString(),
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 40,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Color:",
                            style: Styles.labelTextStyle(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(car.color),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 17,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(children: [
          ResponsiveRow(
            children: [
              ResponsiveWidget(
                width: 170,
                height: 50,
                child: MainButton(
                  text_key: "Search",
                  isRequest: true,
                  onPressed: () async {},
                ),
              ),
              ResponsiveWidget(
                width: 170,
                height: 50,
                child: MainButton(
                  text_key: "Edit",
                  isRequest: true,
                  onPressed: () async {},
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
