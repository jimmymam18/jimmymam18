import 'dart:convert';

import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/SendNotficationRequestModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/ListCursorSliderPage.dart';
import 'package:bizitme/Screens/explorePage.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryDeatails extends StatefulWidget {
  final String titleName;

  CategoryDeatails({Key key, this.titleName}) : super(key: key);

  @override
  _CategoryDeatailsState createState() => _CategoryDeatailsState();
}

class _CategoryDeatailsState extends State<CategoryDeatails> {
  List<PostingModel> postList = new List();
  List<PostingModel> favpostList = new List();
  List<PostingModel> categoryList = new List();
  List<PostingModel> userIdList = new List();
  ProgressDialog _progressDialog = new ProgressDialog();
  String userId = "";
  final db = FirebaseFirestore.instance;
  String uid = "";
  String documnetId = "";
  String length = "";
  String msg = "";
  String latitude = "";
  String longitude = "";
  static String deviceToken = "";
  static String receiverDeviceToken = "";

  Future<String> getDeviceToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
    print("DEVICE ID : " + deviceToken);
    return deviceToken;
  }

  @override
  void initState() {
    super.initState();
    print("title : ");

    getDeviceToken();
    CategoryList();
    //CategoryList();
    Future.delayed(Duration.zero, () async {
      userId = await SHDFClass.readSharedPrefString(AppConstants.UserId, "");
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GuestHomePage(indexCount: '0')));
        setState(() {});
      },
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 2,
            leading: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
              child: IconButton(
                icon: Image.asset(
                  'assets/Images/back.png',
                  scale: 7,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GuestHomePage(indexCount: '0')));
                },
              ),
            ),
            centerTitle: true,
            title: Text(widget.titleName,
                style: TextStyle(fontSize: 20, fontFamily: "Montserrat"),
                textAlign: TextAlign.center),
            backgroundColor: Color(0xff4996f3),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 5),
              child: SingleChildScrollView(
                child: length == "1"
                    ? Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: db.collection('all_post').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var doc = snapshot.data.docs;
                              return new ListView.builder(
                                itemCount: postList.length,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  print("title : " +
                                      postList[position].categoryName);
                                  return widget.titleName ==
                                              postList[position].categoryName &&
                                          userId != postList[position].userId
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: 3),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 3, right: 3),
                                            child: GestureDetector(
                                              child: Card(
                                                elevation: 7.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        height: 120.0,
                                                        width: 120.0,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              postList[position]
                                                                  .names[0],
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 120.0,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.62,
                                                        child: Column(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                //  width: MediaQuery.of(context).size.width*0.75,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              6,
                                                                          right:
                                                                              6,
                                                                          top:
                                                                              6,
                                                                          bottom:
                                                                              3),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.45,
                                                                            child:
                                                                                Text(
                                                                              postList[position].title,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "MontSerrat_Medium"),
                                                                            ),
                                                                          ),

                                                                          // Image.asset('assets/Images/favourite_off.png',height: 28,width: 28,),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Wrap(
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(left: 3),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              postList[position].priceHour != "" && postList[position].priceHour != null
                                                                                  ? Expanded(
                                                                                      flex: postList[position].priceDay == "" || postList[position].priceDay == null ? 0 : 1,
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Container(
                                                                                              child: Image.asset(
                                                                                            "assets/Images/per_hour.png",
                                                                                            fit: BoxFit.fill,
                                                                                            scale: 6,
                                                                                          )),
                                                                                          Positioned(
                                                                                            top: MediaQuery.of(context).size.height * 0.02,
                                                                                            child: Container(
                                                                                              width: MediaQuery.of(context).size.height * 0.11,
                                                                                              child: Text(
                                                                                                "\$" + postList[position].priceHour.toString(),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue, fontFamily: "MontSerrat_Medium"),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : Container(),
                                                                              postList[position].priceDay != "" && postList[position].priceDay != null
                                                                                  ? Expanded(
                                                                                      flex: postList[position].priceHour == "" || postList[position].priceHour == null ? 0 : 1,
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Container(
                                                                                              child: Image.asset(
                                                                                            "assets/Images/per_day.png",
                                                                                            scale: 6,
                                                                                          )),
                                                                                          Positioned(
                                                                                            top: MediaQuery.of(context).size.height * 0.02,
                                                                                            child: Container(
                                                                                              width: MediaQuery.of(context).size.height * 0.11,
                                                                                              child: Text(
                                                                                                "\$" + postList[position].priceDay,
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue, fontFamily: "MontSerrat_Medium"),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : Container(),
                                                                              postList[position].priceWeek != "" && postList[position].priceWeek != null
                                                                                  ? Expanded(
                                                                                      flex: 1,
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Container(
                                                                                              child: Image.asset(
                                                                                            "assets/Images/per_week.png",
                                                                                            scale: 6,
                                                                                          )),
                                                                                          Positioned(
                                                                                            top: MediaQuery.of(context).size.height * 0.02,
                                                                                            child: Container(
                                                                                              width: MediaQuery.of(context).size.height * 0.11,
                                                                                              child: Text(
                                                                                                "\$" + postList[position].priceWeek,
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue, fontFamily: "MontSerrat_Medium"),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : Container()
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          40.0,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.99,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(bottomRight: Radius.circular(9.0)),
                                                                        color: Color(
                                                                            0xffe2f1ff),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 8),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              latitude = postList[position].latitude;
                                                                              longitude = postList[position].longitude;
                                                                              openMap();
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.of(context).size.width * 0.50,
                                                                              child: Text(
                                                                                postList[position].address,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontSize: 10, fontFamily: "Montserrat", fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 2, right: 3),
                                                                          ),
                                                                          Image
                                                                              .asset(
                                                                            'assets/Images/location.png',
                                                                            height:
                                                                                10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                String title =
                                                    postList[position].title;
                                                String description =
                                                    postList[position]
                                                        .description;
                                                String location =
                                                    postList[position].address;
                                                String amountDay =
                                                    postList[position].priceDay;
                                                String amountWeek =
                                                    postList[position]
                                                        .priceWeek;
                                                String amountHour =
                                                    postList[position]
                                                        .priceHour;
                                                String categoryName =
                                                    postList[position]
                                                        .categoryName;
                                                String postingDate =
                                                    postList[position]
                                                        .postingDate;
                                                String latitude =
                                                    postList[position].latitude;
                                                String longitude =
                                                    postList[position]
                                                        .longitude;
                                                String latlng =
                                                    postList[position].latlng;
                                                String addPostUserId =
                                                    postList[position].userId;
                                                String stripeAccountLink =
                                                    postList[position]
                                                        .stripeAccountLink;
                                                String deviceToken =
                                                    postList[position]
                                                        .deviceToken;
                                                String documentIdAdd =
                                                    postList[position]
                                                        .documentId;
                                                String userId =
                                                    postList[position].userId;
                                                String subCategories =
                                                    postList[position]
                                                        .subCategories;
                                                receiverDeviceToken =
                                                    postList[position]
                                                        .deviceToken;
                                                List<String> imageList =
                                                    postList[position].names;

                                                print(doc[position].id);
                                                documnetId = doc[position].id;

                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ListCusrsolPage(
                                                            title: title,
                                                            description:
                                                                description,
                                                            documentId:
                                                                documnetId,
                                                            location: location,
                                                            priceDay: amountDay,
                                                            priceHour:
                                                                amountHour,
                                                            priceWeek:
                                                                amountWeek,
                                                            categoryName:
                                                                categoryName,
                                                            names: imageList,
                                                            postingDate:
                                                                postingDate,
                                                            latitude: latitude,
                                                            longitude:
                                                                longitude,
                                                            latlng: latlng,
                                                            addPostUserId:
                                                                addPostUserId,
                                                            stripeAccountLink:
                                                                stripeAccountLink,
                                                            deviceToken:
                                                                deviceToken,
                                                            receiverDeviceToken:
                                                                receiverDeviceToken,
                                                            documentIdAdd:
                                                                documentIdAdd,
                                                            userId: userId,
                                                            subCategories:
                                                                subCategories)));
                                                setState(() {});

                                                //   sendFcmMessage("Bizit-Me", "yOUR POST BOOKED BY SOMEONE");
                                                //  sendNotf("Bizit-Me", "yOUR POST BOOKED BY SOMEONE");
                                              },
                                            ),
                                          ),
                                        )
                                      : Container();
                                },
                              );
                            } else {
                              return LinearProgressIndicator();
                            }
                          },
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.90,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              msg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )),
              ))),
    );
  }

  Future<void> CategoryList() async {
    postList.clear();
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);

    Query query = FirebaseFirestore.instance.collection('all_post');
    print("query   " + query.toString());
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
        String wishList = values['wishList'];
        String bookingStatus = values['bookingStatus'];
        String userId = values['userId'];
        String stripeAccountLink = values['stripeAccountLink'];
        String deviceToken = values['deviceToken'];
        String documentID = values['documentId'];
        String subCategories = values['subCategories'];

        posting.names = List.from(document['imageNames']);
        print("images list " + posting.names.length.toString());

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
        posting.wishList = wishList;
        posting.bookingStatus = bookingStatus;
        posting.userId = userId;
        posting.stripeAccountLink = stripeAccountLink;
        posting.deviceToken = deviceToken;
        posting.documentId = documentID;
        posting.subCategories = subCategories;
        posting.addedFav = false;

        postList.add(posting);
      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      // postFirebaseList();
    });

    checkFavourite();
  }

  Future<void> openMap() async {
    String lat = latitude;
    String long = longitude;
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=' +
        lat +
        ',' +
        long +
        '&travelmode=driving&dir_action=navigate';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  // send notification
  Future sendNotf(String title, String body1) async {
    // String strSenderToken = await SHDFClass.readSharedPrefString(AppConstants.Token, "");

    final String serverToken =
        "AAAACnjnL0U:APA91bGDnroPSh5vXZRrPvG1-cUS7V6pK6ic0SLRAJLrauNjvIqpLi_UJcuIGxm5aXnJGMcpZkSsMhRL0wU5PbZ-gVCSqVVsORNB-Hvxflquc3-R2uTR5GHL43m7Jw5AEUz4q9GQedG0";

    SendNotficationRequestModel sendNotficationRequestModel =
        new SendNotficationRequestModel();
    sendNotficationRequestModel.to = receiverDeviceToken;
    //sendNotficationRequestModel.androidChannelId = "noti_push_app_1";
    //sendNotficationRequestModel.contentAvailable = true;
    //sendNotficationRequestModel.sound = "alarm.mp3";
    sendNotficationRequestModel.priority = "high";
    Data data = new Data();
    data.androidChannelId = "noti_push_app_1";
    data.clickAction = "FLUTTER_NOTIFICATION_CLICK";
    data.sound = "alarm.mp3";
    data.title = title;

    /* String msg = "";
    if (file_type == "text") {
      msg = body1;
    } else {
      msg = "Voice message";
    }*/

    data.body = body1;
    data.type = "";
    data.file_type = "";
    data.sender_emailid = "";
    data.sender_profile = "";
    data.reciver_token = receiverDeviceToken;
    data.sender_token = deviceToken;
    sendNotficationRequestModel.data = data;
    Notification1 notf = new Notification1();
    notf.sound = "alarm.mp3";
    notf.title = title;
    notf.clickAction = "FLUTTER_NOTIFICATION_CLICK";
    notf.body = body1;
    notf.contentAvailable = true;
    notf.androidChannelId = "noti_push_app_1";
    sendNotficationRequestModel.notification = notf;

    var body = json.encode(sendNotficationRequestModel);
    print(body);
    try {
      var responseInternet = await http
          .post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                "Content-Type": "application/json",
                'Authorization':
                    "key=AAAACnjnL0U:APA91bGDnroPSh5vXZRrPvG1-cUS7V6pK6ic0SLRAJLrauNjvIqpLi_UJcuIGxm5aXnJGMcpZkSsMhRL0wU5PbZ-gVCSqVVsORNB-Hvxflquc3-R2uTR5GHL43m7Jw5AEUz4q9GQedG0",
              },
              body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          print("error");

          throw new Exception("Error while fetching data");
        } else {
          print("done");
        }
      });
    } catch (e) {
      print("error");
    }
  }

  Future<void> checkFavourite() async {
    favpostList.clear();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);
    Query query = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my_wishlist");
    print("query   " + query.toString());
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);

        PostingModel posting = PostingModel();

        String documentID = values['documentIdAdd'];
        posting.documentId = documentID;

        favpostList.add(posting);
      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      // postFirebaseList();
    });

    for (int i = 0; i < postList.length; i++) {
      for (int j = 0; j < favpostList.length; j++) {
        if (postList[i].documentId != null) {
          if (postList[i].documentId == favpostList[j].documentId) {
            postList[i].addedFav = true;
          } else {
            //    postList[i].addedFav=false;
          }
        } else {
          postList[i].addedFav = false;
        }
      }
    }

    for (int i = 0; i < postList.length; i++) {
      if (widget.titleName == postList[i].categoryName &&
          userId != postList[i].userId) {
        length = "1";
        msg = "";
      }
    }

    if (length == "1") {
      msg = "";
    } else {
      msg = "No Data Available";
    }
    setState(() {
      postList;
    });
  }

  //Add FAVOURITE
  Future<void> addToFavourite(PostingModel postingModel) async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    Map<String, dynamic> data = {
      "title": postingModel.title,
      "description": postingModel.description,
      "location": postingModel.address,
      "priceHour": postingModel.priceHour,
      "priceDay": postingModel.priceDay,
      "priceWeek": postingModel.priceWeek,
      "categoryName": postingModel.categoryName,
      "postingDate": postingModel.postingDate,
      "latitude": postingModel.latitude,
      "longitude": postingModel.longitude,
      "latlng": postingModel.latlng,
      "documentId": postingModel.documentId,
      "documentIdAdd": postingModel.documentId,
      "addPostUserId": postingModel.userId,
      "stripeAccountLink": postingModel.stripeAccountLink,
      "receiverDeviceToken": postingModel.deviceToken,
      "deviceToken": postingModel.deviceToken,
      "userId": postingModel.userId,
      "names": postingModel.names,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    //  await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);

    try {
      DocumentReference reference = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("my_wishlist")
          .add(data);
      print("reference id " + reference.id);
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);

      print("errrr " + e.toString());
    }
  }

  Future<void> unFavourite(String documentId) async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("my_wishlist")
          .where("documentId", isEqualTo: documentId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("my_wishlist")
              .doc(element.id)
              .delete()
              .then((value) {
            print("Success!");
          });
        });
      });
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);

      print("errrr " + e.toString());
    }
  }
}
