import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class ImageViewer extends StatelessWidget {
  File _image;
  String _title;
  ImageProvider imageProvider;
  bool isCarPicker;

  ImageViewer(this._image, this._title,
      {this.imageProvider, this.isCarPicker = false});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: _title,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _image != null
                ? AssetImage(_image.path)
                : imageProvider != null
                    ? imageProvider
                    : AssetImage(!isCarPicker
                        ? "lib/images/user.png"
                        : "lib/images/car.png"),
            onError: (s, ss) {
              return Image(image: AssetImage("lib/images/car.png"));
            },
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: _image != null
                    ? Image(image: AssetImage(_image.path))
                    : imageProvider != null
                        ? Image(image: imageProvider)
                        : Image(
                            image: AssetImage(!isCarPicker
                                ? "lib/images/user.png"
                                : "lib/images/car.png")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
