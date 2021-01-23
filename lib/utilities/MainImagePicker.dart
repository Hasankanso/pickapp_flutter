import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/ImageViewer.dart';
import 'package:pickapp/utilities/Spinner.dart';

import 'Responsive.dart';

class MainImagePicker extends StatefulWidget {
  final VoidCallback callBack;
  MainImageController controller;
  bool isCarPicker;
  bool isLoading;
  String imageUrl;

  MainImagePicker(
      {this.callBack,
      this.controller,
      this.imageUrl,
      this.isLoading = false,
      this.isCarPicker = false});
  @override
  _MainImagePickerState createState() => _MainImagePickerState();
}

class _MainImagePickerState extends State<MainImagePicker> {
  File _image;
  final picker = ImagePicker();
  ImageProvider _downloadedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.controller.pickedImage != null)
      _image = widget.controller.pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _showBottomSheet,
      child: Stack(
        children: [
          !widget.isLoading
              ? widget.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      imageBuilder: (context, imageProvider) {
                        _downloadedImage = imageProvider;
                        return CircleAvatar(
                          radius: ScreenUtil().setSp(45),
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: ScreenUtil().setSp(45),
                        child: Spinner(),
                      ),
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: ScreenUtil().setSp(45),
                          backgroundImage: AssetImage(!widget.isCarPicker
                              ? "lib/images/user.png"
                              : "lib/images/car.png"),
                        );
                      },
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: ScreenUtil().setSp(45),
                      backgroundImage: _image != null
                          ? AssetImage(_image.path)
                          : AssetImage(!widget.isCarPicker
                              ? "lib/images/user.png"
                              : "lib/images/car.png"),
                    )
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: ScreenUtil().setSp(45),
                  child: Spinner(),
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
    var pickedFile;
    try {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    } catch (PlatformException) {
      openAppSettings();
      return;
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.controller.pickedImage = File(pickedFile.path);
        if (widget.callBack != null) widget.callBack();
      }
    });
  }

  _pickGallery() async {
    var pickedFile;
    try {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    } catch (PlatformException) {
      openAppSettings();
      return;
    }
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
                imageProvider: _downloadedImage,
                isCarPicker: widget.isCarPicker,
              ),
          fullscreenDialog: true),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 10,
              ),
              Container(
                width: 35,
                height: 5,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: new BorderRadius.all(Radius.circular(10))),
              ),
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
