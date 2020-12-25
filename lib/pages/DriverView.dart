import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DriverView extends StatelessWidget {

  final User user;

  DriverView({this.user});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropOpacity: 0.3,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      maxHeight: ScreenUtil().setHeight(520),
      minHeight: ScreenUtil().setHeight(280),
      parallaxEnabled: true,
      parallaxOffset: .5,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 300,
            child: GridTile(
              child: FittedBox(
                fit: BoxFit.fill,
                child: CachedNetworkImage(
                  imageUrl: user.person.profilePictureUrl ?? "",
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: Styles.secondaryColor(),
                    child: Spinner(),
                  ),
                  errorWidget: (context, url, error) {
                    return Image(
                      image: AssetImage("lib/images/user.png"),
                    );
                  },
                ),
              ),
            ),

          ),
          VerticalSpacer(height: 100,)
        ],
      ),
      panel: Column(children: [ Text("User") ]),
    );
  }
}
