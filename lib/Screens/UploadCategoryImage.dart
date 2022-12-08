import 'dart:convert';
import 'dart:io';

import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadCategoryImage extends StatefulWidget {
  @override
  _UploadCategoryImageState createState() => _UploadCategoryImageState();
}

class _UploadCategoryImageState extends State<UploadCategoryImage> {

  bool _checkLoaded = true;
  File _image;
  String base64Image = "";
  File image;
  File cropped;
  List<File> _images = [] ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child:   RaisedButton(
            elevation: 0.2,
            onPressed: () {
              openGalleryPicker();
            },
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/Images/my_post.png',
                        height: 20,
                        width: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                      ),
                      Text('My Post',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    ],
                  ),
                  Image.asset(
                    'assets/Images/arrow.png',
                    height: 12,
                    width: 12,
                  ),

                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Future openGalleryPicker() async {


    final picker = ImagePicker();
    await picker.getImage(source: ImageSource.gallery).then((image) async {

      if (image != null) {
        File cropped = await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
                toolbarColor: Colors.blueGrey,
                toolbarTitle: "Crop Image",
                statusBarColor: Colors.blueGrey.shade900,
                backgroundColor: Colors.white,
                hideBottomControls: true
            ));

        this.setState(() {
          _image = cropped;
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          String base64ImageTemp = base64Encode(imageBytes);
          base64Image = base64ImageTemp;



          //  print("base 64 ================"+_images.length.toString());
          _checkLoaded = false;
          _checkLoaded;
          base64Image;
          _image;
        });

      } else {}


      _images.add(_image);
      print("IMAGES LIST : "+_images.length.toString());

      var _result = await CloudStorageService.instance.uploadImage(_image);
      String _imageURL = await _result.ref.getDownloadURL();
      print(_imageURL);
    //  _imagesUrl.add(_imageURL);


      setState(() {});

    });
  }


}
