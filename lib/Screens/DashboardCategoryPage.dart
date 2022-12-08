import 'dart:io';

import 'package:bizitme/Models/CategoryModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/AddPostPage.dart';
import 'package:bizitme/Screens/SubCategoryAddPost.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class DashBoardCategoryPage extends StatefulWidget {


  @override
  _DashBoardCategoryPageState createState() => _DashBoardCategoryPageState();
}

class _DashBoardCategoryPageState extends State<DashBoardCategoryPage> {
  List<CategoryModel> categoryList = new List();
  File _imageFile;
  ProgressDialog _progressDialog = new ProgressDialog();
  final databaseReference = FirebaseFirestore.instance;
  bool progressDialog = false;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

 /* void _chooseImage() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _imageFile = File(imageFile.path);
      print("IMAG URL : "+_imageFile.toString());

      setState(() {});
    }
  }


  Future<void> UploadImageToFirebaseCode() async {

    String _imageURL = "";

    var _result = await CloudStorageService.instance
        .uploadImage(_imageFile);
    _imageURL = await _result.ref.getDownloadURL();
    print(_imageURL);


    Firestore.instance
        .collection('category')
        .add({
      "category_name": "Parking Lot",
      "category_image": ""+_imageURL
    });
  }*/


  @override
  void initState(){
    CategoryList();
    super.initState();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GuestHomePage()));
      setState(() {});
    },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text('Choose a Category',style: TextStyle(fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,fontFamily: "montserrat"),textAlign: TextAlign.center,),
            backgroundColor: Color(0xFFFAFAFA),
            leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GuestHomePage()));
                setState(() {});
              },),
            centerTitle: true,
          ),

          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02,right: MediaQuery.of(context).size.width * 0.02,),
                child: gridViewTaskList(),
              ),
       /*  InkWell(
           onTap: (){
             UploadImageToFirebaseCode();
             setState(() {

             });
           },
           child:  Container(
             height: 20,
             width: 20,
             color: Colors.red,
           ),
         ),
          InkWell(
            onTap: (){
              _chooseImage();
              setState(() {});
            },
            child:  Container(
          ]    height: 20,
              width: 20,
              color: Colors.yellow,
            ),
          ),*/
            ],
          )
      ),);
  }


  GridView gridViewTaskList() {
    return GridView.builder(
      itemCount: categoryList.length,
      padding: EdgeInsets.zero,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Container(
          padding: EdgeInsets.all(6),
          child:  GestureDetector(
            child:Card(
              elevation: 6,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   /* Image.network(categoryList[position].image,height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.height * 0.08, fit: BoxFit.fill,),*/
                    CachedNetworkImage(
                      imageUrl: categoryList[position].image,
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.height * 0.08, fit: BoxFit.fill,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 13, right: 13, top: 8, bottom: 2),
                      child:Text(categoryList[position].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),)
                    )
                  ],
                ),

              ),

            ),
            onTap: (){
              String categoryName = categoryList[position].name;
              SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, categoryName);
              print("CATEGORY NAME : "+categoryName);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPostPage()));
            },
          ),
        );
      },
    );
  }


  Future<void> CategoryList() async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }


    Query query = FirebaseFirestore.instance.collection('category');
    await query.get().then((querySnapshot) async {
     // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);
        CategoryModel categoryModel = new CategoryModel();


        String name = values['category_name'];
        String image = values['category_image'];


        categoryModel.name = name;
        categoryModel.image = image;

        categoryList.add(categoryModel);
      });

      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      print(categoryList.length.toString());
      setState(() {});
    });
  }


}



