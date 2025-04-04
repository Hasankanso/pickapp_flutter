import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/ImageViewer.dart';
import 'package:just_miles/utilities/Spinner.dart';

import 'Responsive.dart';

class MainImagePicker extends StatefulWidget {
  final Function(File imageFile) callBack;
  MainImageController controller;
  bool isCarPicker;
  bool isLoading;
  String imageUrl;
  String title;

  MainImagePicker({
    this.callBack,
    this.controller,
    this.imageUrl,
    this.isLoading = false,
    this.isCarPicker = false,
    this.title,
  });
  @override
  _MainImagePickerState createState() => _MainImagePickerState();
}

class _MainImagePickerState extends State<MainImagePicker> {
  File _image;
  final picker = ImagePicker();
  ImageProvider _downloadedImage;

  @override
  void initState() {
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
              ? (widget.imageUrl != null && widget.imageUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      imageBuilder: (context, imageProvider) {
                        _downloadedImage = imageProvider;
                        widget.controller.downloadedImage = imageProvider;
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
                          ? Image.file(File(_image.path)).image
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
            bottom: 4,
            left: !App.isLTR ? 7 : null,
            right: App.isLTR ? 7 : null,
            child: Icon(
              Icons.camera_alt_rounded,
              color: Styles.primaryColor(),
              size: Styles.mediumIconSize(),
            ),
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    Navigator.pop(context);
    var pickedFile;
    try {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          widget.controller.pickedImage = _image;
          if (widget.callBack != null) widget.callBack(_image);
        }
      });
    } catch (PlatformException) {
      if (Platform.isIOS) {
        CustomToast()
            .showErrorToast(Lang.getString(context, "no_camera_permission"));
      } else {
        AppSettings.openAppSettings();
      }
    }
  }

  _pickGallery() async {
    Navigator.pop(context);
    var pickedFile;
    try {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          widget.controller.pickedImage = _image;
          if (widget.callBack != null) widget.callBack(_image);
        }
      });
    } catch (PlatformException) {
      if (Platform.isIOS) {
        CustomToast().showErrorToast(
            Lang.getString(context, "no_image_pick_permission"));
      } else {
        AppSettings.openAppSettings();
      }
      return;
    }
  }

  _viewImage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ImageViewer(
                _image,
                widget.title,
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
  ImageProvider downloadedImage;
}
