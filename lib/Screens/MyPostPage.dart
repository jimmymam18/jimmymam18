import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/AddPostPage.dart';
import 'package:bizitme/Screens/DashboardCategoryPage.dart';
import 'package:bizitme/Screens/MyPostWarningPage.dart';
import 'package:bizitme/Screens/ProfilePage.dart';
import 'package:bizitme/Screens/UpdateMyPost.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:bizitme/Utils/custom_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


// import 'package:geolocator/geolocator.dart';


class MyPostPage extends StatefulWidget {
  final String switchPage;

  MyPostPage({Key key, this.switchPage}) : super(key: key);

  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  Icon menuverticon = Icon(Icons.more_vert);
  Icon cancelIcon = Icon(
    Icons.cancel,
  );

  bool edit_deleteFlag = false;
  List<PostingModel> postList = new List();
  ProgressDialog _progressDialog = new ProgressDialog();
  String postId = "";
  String documnetId = "";
  String title = "";
  final db = FirebaseFirestore.instance;
  String uid = "";
  String currentLatlong = "";
  String currentLat = "";
  String currentlong = "";
  String destination = "";
  String destinationLat = "";
  String destinationlong = "";


  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
     uid = user.uid;
    super.initState();
    CategoryList();
    _getLocation();
    setState(() {});
  }


  void _ShowBottomSheet_warningPage() {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/Images/Success.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Warning',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Are you sure want to delete '+title+" post ?",
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        padding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("No"),
                        ),
                      ),
                      Container(
                        width: 150,
                        padding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {
                            deletePost();
                            setState(() {});
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Yes"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, null);

        if(widget.switchPage == "1"){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '4',)));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '0',)));
        }

        setState(() {});
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, null);

                if(widget.switchPage == "1"){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '4',)));
                }else{
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '0',)));
                }
                setState(() {});
              },
            ),
            title: Text(
              'My Post',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "montserrat"),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Color(0xff4996f3),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 5),
            child:postList.isNotEmpty
              ?Padding(
              padding: const EdgeInsets.all(1.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('users').doc(uid).collection("add_my_post").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var doc = snapshot.data.docs;
                    return new  ListView.builder(
                      itemCount: postList.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int position) {
                        return Container(
                            margin: EdgeInsets.all(5),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: (){
                                    String title = postList[position].title;
                                    String description = postList[position].description;
                                    String location = postList[position].address;
                                    String amountDay = postList[position].priceDay;
                                    String amountWeek = postList[position].priceWeek;
                                    String amountHour = postList[position].priceHour;
                                    String categoryName = postList[position].categoryName;
                                    String postingDate = postList[position].postingDate;
                                    String latitude = postList[position].latitude;
                                    String longitude = postList[position].longitude;
                                    String latlng = postList[position].latlng;
                                    String userId = postList[position].userId;
                                    String subCategories = postList[position].subCategories;

                                    List<String> imageList = postList[position].names;

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            MyPostWarningPage(title: title, description: description,
                                              location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                              postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,subCategories:subCategories)));
                                    setState(() {});
                                  },
                                  child: Card(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10, top: 10, bottom: 8,right: 25),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.80,
                                                child: Text(
                                                  postList[position].title,
                                                  textAlign: TextAlign.left,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "MontSerrat_Medium",
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 8, right: 8),
                                          child: Wrap(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width * 0.90,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 0),
                                                  //margin: EdgeInsets.all(5),
                                                  height: 25.0,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      postList[position].priceHour != ""
                                                          ? RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(8.0),
                                                            side: BorderSide(
                                                              color: Color(0xff4996f3),
                                                            )),
                                                        onPressed: () {
                                                          String title = postList[position].title;
                                                          String description = postList[position].description;
                                                          String location = postList[position].address;
                                                          String amountDay = postList[position].priceDay;
                                                          String amountWeek = postList[position].priceWeek;
                                                          String amountHour = postList[position].priceHour;
                                                          String categoryName = postList[position].categoryName;
                                                          String postingDate = postList[position].postingDate;

                                                          String latitude = postList[position].latitude;
                                                          String longitude = postList[position].longitude;
                                                          String latlng = postList[position].latlng;
                                                          String subCategories = postList[position].subCategories;

                                                          List<String> imageList = postList[position].names;

                                                          Navigator.pushReplacement(context,
                                                              MaterialPageRoute(builder: (context) =>
                                                                  MyPostWarningPage(title: title, description: description,
                                                                    location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                                    postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,subCategories:subCategories)));
                                                          setState(() {});

                                                        },
                                                        color: Colors.white,
                                                        textColor: Color(0xff4996f3),
                                                        child: Text(
                                                            "\$" +
                                                                postList[position]
                                                                    .priceHour +
                                                                "/Hour",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily: "Montserrat",
                                                                fontWeight:
                                                                FontWeight.w600)),
                                                      )
                                                          : Container(),

                                                      postList[position].priceDay != ""
                                                          ? Container(
                                                        margin : EdgeInsets.only(left: 10, right: 10),
                                                        child:RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(8.0),
                                                              side: BorderSide(
                                                                color: Color(0xff4996f3),
                                                              )),
                                                          onPressed: () {
                                                            String title = postList[position].title;
                                                            String description = postList[position].description;
                                                            String location = postList[position].address;
                                                            String amountDay = postList[position].priceDay;
                                                            String amountWeek = postList[position].priceWeek;
                                                            String amountHour = postList[position].priceHour;
                                                            String categoryName = postList[position].categoryName;
                                                            String postingDate = postList[position].postingDate;

                                                            String latitude = postList[position].latitude;
                                                            String longitude = postList[position].longitude;
                                                            String latlng = postList[position].latlng;
                                                            String subCategories = postList[position].subCategories;


                                                            List<String> imageList = postList[position].names;

                                                            Navigator.pushReplacement(context,
                                                                MaterialPageRoute(builder: (context) =>
                                                                    MyPostWarningPage(title: title, description: description,
                                                                      location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                                      postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,subCategories:subCategories)));
                                                            setState(() {});

                                                          },
                                                          color: Colors.white,
                                                          textColor: Color(0xff4996f3),
                                                          child: Text(
                                                              "\$" +
                                                                  postList[position]
                                                                      .priceDay +
                                                                  "/Day",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily: "Montserrat",
                                                                  fontWeight:
                                                                  FontWeight.w600)),
                                                        )
                                                      )
                                                          : Container(),

                                                      postList[position].priceWeek != ""
                                                          ? Container(
                                                        child: RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(8.0),
                                                              side: BorderSide(
                                                                color: Color(0xff4996f3),
                                                              )),
                                                          onPressed: () {
                                                            String title = postList[position].title;
                                                            String description = postList[position].description;
                                                            String location = postList[position].address;
                                                            String amountDay = postList[position].priceDay;
                                                            String amountWeek = postList[position].priceWeek;
                                                            String amountHour = postList[position].priceHour;
                                                            String categoryName = postList[position].categoryName;
                                                            String postingDate = postList[position].postingDate;
                                                            String latitude = postList[position].latitude;
                                                            String longitude = postList[position].longitude;
                                                            String latlng = postList[position].latlng;
                                                            String subCategories = postList[position].subCategories;

                                                            List<String> imageList = postList[position].names;

                                                            Navigator.pushReplacement(context,
                                                                MaterialPageRoute(builder: (context) =>
                                                                    MyPostWarningPage(title: title, description: description,
                                                                      location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                                      postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,subCategories:subCategories)));
                                                            setState(() {});

                                                          },
                                                          color: Colors.white,
                                                          textColor: Color(0xff4996f3),
                                                          child: Text(
                                                              "\$" +
                                                                  postList[position]
                                                                      .priceWeek +
                                                                  "/Week",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily: "Montserrat",
                                                                  fontWeight:
                                                                  FontWeight.w600)),
                                                        )
                                                      )
                                                          : Container(),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                            height: 40.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(9.0),
                                                  bottomRight: Radius.circular(9.0)),
                                              color: Color(0xffe2f1ff),
                                            ),
                                            child: Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                ),
                                                InkWell(
                                                  onTap:(){
                                                    destinationLat = postList[position].latitude;
                                                    destinationlong = postList[position].longitude;

                                                    String test = postList[position].latlng;

                                                    String myString = test;
                                                    String latString = myString.substring(7);

                                                    String testing = latString.replaceAll(")", "");

                                                    destination = testing;
                                                    print("anki tlinkahr : "+destination);
                                                    // destination = (destinationLat +","+ destinationlong);

                                                    openMap();
                                                    setState(() {});
                                                  },
                                                  child:  Container(
                                                    width: MediaQuery.of(context).size.width * 0.80,
                                                    child: Text(
                                                      postList[position].address,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily: "Montserrat_Medium",
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 2),
                                                ),
                                                Image.asset(
                                                  'assets/Images/location.png',
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      child:postId == postList[position].id
                                          ? Container(
                                        width: MediaQuery.of(context).size.width * 0.30,
                                        height: MediaQuery.of(context).size.height * 0.30,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              right: 5,
                                              child: Container(
                                                width: MediaQuery.of(context).size.width *
                                                    0.10,
                                                child: IconButton(
                                                  icon: new Icon(
                                                    Icons.cancel,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    edit_deleteFlag = false;
                                                    postId="";

                                                    setState(() {});
                                                  },
                                                  //color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 28,
                                              top: 3,
                                              child: IconButton(
                                                icon: new Image.asset(
                                                  'assets/Images/edit.png',
                                                  height: 39,
                                                  width: 39,
                                                ),
                                                onPressed: () {
                                                  edit_deleteFlag = false;

                                                  String title = postList[position].title;
                                                  String description = postList[position].description;
                                                  String location = postList[position].address;
                                                  String amountDay = postList[position].priceDay;
                                                  String amountWeek = postList[position].priceWeek;
                                                  String amountHour = postList[position].priceHour;
                                                  String categoryName = postList[position].categoryName;
                                                  String postingDate = postList[position].postingDate;

                                                  String latitude = postList[position].latitude;
                                                  String longitude = postList[position].longitude;
                                                  String latlng = postList[position].latlng;
                                                  String userId = postList[position].userId;
                                                  String stripeAccountLink = postList[position].stripeAccountLink;
                                                  String deviceToken = postList[position].deviceToken;
                                                  String subCategories = postList[position].subCategories;

                                                  List<String> imageList = postList[position].names;

                                                  Navigator.pushReplacement(context,
                                                      MaterialPageRoute(builder: (context) =>
                                                          UpdateMyPost(title: title, description: description,
                                                            location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                          documnetId: documnetId,postingDate:postingDate, latitude: latitude,longitude: longitude,latlng: latlng,
                                                              userId:userId,deviceToken:deviceToken,stripeAccountLink:stripeAccountLink,subCategories:subCategories)));
                                                  setState(() {});
                                                },
                                                color: Colors.white,
                                              ),
                                            ),
                                            Positioned(
                                                top: 27,
                                                right: 9,
                                                child: IconButton(
                                                  icon: new Image.asset(
                                                    'assets/Images/delete.png',
                                                    height: 29,
                                                    width: 29,
                                                  ),
                                                  onPressed: () {
                                                    edit_deleteFlag = false;
                                                    title = postList[position].title;
                                                    _ShowBottomSheet_warningPage();
                                                  },
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      )
                                          : IconButton(
                                        icon: new Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          edit_deleteFlag = true;
                                          postId = postList[position].id;
                                          print(doc[position].id);
                                          documnetId = doc[position].id;

                                          print(postList[position].latitude);
                                          setState(() {});
                                        },
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ));
                      },
                    );
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
            )
            :Container(
              height: MediaQuery.of(context).size.height * 0.90,
             width: MediaQuery.of(context).size.width ,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("No Post Available", textAlign: TextAlign.center,style: TextStyle(fontSize: 17.0,color: Colors.black,fontWeight: FontWeight.w500),),
               ],
             )
            ),
          )),
    );
  }


/*  ListView testUpcomingList() {
    return ListView.builder(
      itemCount: postList.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Container(
            margin: EdgeInsets.all(5),
            child: Stack(
              children: [
                InkWell(
                  onTap: (){
                    String title = postList[position].title;
                    String description = postList[position].description;
                    String location = postList[position].address;
                    String amountDay = postList[position].priceDay;
                    String amountWeek = postList[position].priceWeek;
                    String amountHour = postList[position].priceHour;
                    String categoryName = postList[position].categoryName;

                   List<String> imageList = postList[position].names;

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                        MyPostWarningPage(title: title, description: description,
                          location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,)));
                    setState(() {});
                  },
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                postList[position].title,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "MontSerrat_Medium",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8, right: 8),
                          child: Wrap(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  //margin: EdgeInsets.all(5),
                                  height: 25.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      postList[position].priceHour != ""
                                          ? RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            side: BorderSide(
                                              color: Color(0xff4996f3),
                                            )),
                                        onPressed: () {
                                          String title = postList[position].title;
                                          String description = postList[position].description;
                                          String location = postList[position].address;
                                          String amountDay = postList[position].priceDay;
                                          String amountWeek = postList[position].priceWeek;
                                          String amountHour = postList[position].priceHour;
                                          String categoryName = postList[position].categoryName;

                                          List<String> imageList = postList[position].names;

                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  MyPostWarningPage(title: title, description: description,
                                                    location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,)));
                                          setState(() {});

                                        },
                                        color: Colors.white,
                                        textColor: Color(0xff4996f3),
                                        child: Text(
                                            "\$" +
                                                postList[position]
                                                    .priceHour +
                                                "/Hour",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "Montserrat",
                                                fontWeight:
                                                FontWeight.w600)),
                                      )
                                          : Container(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      postList[position].priceDay != ""
                                          ? RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            side: BorderSide(
                                              color: Color(0xff4996f3),
                                            )),
                                        onPressed: () {
                                          String title = postList[position].title;
                                          String description = postList[position].description;
                                          String location = postList[position].address;
                                          String amountDay = postList[position].priceDay;
                                          String amountWeek = postList[position].priceWeek;
                                          String amountHour = postList[position].priceHour;
                                          String categoryName = postList[position].categoryName;

                                          List<String> imageList = postList[position].names;

                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  MyPostWarningPage(title: title, description: description,
                                                    location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,)));
                                          setState(() {});

                                        },
                                        color: Colors.white,
                                        textColor: Color(0xff4996f3),
                                        child: Text(
                                            "\$" +
                                                postList[position]
                                                    .priceDay +
                                                "/Day",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "Montserrat",
                                                fontWeight:
                                                FontWeight.w600)),
                                      )
                                          : Container(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      postList[position].priceWeek != ""
                                          ? RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            side: BorderSide(
                                              color: Color(0xff4996f3),
                                            )),
                                        onPressed: () {
                                          String title = postList[position].title;
                                          String description = postList[position].description;
                                          String location = postList[position].address;
                                          String amountDay = postList[position].priceDay;
                                          String amountWeek = postList[position].priceWeek;
                                          String amountHour = postList[position].priceHour;
                                          String categoryName = postList[position].categoryName;

                                          List<String> imageList = postList[position].names;

                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  MyPostWarningPage(title: title, description: description,
                                                    location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,)));
                                          setState(() {});

                                        },
                                        color: Colors.white,
                                        textColor: Color(0xff4996f3),
                                        child: Text(
                                            "\$" +
                                                postList[position]
                                                    .priceWeek +
                                                "/Week",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "Montserrat",
                                                fontWeight:
                                                FontWeight.w600)),
                                      )
                                          : Container(),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(9.0),
                                  bottomRight: Radius.circular(9.0)),
                              color: Color(0xffe2f1ff),
                            ),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.80,
                                  child: Text(
                                    postList[position].address,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: "Montserrat_Medium",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Image.asset(
                                  'assets/Images/location.png',
                                  height: 10,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      child:postId == postList[position].id
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 5,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.10,
                                      child: IconButton(
                                        icon: new Icon(
                                          Icons.cancel,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          edit_deleteFlag = false;
                                          setState(() {});
                                        },
                                        //color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 25,
                                    top: 3,
                                    child: IconButton(
                                      icon: new Image.asset(
                                        'assets/Images/edit.png',
                                        height: 22,
                                        width: 22,
                                      ),
                                      onPressed: () {
                                        edit_deleteFlag = false;

                                        String title = postList[position].title;
                                        String description = postList[position].description;
                                        String location = postList[position].address;
                                        String amountDay = postList[position].priceDay;
                                        String amountWeek = postList[position].priceWeek;
                                        String amountHour = postList[position].priceHour;
                                        String categoryName = postList[position].categoryName;

                                        List<String> imageList = postList[position].names;

                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) =>
                                                UpdateMyPost(title: title, description: description,
                                                  location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,)));
                                        setState(() {});
                                        setState(() {});
                                      },
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                      top: 25,
                                      right: 9,
                                      child: IconButton(
                                        icon: new Image.asset(
                                          'assets/Images/delete.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                        onPressed: () {
                                          edit_deleteFlag = false;


                                        },
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            )
                          : IconButton(
                              icon: new Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                edit_deleteFlag = true;
                                postId = postList[position].id;

                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User user = auth.currentUser;
                                final uid = user.uid;

                                Firestore.instance.collection('users').doc(uid).collection("add_my_post").snapshots();
                                var snapshot;
                                print(snapshot.data.documents[position].documentID) ;
                                StreamBuilder(
                                    stream: Firestore.instance.collection('users').doc(uid).collection("add_my_post").snapshots(),
                                    builder: (context, snapshot) {
                                      print(snapshot.data.documents[position].documentID) ;
                                      if (!snapshot.hasData) {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      else {
                                        print(snapshot.data.documents[position].documentID) ;//this prints the document id of the (0th) first element in the collection of cars
                                      }
                                    });


                                setState(() {});
                              },
                              color: Colors.white,
                            ),
                    )),
              ],
            ));
      },
    );
  }*/


  Future<void> CategoryList() async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("add_my_post");
    print("query   "+query.toString());
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);
        PostingModel posting = PostingModel();

        String address = values['address'];
        String title = values['title'];
        String description = values['description'];
        String categoryName = values['categoryName'];
        String priceDay = values['priceDay'];
        String priceHour = values['priceHour'];
        String priceWeek = values['priceWeek'];
        String postingDate = values['postingDate'];
        String latitude = values['latitude'];
        String longitude = values['longitude'];
        String latlng = values['latlng'];

        String userId = values['userId'];
        String stripeAccountLink = values['stripeAccountLink'];
        String deviceToken = values['deviceToken'];
        String subCategories = values['subCategories'];

        posting.names = List.from(document['imageNames']);
        print("images list "+posting.names.length.toString());

        posting.address = address;
        posting.title = title;
        posting.description = description;
        posting.categoryName = categoryName;
        posting.priceDay = priceDay;
        posting.priceHour = priceHour;
        posting.priceWeek = priceWeek;
        posting.postingDate = postingDate;
        posting.latitude = latitude;
        posting.longitude = longitude;
        posting.latlng = latlng;
        posting.userId = userId;
        posting.stripeAccountLink = stripeAccountLink;
        posting.deviceToken = deviceToken;
        posting.subCategories = subCategories;

        postList.add(posting);

      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;
      print(postList.length.toString());
      setState(() {});
    });
  }


  Future<void> deletePost() async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    PostingModel posting = PostingModel();

    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    posting.deletePostingInfoInFirestore(documnetId).whenComplete(() {

      Fluttertoast.showToast(
          msg: "Post deleted successfully.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyPostPage()),
      );
      setState(() {});
    });
  }


  Future<void> openMap() async {

    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + destinationLat + ',' + destinationlong + '&travelmode=driving&dir_action=navigate';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future _getLocation() async {
    // Location location = new Location();
    // LocationData _pos = await location.getLocation();
    // print("lati "+_pos.latitude.toString());
    //
    // currentLat = _pos.latitude.toString();
    // currentlong = _pos.longitude.toString();
    // currentLatlong = (currentLat +","+ currentlong);


  //   await Geolocator.getCurrentPosition().then((value) =>
  //   {
  //
  //     print("latitude ---" + value.latitude.toString()),
  //     print("longitude ---" + value.longitude.toString()),
  //
  //     // latitude= value.latitude,
  //     // longitude= value.longitude
  //
  //   currentLat = value.latitude.toString(),
  //       currentlong = value.longitude.toString(),
  //   currentLatlong = (currentLat +","+ currentlong)
  // });


  }


}
