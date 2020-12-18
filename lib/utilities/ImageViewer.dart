import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class ImageViewer extends StatelessWidget {
  File _image;
  String title;

  ImageViewer(this._image, this.title);
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: title,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _image != null
                ? Image(image: AssetImage(_image.path))
                : Image(image: AssetImage("lib/images/user.png")),
          ),
        ],
      ),
    );
  }
}
