import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/ImageViewer.dart';

import 'Responsive.dart';

class MainImagePicker extends StatefulWidget {
  final VoidCallback callBack;
  MainImageController controller;
  bool isCarPicker;
  String imageUrl;

  MainImagePicker(
      {this.callBack,
      this.controller,
      this.imageUrl,
      this.isCarPicker = false});
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
          widget.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: ScreenUtil().setSp(45),
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor:
                        Cache.darkTheme ? Colors.black12 : Colors.grey[50],
                    child: CircularProgressIndicator(
                      backgroundColor: Styles.primaryColor(),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return CircleAvatar(
                      backgroundColor:
                          Cache.darkTheme ? Colors.black12 : Colors.grey[50],
                      radius: ScreenUtil().setSp(45),
                      backgroundImage: AssetImage(!widget.isCarPicker
                          ? "lib/images/user.png"
                          : "lib/images/car.png"),
                    );
                  },
                )
              : CircleAvatar(
                  backgroundColor:
                      Cache.darkTheme ? Colors.black12 : Colors.grey[50],
                  radius: ScreenUtil().setSp(45),
                  backgroundImage: _image != null
                      ? AssetImage(_image.path)
                      : AssetImage(!widget.isCarPicker
                          ? "lib/images/user.png"
                          : "lib/images/car.png"),
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
                          Lang.getString(context, "View"),
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
                          Lang.getString(context, "Gallery"),
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
