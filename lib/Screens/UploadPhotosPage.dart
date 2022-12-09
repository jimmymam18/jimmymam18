import 'dart:convert';
import 'dart:io';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/AddPostPage.dart';

import 'package:bizitme/Screens/LinkStripeAccount.dart';
import 'package:bizitme/Screens/MyPostPage.dart';
import 'package:bizitme/Screens/UploadPhotosNext.dart';
import 'package:bizitme/Screens/personalinfoPage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'global.dart';

class UploadPhotosPage extends StatefulWidget {
  final String title;
  final String description;
  final String location;
  final String priceHour;
  final String priceDay;
  final String priceWeek;
  final String latitude;
  final String longitude;
  final String latlng;
  final String subCategories;

  UploadPhotosPage({Key key, this.title, this.description, this.location, this.priceDay
  ,this.priceWeek, this.priceHour,this.latitude, this.latlng, this.longitude, this.subCategories}) : super(key: key);


  @override
  _UploadPhotosPageState createState() => _UploadPhotosPageState();
}
class _UploadPhotosPageState extends State<UploadPhotosPage> {

  bool _checkLoaded = true;
  File _image;
  String base64Image = "";
  File image;
  File cropped;
  List<File> _images = [] ;
  List<String> _imagesUrl = [] ;
  String categoryName = "";
  DateTime now = new DateTime.now();
  String todaysDate = "";
  String userId = "";
  ProgressDialog _progressDialog = new ProgressDialog();
  String _imageURL ="";
  String firstName =  "";
  String lastName = "";
  String city = "";
  String country = "";
  String address = "";
  String bio = "";
  String email ="";
  String deviceToken ="";
  String StripeAccountLink = "";
   final FirebaseAuth auth = FirebaseAuth.instance;


  void _ShowBottomSheet_stripAcoount() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),

            child: Container(
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/Images/add_payment_details.png"
                        ,fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Strip Account!',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Please create/link your stripe account',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                    child: MaterialButton(
                      onPressed: () {
                        if(_images.length < 3){
                          Fluttertoast.showToast(
                              msg: "Please select minimum 3 photo",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }else if(_images.length > 5){
                          Fluttertoast.showToast(
                              msg: "Please select minimum 3 photo",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else{
                          Navigator.pop(context);
                         // Navigator.push(context, MaterialPageRoute(builder: (context)=>LinkStripeAccount()));
                          MyDailyTaskClick();
                         // SavePost();
                        }

                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      color: Color(0xff4996f3),
                      height: 40,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _ShowBottomSheet_success() {
    showModalBottomSheet(
      isDismissible: false,
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),

            child: Container(
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/Images/add_payment_details.png"
                        ,fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Success!',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Your new request posted successfully!',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyPostPage()),
                        );
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      color: Color(0xff4996f3),
                      height: 40,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String> getDeviceToken() async {
    deviceToken = await  FirebaseMessaging.instance.getToken();
    print("DEVICE ID : " +deviceToken);
    return deviceToken;
  }

  @override
  void initState(){
    super.initState();
    getProfileData();
    getDeviceToken();
    Future.delayed(Duration.zero,()async{
      StripeAccountLink = await Bizitme.readSharedPrefString(AppConstants.StripeAccountLink, "");
    });

    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    todaysDate = formattedDate;
    print(formattedDate);

    Future.delayed(Duration.zero, ()async{
      categoryName = await SHDFClass.readSharedPrefString(AppConstants.CategoryName, "");
      userId = await Bizitme.readSharedPrefString(AppConstants.UserId, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: (){
     Navigator.pop(context);
      setState(() {});
    },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
              onPressed: (){
                Navigator.pop(context);
              },),
            title: Text('Upload Photos',style: TextStyle(fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,fontFamily: "montserrat"),textAlign: TextAlign.center,),
            backgroundColor: Color(0xFFFAFAFA),
            centerTitle: true,),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.87,
                        child:  Stack(
                          children: [
                            _images.length == 0
                                ? Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset('assets/Images/upload_photo.png',height: 120,width: 120,),),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child:Text("Upload more pictures "
                                        "\n        to see them",style: TextStyle(fontSize: 18,color: Colors.black,
                                        fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text("(minimum 3 photo) ",style: TextStyle(fontSize: 14,color: Colors.black,
                                        fontFamily: "Montserrat"),),
                                  ),
                                  /*  Container(
                  padding:
                  const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _images.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                    *//*  if (index == 0) {
                        return IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                        );
                      }*//*
                      return MaterialButton(
                        onPressed: () {},
                        child: Card(
                          elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all( Radius.circular(5))
                                ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.13,
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image:  FileImage(_images[index])
                                  )
                              )
                          )
                        )
                      );
                    },
                  )),*/




                                ],
                              ),
                            )
                                :  gridViewTaskList(),
                            Positioned(bottom:0 ,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Row (
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(150.0),),
                                                elevation: 10,
                                                child:  Container(
                                                  width: MediaQuery.of(context).size.width * 0.40,
                                                  padding: EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 15),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: (){

/*
                                                          if(_images.length < 3){
                                                          Fluttertoast.showToast(
                                                          msg: "Please select minimum 3 photo",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.blue,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0);
                                                          } else
                                                            {
                                                              openCameraPicker();
                                                            }
*/

                                                          openCameraPicker();

                                                          setState(() {});
                                                        },
                                                        child: Image.asset('assets/Images/camera.png',height: 25,width: 25,),
                                                      ),

                                                      InkWell(
                                                        onTap: (){

                                                       /*   if(_images.length == 3){
                                                            Fluttertoast.showToast(
                                                                msg: "Please select minimum 3 photo",
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.BOTTOM,
                                                                timeInSecForIosWeb: 1,
                                                                backgroundColor: Colors.blue,
                                                                textColor: Colors.white,
                                                                fontSize: 16.0);
                                                          }
                                                          else
                                                          {
                                                            openGalleryPicker();
                                                          }*/

                                                          openGalleryPicker();

                                                          setState(() {});
                                                        },
                                                        child: Image.asset('assets/Images/upload.png',height: 25,width: 25,),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            ),

                                          ],
                                        ),
                                        Positioned(
                                            right: 25,
                                            bottom: 10,
                                            child:  Container(
                                              margin: EdgeInsets.only(left: 30),
                                              child: InkWell(
                                                onTap: (){
                                                  if(_images.length < 3){
                                                    Fluttertoast.showToast(
                                                        msg: "Please select minimum 3 photo",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.blue,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }else if(_images.length > 5){
                                                    Fluttertoast.showToast(
                                                        msg: "Upload maximum 5 photo",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.blue,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }else{
                                                    Future.delayed(Duration.zero,()async{
                                                      StripeAccountLink = await Bizitme.readSharedPrefString(AppConstants.StripeAccountLink, "");
                                                    }).whenComplete(() {
                                                      if(StripeAccountLink == ""){
                                                        _ShowBottomSheet_stripAcoount();
                                                      }else{
                                                        updateUserInfoInFirestore();
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Image.asset('assets/Images/next.png',height: 40,width: 40,),
                                              ),
                                            )
                                        )
                                      ],
                                    )
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  )
              )
          )
      ),
    );
  }

  GridView gridViewTaskList() {
    return GridView.builder(
      itemCount: _images.length,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
      ),
      shrinkWrap: true,

      itemBuilder: (BuildContext context, int position) {
        return Container(
          padding: EdgeInsets.all(6),
          child: Stack(
            children: [
              GestureDetector(
                child:Card(
                    elevation: 6,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child:  Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.30,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image:  FileImage(_images[position])
                            )
                        )
                    )

                ),
                onTap: (){
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPostPage()));
                },
              ),
              Positioned(
                right: 0,
                child: InkWell(
                    onTap:()
                    {
                      _images.removeAt(position);
                      print(_images.length);
                      setState(() {});
                    },
                    child:
                    Image.asset('assets/Images/remove.png',height: 20,width: 20,)
                ),
              )
            ],
          )
        );
      },
    );
  }


  //IMAGE PICKER CODE --------------------------------------------------

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

   //   MemoryImage newImage = MemoryImage(await _image.readAsBytes());
      _images.add(_image);
      print("IMAGES LIST : "+_images.length.toString());
    });

  }

  Future openCameraPicker() async {


    final picker = ImagePicker();
    await picker.getImage(source: ImageSource.camera).then((image) async {

      if (image != null) {
        try {
          print(image.path);
          cropped = await ImageCropper().cropImage(
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
        } catch (e) {
        }
        try {
          this.setState(() {
            _checkLoaded = false;
            _image = cropped;
            List<int> imageBytes = _image.readAsBytesSync();
            print(imageBytes);
            String base64ImageTemp = base64Encode(imageBytes);
            base64Image = base64ImageTemp;
            print("base 64 ================"+base64Image);
            _checkLoaded;
            base64Image;
            _image;

          });
        } catch (e) {
          //  ShowToast.showToast(Colors.green,"error 2 "+ e.toString());

        }
      }
      else {

      }
      _images.add(_image);
      print("IMAGES LIST : "+_images.length.toString());

      print("IMAGES LIST : "+_images.length.toString());
    });

  }


  Future SavePost()async{

    final User user = auth.currentUser;
    final uid = user.uid;
    print("CURRENT USER ID :"+uid);


    String price = "100.0";
    StripeAccountLink = await Bizitme.readSharedPrefString(AppConstants.StripeAccountLink, "");
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    for (int i = 0; i < this._images.length; i++) {
      var _result = await CloudStorageService.instance
          .uploadImage(_images[i]);
      String _imageURL = await _result.ref.getDownloadURL();
      print(_imageURL);
      _imagesUrl.add(_imageURL);
    }

    PostingModel posting = PostingModel();
    posting.title = widget.title;
    if(widget.priceHour != ""){
      posting.priceHour = widget.priceHour;
    }else{
      posting.priceHour = "";
    }

    if(widget.priceDay != ""){
      posting.priceDay = widget.priceDay;
    }else{
      posting.priceDay = "";
    }

    if(widget.priceWeek != ""){
      posting.priceWeek = widget.priceWeek;
    }else{
      posting.priceWeek = "";
    }

    posting.description = widget.description;
    posting.address = widget.location;
    posting.displayImages = _imagesUrl;
    posting.categoryName = categoryName;
    posting.postingDate = todaysDate;
    posting.latitude = widget.latitude;
    posting.longitude = widget.longitude;
    posting.latlng = widget.latlng;
    posting.userId = uid;
    posting.stripeAccountLink = StripeAccountLink;
    posting.deviceToken = deviceToken;
    posting.subCategories = widget.subCategories;

    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    posting.addPostingInfoToFirestore().whenComplete(() {
      posting.addPostingForAll().whenComplete(() {
        _ShowBottomSheet_success();
      });
    });


  }


  Future<void> getProfileData() async {
    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();


        String emailmain = await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
        print(emailmain);

        String email = values['email'];

        if(emailmain ==email){
          StripeAccountLink = values['stripeAccountLink'];
          if(StripeAccountLink == null){
            Bizitme.saveSharedPrefValueString(AppConstants.StripeAccountLink, "");
          }else{
            Bizitme.saveSharedPrefValueString(AppConstants.StripeAccountLink, StripeAccountLink);
          }

          setState(() {});
        }

      });
    });
  }


  Future<void> updateUserInfoInFirestore() async {
    Map<String, dynamic> data = {
      'stripeAccountLink': StripeAccountLink,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    //  await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);
    await FirebaseFirestore.instance.collection('users').doc(uid).update(data);
    SavePost();
  }


  Future MyDailyTaskClick() async {
    Route route = MaterialPageRoute(builder: (context)=>LinkStripeAccount());
    var nav = await Navigator.of(context).push(route);
    if (nav == true || nav == null) {
      setState(() {
        Future.delayed(Duration.zero,()async{
          StripeAccountLink = await Bizitme.readSharedPrefString(AppConstants.StripeAccountLink, "");
          if(StripeAccountLink != ""){
            updateUserInfoInFirestore();
          }
        });
      });
    }
  }


}
