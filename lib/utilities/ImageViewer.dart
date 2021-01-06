import 'dart:io';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _image != null
                ? Image(image: AssetImage(_image.path))
                : imageProvider != null
                    ? Image(image: imageProvider)
                    : Image(
                        image: AssetImage(!isCarPicker
                            ? "lib/images/user.png"
                            : "lib/images/car.png")),
          ),
        ],
      ),
    );
  }
}
