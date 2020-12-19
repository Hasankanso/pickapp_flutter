import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/utilities/MainExpansionTile.dart';

class CarListTile extends ListTile {
  final Car car;
  CarListTile(this.car);

  static Function(BuildContext, int) itemBuilder(List<Car> c) {
    return (context, index) {
      return CarListTile(c[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, "/CarDetails", arguments: car);
          MainExpansionTileState.of(context).collapse();
        },
        leading: CachedNetworkImage(
          imageUrl: car.carPictureUrl,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: ScreenUtil().setSp(30),
              backgroundImage: imageProvider,
            );
          },
          placeholder: (context, url) => CircleAvatar(
            radius: ScreenUtil().setSp(30),
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) {
            return Image(
              image: AssetImage("lib/images/user.png"),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car.brand,
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
