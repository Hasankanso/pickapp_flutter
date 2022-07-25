import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/packages/FlushBar/flushbar.dart';
import 'package:just_miles/pages/CarView.dart';
import 'package:just_miles/repository/user/user_repository.dart';
import 'package:just_miles/requests/DeleteCar.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainExpansionTile.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/PopUp.dart';
import 'package:just_miles/utilities/Spinner.dart';

class CarListTile extends ListTile {
  final Car car;
  CarListTile(this.car);
  int i = 0;

  static Function(BuildContext, int) itemBuilder(List<Car> c) {
    return (context, index) {
      return CarListTile(c[index]);
    };
  }

  _deleteCarRequest(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Spinner(),
          ),
        );
      },
    );
    for (var item in App.person.upcomingRides) {
      if (item.car != null && item.car.id == car.id) {
        Navigator.pop(context);
        return CustomToast()
            .showErrorToast(Lang.getString(context, "Delete_car_message"));
      }
    }

    Request<Car> request = DeleteCar(car);
    request.send((c, co, m) => _deleteCarResponse(c, co, m, context));
  }

  _deleteCarResponse(Car p1, int code, String message, context) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user.driver.cars.remove(p1);

      if (App.user.driver.cars == null || App.user.driver.cars.length == 0) {
        App.isDriverNotifier.value = false;
        App.user.driver = null;
      }

      await UserRepository().updateUser(App.user);

      App.updateProfile.value = !App.updateProfile.value;

      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_deleted!"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        onTap: () {
          MainExpansionTileState.of(context).collapse();
          Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: "/CarView"),
                builder: (context) => MainScaffold(
                      appBar: MainAppBar(
                        title: Lang.getString(context, "Car_Details"),
                        actions: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(context, "/CarDetails",
                                    arguments: car);
                              }),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: Styles.largeIconSize(),
                            ),
                            tooltip: Lang.getString(context, "Delete"),
                            onPressed: () {
                              if (i == 0) if (App.driver.cars.length == 1) {
                                i++;
                                Flushbar(
                                  message: Lang.getString(
                                      context, "No_driver_anymore"),
                                  flushbarPosition: FlushbarPosition.TOP,
                                  flushbarStyle: FlushbarStyle.GROUNDED,
                                  reverseAnimationCurve: Curves.decelerate,
                                  forwardAnimationCurve: Curves.decelerate,
                                  icon: Icon(
                                    Icons.warning_amber_outlined,
                                    color: Colors.red,
                                    size: Styles.mediumIconSize(),
                                  ),
                                  mainButton: IconButton(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Styles.secondaryColor(),
                                      size: Styles.mediumIconSize(),
                                    ),
                                  ),
                                )..show(context);
                                return;
                              }
                              PopUp.areYouSure(
                                      Lang.getString(context, "Yes"),
                                      Lang.getString(context, "No"),
                                      Lang.getString(
                                          context, "Car_delete_message"),
                                      Lang.getString(context, "Warning!"),
                                      Colors.red,
                                      (bool) => bool
                                          ? _deleteCarRequest(context)
                                          : null,
                                      highlightYes: true)
                                  .confirmationPopup(context);
                            },
                          ),
                        ],
                      ),
                      body: CarView(
                        car: car,
                      ),
                    )),
          );
        },
        leading: CachedNetworkImage(
          imageUrl: car.carPictureUrl,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: ScreenUtil().setSp(30),
              backgroundImage: imageProvider,
            );
          },
          placeholder: (context, url) => CircleAvatar(
            radius: ScreenUtil().setSp(30),
            backgroundColor: Colors.transparent,
            child: Spinner(),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: ScreenUtil().setSp(30),
            backgroundColor: Colors.transparent,
            child: Image(
              image: AssetImage("lib/images/car.png"),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Lang.getString(context, car.brand),
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
                    car.name,
                    style: Styles.headerTextStyle(),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              Lang.getString(context, "Seats") + ": ",
                              style: Styles.labelTextStyle(),
                            ),
                            Text(
                              car.maxSeats.toString(),
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
                              Lang.getString(context, "Luggage") + ": ",
                              style: Styles.labelTextStyle(),
                            ),
                            Text(
                              car.maxLuggage.toString(),
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
}
