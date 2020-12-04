import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';

class MainImagePicker extends StatefulWidget {
  @override
  _MainImagePickerState createState() => _MainImagePickerState();
}

class _MainImagePickerState extends State<MainImagePicker> {
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (App.person.profilePictureUrl == null) {
      avatar = CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: ScreenUtil().setSp(50),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Icon(
            Icons.person,
            size: ScreenUtil().setSp(100),
            color: Styles.primaryColor(),
          ),
        ),
      );
    } else {
      avatar = CachedNetworkImage(
        imageUrl: App.person.profilePictureUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: ScreenUtil().setSp(50),
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: ScreenUtil().setSp(50),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              Icons.person,
              size: ScreenUtil().setSp(100),
              color: Styles.primaryColor(),
            ),
          ),
        ),
      );
    }
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _showBottomSheet,
      child: Stack(
        children: [
          avatar,
          Positioned(
            bottom: 5,
            right: 10,
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
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _pickGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
                onTap: _pickGallery,
                child: ListTile(
                  title: Text(
                    "Gallery",
                    style: Styles.valueTextStyle(),
                  ),
                  leading: Icon(
                    Icons.image,
                    color: Styles.primaryColor(),
                    size: Styles.mediumIconSize(),
                  ),
                ),
              ),
              InkWell(
                onTap: _takePhoto,
                child: ListTile(
                  title: Text(
                    Lang.getString(context, "Camera"),
                    style: Styles.valueTextStyle(),
                  ),
                  leading: Icon(
                    Icons.camera,
                    color: Styles.primaryColor(),
                    size: Styles.mediumIconSize(),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
