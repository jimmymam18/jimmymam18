import 'dart:convert';

import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/SendNotficationRequestModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/ListCursorSliderPage.dart';
import 'package:bizitme/Screens/explorePage.dart';
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
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bizitme/Screens/guestHomePage.dart';


class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}


class _WishlistPageState extends State<WishlistPage> {
  List<PostingModel> postList = new List();
  List<PostingModel> categoryList = new List();
  List<PostingModel> userIdList = new List();
  ProgressDialog _progressDialog = new ProgressDialog();
  String userId = "";
  final db = FirebaseFirestore.instance;
  String uid = "";
  String documnetId = "";
  String length = "";
  String latitude = "";
  String longitude =  "";
  static String deviceToken = "";
  static String receiverDeviceToken = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CategoryList();


  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => GuestHomePage()));
            setState(() {});
          },
        child:
        Scaffold(
            appBar: AppBar(
              leading: Padding(padding: EdgeInsets.only(left: 16,top: 18,bottom: 18),
                child: Image.asset('assets/Images/wishlist-w.png',height: 18,width: 20,),),
              titleSpacing: 1,

              title: Text('Wishlist',style: TextStyle(fontSize: 20,fontFamily: "Montserrat",fontWeight: FontWeight.bold)),
              backgroundColor:  Color(0xff4996f3),

            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 5),
              child: length == "1"
                  ?Padding(
                padding: const EdgeInsets.all(1.0),
                child: ListView.builder(
                  itemCount: postList.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int position) {

                    print("title : "+postList[position].categoryName);


//                      doc[position].documentID;

                    return  Container(
                      margin: EdgeInsets.only(bottom: 3),
                      child:  Container(
                        margin: EdgeInsets.only(left: 3,right: 3),
                        child: GestureDetector(
                          child: Card(
                            elevation: 7.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                            ),
                            child:  Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child:  Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    height: 120.0,
                                    width: 120.0,
                                    child:CachedNetworkImage(
                                      imageUrl: postList[position].names[0],
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),

                                  Container(
                                    height: 120.0,
                                    width: MediaQuery.of(context).size.width * 0.62,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child:
                                          Container(
                                            //  width: MediaQuery.of(context).size.width*0.75,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 3),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      Container(
                                                        width:MediaQuery.of(context).size.width * 0.45,
                                                        child: Text(postList[position].title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black,
                                                              fontFamily: "MontSerrat_Medium"),),
                                                      ),

                                                      /*                    postList[position].addedFav?
                                                        Image.asset(
                                                          'assets/Images/favourite_on.png',
                                                          height: 28,
                                                          width: 28,
                                                        )
                                                            :Image.asset(
                                                          'assets/Images/favourite_off.png',
                                                          height: 28,
                                                          width: 28,
                                                        ),
*/
                                                    ],

                                                  ),
                                                ),

                                                Wrap(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 3),
                                                      child: Row(
                                                        children: [
                                                          postList[position].priceHour != "" &&  postList[position].priceHour != null
                                                              ?Expanded(
                                                            flex:postList[position].priceDay == "" ||  postList[position].priceDay == null?0:1,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    child: Image.asset("assets/Images/per_hour.png", fit:BoxFit.fill,scale: 6,)
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height * 0.02,
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.height * 0.11,
                                                                    child: Text("\$"+postList[position].priceHour.toString(),
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue,
                                                                          fontFamily: "MontSerrat_Medium"),),
                                                                  ),)
                                                              ],
                                                            ),)
                                                              :Container(),
                                                          postList[position].priceDay != "" && postList[position].priceDay != null
                                                              ? Expanded(
                                                            flex:postList[position].priceHour == ""  ||  postList[position].priceHour == null?0:1,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    child: Image.asset("assets/Images/per_day.png", scale: 6,)
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height * 0.02,
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.height * 0.11,
                                                                    child: Text("\$"+postList[position].priceDay,
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue,
                                                                          fontFamily: "MontSerrat_Medium"),),
                                                                  ),)
                                                              ],
                                                            ),)
                                                              :Container(),
                                                          postList[position].priceWeek != "" && postList[position].priceWeek != null
                                                              ?Expanded(
                                                            flex:1,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    child: Image.asset("assets/Images/per_week.png", scale: 6,)
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height * 0.02,
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.height * 0.11,
                                                                    child: Text("\$"+postList[position].priceWeek,
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue,
                                                                          fontFamily: "MontSerrat_Medium"),),
                                                                  ),)
                                                              ],
                                                            ),)
                                                              :Container()
                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: 40.0,
                                                  width: MediaQuery.of(context).size.width * 0.99,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(9.0)),
                                                    color: Color(0xffe2f1ff),
                                                  ),
                                                  child: Row(
                                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 8),
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          latitude =  postList[position].latitude;
                                                          longitude =  postList[position].longitude;
                                                          openMap();
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.50,
                                                          child: Text( postList[position].address,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily: "Montserrat",
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 2, right: 3),
                                                      ),
                                                      Image.asset('assets/Images/location.png',height: 10,),
                                                    ],
                                                  ),
                                                ),],
                                            ) ,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                            String addPostUserId = postList[position].userId;
                            String stripeAccountLink = postList[position].stripeAccountLink;
                            String deviceToken = postList[position].deviceToken;
                            String documentIdAdd = postList[position].documentId;
                            String userId = postList[position].userId;
                            receiverDeviceToken = postList[position].deviceToken;

                            List<String> imageList = postList[position].names;

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>
                                    ListCusrsolPage(
                                        from:"wishlist",
                                        title: title, description: description,documentId:documentIdAdd,
                                        location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                        postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,addPostUserId:addPostUserId,
                                        stripeAccountLink:stripeAccountLink, deviceToken:deviceToken,receiverDeviceToken:receiverDeviceToken,
                                        documentIdAdd:documentIdAdd,userId:userId)));
                            setState(() {});

                            //   sendFcmMessage("Bizit-Me", "yOUR POST BOOKED BY SOMEONE");
                            //  sendNotf("Bizit-Me", "yOUR POST BOOKED BY SOMEONE");
                          },
                        ),
                      ),);
                  },
                ),
              ):
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset('assets/Images/wishlist_page.png',height: 120,width: 120,),
                  ),
                  Text("Your Wishlist is empty",style: TextStyle(fontSize: 18,color: Colors.black,
                      fontFamily: "Montserrat",fontWeight: FontWeight.bold),),],
              ),
            )
        )
      );
  }


  Future<void> openMap() async {
    String lat = latitude;
    String long = longitude;
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + lat + ',' + long + '&travelmode=driving&dir_action=navigate';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> CategoryList() async {
    postList.clear();
    length="0";

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    Query query =    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my_wishlist");

    print("query   "+query.toString());
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);

        PostingModel posting = PostingModel();

        String address = values['location'];
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
//        String wishList = values['wishList'];
//        String bookingStatus = values['bookingStatus'];
        String userId = values['userId'];
        String stripeAccountLink = values['stripeAccountLink'];
        String deviceToken = values['deviceToken'];
        String documentID = values['documentId'];

        posting.names = List.from(document['names']);
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
        posting.wishList = "";
        posting.bookingStatus = "";
        posting.userId = userId;
        posting.stripeAccountLink = stripeAccountLink;
        posting.deviceToken = deviceToken;
        posting.documentId = documentID;
        posting.addedFav = true;


        postList.add(posting);

      });

      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;


      if(postList.length>0){
          length = "1";
      }

      setState(() {

      });

    });
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

    try
    {

      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("my_wishlist")
          .where("documentId", isEqualTo :documentId)
          .get().then((value){
        value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("users")
              .doc(user.uid)
              .collection("my_wishlist").doc(element.id).delete().then((value){

            print("Success!");
            CategoryList();

          });
        });
      });

    }
    catch(e)
    {

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

      print("errrr "+e.toString());
    }

  }

}
