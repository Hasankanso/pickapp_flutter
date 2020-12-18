import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/ImageViewer.dart';

import 'Responsive.dart';

class MainImagePicker extends StatefulWidget {
  final VoidCallback callBack;
  MainImageController controller;
  String imageUrl;

  MainImagePicker({this.callBack, this.controller, this.imageUrl});
  @override
  _MainImagePickerState createState() => _MainImagePickerState();
}

class _MainImagePickerState extends State<MainImagePicker> {
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _showBottomSheet,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(400),
            child: widget.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    imageBuilder: (context, imageProvider) =>
                        Image(image: imageProvider),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      return Image(image: AssetImage("lib/images/user.png"));
                    },
                  )
                : _image != null
                    ? Image(image: AssetImage(_image.path))
                    : Image(image: AssetImage("lib/images/user.png")),
          ),
          Positioned(
            bottom: 5,
            right: 10,
            child: Icon(
              Icons.camera_alt_rounded,
              color: Styles.labelColor(),
              size: Styles.mediumIconSize(),
            ),
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.controller.pickedImage = File(pickedFile.path);
        if (widget.callBack != null) widget.callBack();
      }
    });
  }

  _pickGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.controller.pickedImage = File(pickedFile.path);
        if (widget.callBack != null) widget.callBack();
      }
    });
  }

  _viewImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewer(
          _image,
          Lang.getString(context, "Profile"),
        ),
      ),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: _viewImage,
                child: ResponsiveWidget.fullWidth(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.person_pin_outlined,
                          color: Styles.primaryColor(),
                          size: Styles.mediumIconSize(),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          "View",
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: _pickGallery,
                child: ResponsiveWidget.fullWidth(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.image,
                          color: Styles.primaryColor(),
                          size: Styles.mediumIconSize(),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          "Gallery",
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: _takePhoto,
                child: ResponsiveWidget.fullWidth(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.camera,
                          color: Styles.primaryColor(),
                          size: Styles.mediumIconSize(),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          Lang.getString(context, "Camera"),
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MainImageController {
  File pickedImage;
}
