import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';


import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/CancelBookingRequest.dart';
import 'package:bizitme/Models/CancelBookingResponse.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/CancellationPolicy.dart';
import 'package:bizitme/Screens/MyBookingPage.dart';
import 'package:bizitme/Screens/MyOrdersListPage.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/SingleChat/ChatScreen.dart';
import 'package:bizitme/SingleChat/Peoples.dart';
import 'package:bizitme/Utils/Colors.dart';
import 'package:bizitme/repository/common_repository.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CancellationPolicyPage.dart';
import 'package:bizitme/Models/SendNotficationRequestModel.dart';
import 'package:http/http.dart' as http;
import 'package:bizitme/global.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CancelBookingPage extends StatefulWidget {
  final String id;
  final String receiverDeviceToken;
  final String transaction_id;
  final String calculatedAmount;
  final String title;
  final String description;
  final String location;
  final String priceHour;
  final String priceDay;
  final String priceWeek;
  final String categoryName;
  final String postingDate;
  final String latitude;
  final String longitude;
  final String latlng;
  final String bookingForStatus;
  final String fromDate;
  final String toDate;
  final String endTime;
  final String startTime;
  final String noOfHour;
  final String userEmail;
  final String click;
  final String userId;
  final String documnetId;
  final String cancellationPost;
  final String totalAmount;
  final String refundAmount;
  final String cancellationDate;
  final String compareDocID;
  final String checkDocumentId;
  final String subCategories;
  final String compareTime;
  final String ratingStatus;
  final List<String> names;
  final List<String> documentId;


  CancelBookingPage({Key key, this.id,this.receiverDeviceToken, this.transaction_id,this.calculatedAmount,this.title, this.description, this.location, this.priceDay
    ,this.priceWeek, this.priceHour, this.categoryName, this.names, this.postingDate, this.documentId, this.latitude,
    this.longitude, this.latlng, this.bookingForStatus, this.fromDate, this.toDate, this.startTime, this.endTime,
    this.noOfHour, this.userEmail, this.click, this.userId, this.documnetId, this.cancellationPost, this.totalAmount,
    this.refundAmount, this.cancellationDate, this.compareDocID, this.checkDocumentId, this.subCategories, this.compareTime, this.ratingStatus}) : super(key: key);

  @override
  _CancelBookingPageState createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  String confirm = "0";
  String complete ="1";
  String Cancel ="2";

  String emailId = "";
  String token = "";
  String name = "";
  String profilePicture = "";
  ProgressDialog _progressDialog = new ProgressDialog();

  List<String> names = new List();
  String documnetId ="";
  String calculatedAmount ="";
  String transaction_id ="";
  String todaysDate = "";
  DateTime now = new DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String Hour, minute, _time;
  String showStartTime = "";
  String showEndTime  ="";
  String currentTime = "";
  String hideCancelBtn = "1";
  TimeOfDay selectedTimeNew = TimeOfDay(hour: 00, minute: 00);

  double complete_rating = 1;
  final TextEditingController txtReview = new TextEditingController();
  String str_userName = "";


  void getImage(){
    names.clear();
    for(int i=0; i< widget.names.length; i++){
      print("IMAGES NAME "+widget.names[i]);
      names.add(widget.names[i]);
    }
  }


  void
  sixHourValidation(){

    {
      String getHour = widget.compareTime.substring(0,2);
      print("GET TWO LETTER : "+getHour);

      String getMinuite = widget.compareTime.substring(3,5);
      String getAMPM = widget.compareTime.substring(5,8);
      print("GET TWO LETTER : "+getMinuite);
      print("getAMPM : "+getAMPM);



      String finalTime = formatDate(
          DateTime(2020, 08, 1, int.parse(getHour), int.parse(getMinuite)),
          [hh, ':', nn, " ", getAMPM.trim()]).toString();

      print("FINAL TIME :"+finalTime);


      var format = DateFormat("HH:mm a");
      var one = format.parse(currentTime);
      var two = format.parse(finalTime);
      print("${two.difference(one)}");

      if(one.isBefore(two)){
        hideCancelBtn = "1";
        setState(() {});
      }else{
        hideCancelBtn = "0";
        setState(() {});
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    documnetId=widget.documnetId;
    calculatedAmount=widget.calculatedAmount;
    transaction_id=widget.transaction_id;
    // TODO: implement initState
    getImage();
    getProfile();
    getProfileData();

    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    todaysDate = formattedDate;
    print(formattedDate);

    currentTime = DateFormat('hh:mm a').format(DateTime.now());
    //  print("TIME NOW : "+currentTime);


    /// check for rating
    if( widget.bookingForStatus == "Hour")
    {
      /// check using from date

      var now = new DateTime.now();
      var formatter = new DateFormat('MM/dd/yyyy');
      var formattedDate = formatter.format(now);
      print(formattedDate); // 2016-01-25

      DateTime currentparseDate =
      new DateFormat("MM/dd/yyyy").parse(formattedDate);
      var curretnDate = DateTime.parse(currentparseDate.toString());



      DateTime parseDate =
      new DateFormat("MM/dd/yyyy").parse( widget.fromDate);
      var fromdDate = DateTime.parse(parseDate.toString());

      // var outputFormat = DateFormat('yyyy-MM-dd');
      // var outputDate = outputFormat.format(fromdDate);
      // print(outputDate);

      if(curretnDate.isAfter(fromdDate)==true)
      {
// show Rating..
        print(" show Rating");

        if(widget.ratingStatus=="False")
        {
          Future.delayed(Duration.zero, () async {
            _ShowDialog_rating(context);
          });
        }
        hideCancelBtn = "0";
      }


      if(curretnDate.isAtSameMomentAs(fromdDate)==true)
      {
        hideCancelBtn = "0";
      }

    }
    else
    {
      // check from todate

      var now = new DateTime.now();
      var formatter = new DateFormat('MM/dd/yyyy');
      var formattedDate = formatter.format(now);
      print(formattedDate); // 2016-01-25

      DateTime currentparseDate =
      new DateFormat("MM/dd/yyyy").parse(formattedDate);
      var curretnDate = DateTime.parse(currentparseDate.toString());


      DateTime parseDate =
      new DateFormat("MM/dd/yyyy").parse( widget.toDate);
      var toDate = DateTime.parse(parseDate.toString());


      if(curretnDate.isAfter(toDate)==true)
      {
// show Rating..
        print(" show Rating");

        if(widget.ratingStatus=="False")
        {
          Future.delayed(Duration.zero, () async {
            _ShowDialog_rating(context);
          });
        }

        hideCancelBtn = "0";
      }

      if(curretnDate.isAtSameMomentAs(toDate)==true)
      {
        hideCancelBtn = "0";
      }

    }

    // Future.delayed(Duration.zero, () async {
    //   _ShowDialog_rating(context);
    // });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      from_mybooking=false;

      setState(() {
        if(widget.click == "Order"){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '3',)));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyBookingPage()));
        }

      });
    },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName,style: TextStyle(fontSize: 20,fontFamily: "Montserrat",),textAlign: TextAlign.center),
          centerTitle: true,
          backgroundColor:  Color(0xff4996f3),
          leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
            onPressed: (){
              from_mybooking=false;

              if(widget.click == "Order"){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '3',)));
              }else{
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyBookingPage()));
              }
            },
          ),
          // actions: [
          //   IconButton(icon: new Image.asset('assets/Images/delete_img.png',height: 20,width: 20,),
          //       onPressed: (){
          //        // _ShowBottomSheet_warningPage();
          //
          //       }),
          // ],
        ),

        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child:Column(
                children: [
                  SizedBox(
                      height: 200.0,
                      width: 420.0,
                      child: Carousel(
                        images: names.map((e) => Container(
                          child: Image.network(e),
                        )).toList(),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8,right: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          children: [
                            widget.click == "Order"
                                ? Container(
                              width:MediaQuery.of(context).size.width * 0.70,
                              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 3),
                              child:  Text('Customer Details',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: "Montserrat",
                                    color: Colors.black),),
                            )
                                :Container(),
                            widget.click == "Order"
                                ?
                            Container(
                              width:MediaQuery.of(context).size.width * 0.70,
                              margin: EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 0),
                              child:  Text(widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Montserrat",
                                    color: Colors.black),),
                            )
                                :Container(
                              width:MediaQuery.of(context).size.width * 0.70,
                              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                              child:  Text(widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Montserrat",
                                    color: Colors.black),),
                            ),

                            widget.click == "Order"
                                ? Container(
                              width:MediaQuery.of(context).size.width * 0.70,
                              margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 15),
                              child:  Text("Email Id :"+widget.userEmail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontFamily: "Montserrat",
                                    color: Colors.black),),
                            )
                                :Container(),

                          ],
                        ),
                        InkWell(
                            onTap: (){
                              checkUserToken();
                              setState(() {});
                            },
                            child:   Container(
                              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
                              child: Image.asset('assets/Images/chat.png',height: 28,width: 28,),
                            )
                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15),
                          width: MediaQuery.of(context).size.width*0.49,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Text('Category',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',),),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/Images/rv_category.png',height: 16,width: 16,),
                                  Padding(padding: EdgeInsets.only(left: 3),),
                                  Text(widget.categoryName,style: TextStyle(color: Colors.black,fontSize: 14),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 2),),

                      ],
                    ),
                  ),


                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.01 ),
                        //  width: MediaQuery.of(context).size.width *0.80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sub Category',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Montserrat_Medium',
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/Images/rv_category.png',
                                  height: 18,
                                  width: 18,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 3),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width* 0.90,
                                  child:  Text(
                                    widget.subCategories == null?"NA": widget.subCategories,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.black, fontSize: 14,),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),


                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.bookingForStatus == "Hour"
                          ?Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('No.of hours',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/per_hour.png',height: 15,width: 15,),
                                Padding(padding: EdgeInsets.only(left: 3),),
                                Text(widget.noOfHour,style: TextStyle(color: Colors.black,fontSize: 14),),
                              ],
                            ),
                          ],
                        ),
                      ),)
                          :Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('From Date',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/date.png',height: 15,width: 15,),
                                Padding(padding: EdgeInsets.only(left: 3),),
                                Text(widget.fromDate,style: TextStyle(color: Colors.black,fontSize: 14),),
                              ],
                            ),
                          ],
                        ),
                      ),),

                      widget.bookingForStatus == "Hour"
                          ? Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Date',style: TextStyle(color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 10),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/date.png',height: 12,width: 16,),
                                Text(widget.fromDate,style: TextStyle(fontSize: 13,fontFamily: "Montserrat",fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),)
                          :Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('To Date',style: TextStyle(color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 10),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/date.png',height: 12,width: 16,),
                                Text(widget.toDate,style: TextStyle(fontSize: 13,fontFamily: "Montserrat",fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),)
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.bookingForStatus == "Hour"
                          ? Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15, top: 3),
                        width: MediaQuery.of(context).size.width*0.49,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Start Time',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/time.png',height: 13,width: 15,),
                                Padding(padding: EdgeInsets.only(left: 3),),
                                Text(widget.startTime,style: TextStyle(color: Colors.black,fontSize: 14),),
                              ],
                            ),
                          ],
                        ),
                      ),)
                          :Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15, top: 3),
                        width: MediaQuery.of(context).size.width*0.49,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Time',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/time.png',height: 13,width: 15,),
                                Padding(padding: EdgeInsets.only(left: 3),),
                                Text(widget.startTime,style: TextStyle(color: Colors.black,fontSize: 14),),
                              ],
                            ),
                          ],
                        ),
                      ),),

                      widget.bookingForStatus == "Hour"
                          ? Expanded(child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15, top: 3),
                        width: MediaQuery.of(context).size.width*0.50,
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('End Time',style: TextStyle(color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 10),),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/Images/time.png',height: 13,width: 15,),
                                Padding(padding: EdgeInsets.only(left: 3),),
                                Text(widget.endTime,style: TextStyle(color: Colors.black,fontSize: 14),),
                              ],
                            ),
                          ],
                        ),
                      ),)
                          :Container()
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15, top: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 0,bottom: 0,top: 0),
                        ),

                        Text('Price',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',),),
                        SizedBox(
                          height: 4,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/Images/price.png',height: 14,width: 16,),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        widget.bookingForStatus == "Hour"
                                            ? Text('\$'+widget.priceHour+"/Hour",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,fontFamily: 'Montserrat'),)
                                            : widget.bookingForStatus == "Day"
                                            ?Text('\$'+widget.priceDay+"/Day",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,fontFamily: 'Montserrat'),)
                                            :Text('\$'+widget.priceWeek+"/Week",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,fontFamily: 'Montserrat'),),
                                        Padding(
                                          padding: EdgeInsets.only(left: 0.0,right: 0,bottom: 0,top: 5),
                                        ),
                                        Text(' (Price inclusive for all taxes)',style: TextStyle(color: Colors.black,fontSize: 10,
                                          fontFamily: 'Montserrat',),textAlign: TextAlign.start,),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width ,
                    margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15, top: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text('Description',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 0,bottom: 0,top: 5),
                        ),
                        Text(widget.description,
                          style: TextStyle(fontSize: 10,fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 10,  bottom: 15, top: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location',style: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Montserrat',
                        ),),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 0,bottom: 0,top: 8),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap:(){
                                openMap();
                                setState(() {});
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child:  Text(widget.location,
                                  style: TextStyle(fontSize: 12,fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                            ),
                            Image.asset('assets/Images/location.png',height: 10,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  widget.cancellationPost != "Cancelled"
                      ? RaisedButton(
                    elevation: 7.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    onPressed: (){
                      if(hideCancelBtn == "1"){
                        _ShowBottomSheet_warningPage();
                      }

                    },
                    padding: EdgeInsets.symmetric(horizontal: 90,vertical: 10),
                    color: hideCancelBtn == "1"?Color(0xff4996f3):Colors.grey,
                    splashColor: hideCancelBtn == "1"?Color(0xff4996f3):Colors.grey,

                    child: Text('Cancel Booking',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Montserrat'),),
                  )
                      :Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.001,
                          color:Colors.blue,
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          child:    Row(
                            children: [
                              Text("Cancellation Date :",style: TextStyle(color: Colors.grey,
                                  fontSize: 11,fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold),),
                              SizedBox(width: 4,),
                              Text(widget.cancellationDate == null ?"NA":widget.cancellationDate,style: TextStyle(color: Colors.black,fontSize: 11,fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),


                        Container(
                          margin: EdgeInsets.only(top: 7, bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text("Total Amount :",style: TextStyle(color: Colors.grey,
                                        fontSize: 11,fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold),),
                                    SizedBox(width: 4,),
                                    Text('\$'+ widget.totalAmount,style: TextStyle(color: Colors.black,fontSize: 11,fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    Text("Refund Amount :",style: TextStyle(color: Colors.grey,
                                        fontSize: 11,fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold),),
                                    SizedBox(width: 4,),
                                    Text('\$'+ widget.refundAmount,style: TextStyle(color: Colors.black,fontSize: 11,fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.80,
                              child:  Text("Note : Refund amount will be credited in next 48 hours to your credit card",
                                maxLines: 3,
                                style: TextStyle(color: Colors.grey,
                                    fontSize: 11,fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  widget.cancellationPost != "Cancelled"
                      ? FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CancellationPolicy()));
                    },
                    child: Text('Cancellation Policy',style: TextStyle(color: Color(0xff2196f3),fontSize: 12,fontFamily:'Montserrat' ),
                    ),
                  )
                      :Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),);
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
                      child: Image.asset("assets/Images/cancel_booking.png"
                        ,fit: BoxFit.contain,
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
                      'Are you sure want to cancel this booking ?',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Text("Back"),
                        ),
                      ),

                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.pop(context);
                            if(widget.click == "Order"){
                              CancelBooking();
                            }else{
                              CancelBookingApi();
                            }

//                            CancelBooking();

                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Continue"),
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

  void CancelBookingApi()async{
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    CancelBookingRequest bookingPaymentRequest = new CancelBookingRequest();
    bookingPaymentRequest.payId = documnetId;
    bookingPaymentRequest.amount = calculatedAmount;
    bookingPaymentRequest.transactionId = transaction_id;

    CancelBookingResponse bookingPaymentResponse = await cancelBookingRef(bookingPaymentRequest);
    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    if(bookingPaymentResponse == null){
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Something went wrong, Please try again',
            description: "",
            my_context: context,
          ));
    }
    else if(bookingPaymentResponse.status == "1"){
      print("SUCCESS");
      CancelBooking();

    }else{
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            // title: '' + responseData.msg,
            title: 'No Data Available',
            description: "",
            my_context: context,
          ));
    }
  }


  Future<void> openMap() async {
    String lat = widget.latitude;
    String long = widget.longitude;
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + lat + ',' + long + '&travelmode=driving&dir_action=navigate';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }


  void checkUserToken() async{
    String emailmain =
    await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
    print(emailmain);

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading your chat...', dismissAfter: null);
    }

    QuerySnapshot cars;
    cars = await FirebaseFirestore
        .instance
        .collection(
        'users')
        .get();
    final List<DocumentSnapshot> documents = cars.docs;

    if (cars != null) {

      for (int i = 0; i <documents.length; i++) {
        String emailfb = documents[i]['email'];

        if (documents[i].reference.id ==widget.userId) {


          String displayName = name;

          String device_token =  documents[i]['device_token'];

          UsersData userData = new UsersData();
          userData.strEmailId = emailId;
          userData.strName = displayName;
          userData.fcmToken = device_token;
          userData.instrument_id =  widget.documnetId;
          userData.strprofilepicture = profilePicture;
          userData.title = widget.title;

          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;

          //navivagetoChatScreen(context,userData);
          Route route = MaterialPageRoute(builder: (context) => ChatScreen(userData));
          var nav = await Navigator.of(context).push(route);
          if (nav == true || nav == null) {

          }
          break;
        }
      }
    }




  }



  Future<void> getProfileData() async {

    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();
        print(document.id);
        String primaryKeyValue = values['address'];

        if(document.id == widget.userId){

          setState(() {
            // name =  values['firstName'];
            name = values['firstName'] +" "+ values['lastName'];
            profilePicture = values['image'];
            print("IMAGE URL : "+profilePicture);
            emailId = values['email'];
            token = values['device_token'];

          });
        }
      });

    });
    setState(() {});
  }

  String deviceToken;

  Future<String> getDeviceToken() async {

    deviceToken = await FirebaseMessaging.instance.getToken();
    print("DEVICE ID : " +deviceToken);
    return deviceToken;
  }



  void CancelBooking()async{
    String emailmain =
    await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
    print(emailmain);

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print("Booking user idf "+user.uid);

    PostingModel posting = PostingModel();

    posting.transaction_id = "fgfg";

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
    posting.imageNames = widget.names;
    posting.categoryName = widget.categoryName;
    posting.postingDate = widget.postingDate;
    posting.latitude = widget.latitude;
    posting.longitude = widget.longitude;
    posting.latlng = widget.latlng;
    posting.bookingStatus ="Cancelled";
    posting.fromDate = widget.fromDate;
    posting.toDate = widget.toDate;
    posting.startTime = widget.startTime;
    posting.endTime = widget.endTime;
    posting.noOfHour = widget.noOfHour;
    posting.bookingForStatus = "";
    posting.userEmail = emailmain ;
    posting.calculatedAmount = widget.calculatedAmount;
    posting.documentId = widget.documnetId;
    posting.userId = widget.userId;
    posting.userBookingId = user.uid;

    String docId = widget.documnetId;
    String id =widget.id;
    // print("docId== "+docId);
    //  print("id== "+id);
    // print("userid== "+ widget.userId);




    if(from_mybooking==true)
    {
      // froom my booking page
      posting.CANCELBOOKINGFirestore(widget.id, todaysDate).whenComplete(() {
        posting.CancelMyOrderInfoInFirestore(docId,widget.userId, todaysDate).whenComplete(() {
          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;
          bookingDateFilterList();
          sendNotf("Bizitme",widget.title+" post is cancelled");
          _ShowBottomSheet_success();
        });
      });
    }
    else
    {
      // froom my orders page

      posting.CANCELBOOKINGFirestore2(widget.userId,docId,todaysDate).whenComplete(() {
        posting.CancelMyOrderInfoInFirestore2(docId,widget.id,todaysDate).whenComplete(() {
          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;
          bookingOrderDateFilterList();
          sendNotf("Bizitme",widget.title+" post is cancelled");
          _ShowBottomSheet_success();
        });
      });

    }




    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;
    sendNotf("Bizitme",widget.title+" post is cancelled");
    _ShowBottomSheet_success();
  }


  Future sendNotf(String title, String body1) async {
    // String strSenderToken = await SHDFClass.readSharedPrefString(AppConstants.Token, "");

    final String serverToken = "AAAACnjnL0U:APA91bGDnroPSh5vXZRrPvG1-cUS7V6pK6ic0SLRAJLrauNjvIqpLi_UJcuIGxm5aXnJGMcpZkSsMhRL0wU5PbZ-gVCSqVVsORNB-Hvxflquc3-R2uTR5GHL43m7Jw5AEUz4q9GQedG0";

    SendNotficationRequestModel sendNotficationRequestModel = new SendNotficationRequestModel();
    sendNotficationRequestModel.to = widget.receiverDeviceToken;
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
    data.reciver_token = widget.receiverDeviceToken;
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
            'Authorization': "key=AAAACnjnL0U:APA91bGDnroPSh5vXZRrPvG1-cUS7V6pK6ic0SLRAJLrauNjvIqpLi_UJcuIGxm5aXnJGMcpZkSsMhRL0wU5PbZ-gVCSqVVsORNB-Hvxflquc3-R2uTR5GHL43m7Jw5AEUz4q9GQedG0",
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

  //SUCCESS DIALOG
  void _ShowBottomSheet_success() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
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
                      child: Image.asset("assets/Images/Success.png"
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
                      'Congratulations, your booking is cancelled',
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
                        if(from_mybooking==true)
                        {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyBookingPage(showCancleTab: "1",)));
                        }
                        else
                        {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '3')));

                        }

                        setState(() {});
                        // Navigator.pushNamed(context, LoginPage.routeName);

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
                      color: Colors.red,
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


  String deleteDateDocId = "";
  Future<void> bookingDateFilterList() async {

    String docId = widget.compareDocID;
    Query query = FirebaseFirestore.instance.collection('all_post').doc(docId).collection("booking_dates");
    print(query);

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();


        String bookingId = values['idBooking'];

        if(bookingId == widget.checkDocumentId){
          print("TRUE");
          deleteDateDocId = document.id;
          print(document.id);
          await FirebaseFirestore.instance.collection('all_post').doc(docId).collection("booking_dates").doc(deleteDateDocId).delete();
        }

      });

    });

  }

  Future<void> bookingOrderDateFilterList() async {

    String docId = widget.compareDocID;
    Query query = FirebaseFirestore.instance.collection('all_post').doc(docId).collection("booking_dates");
    print(query);

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();


        String bookingId = values['idOrder'];

        if(bookingId == widget.checkDocumentId){
          print("TRUE");
          deleteDateDocId = document.id;
          print(document.id);
          await FirebaseFirestore.instance.collection('all_post').doc(docId).collection("booking_dates").doc(deleteDateDocId).delete();
        }

      });

    });

  }


  Future<void> deleteDates() async {
    PostingModel posting = PostingModel();

    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    posting.deleteListDateInfoInFirestore(deleteDateDocId).whenComplete(() {
      setState(() {});
    });
  }

  _ShowDialog_rating(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              child: Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                minWidth: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    )),
                                highlightColor: Colors.white,
                                splashColor: Colors.blue.withAlpha(100),
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop();
                                  submitRatingStatus();
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: new Image.asset(
                                    "assets/Images/close_circle.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Container(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white,
                                          width: 0,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      )),
                                  color: Colors.white,
                                  highlightColor: Colors.white,
                                  splashColor: Colors.blue.withAlpha(100),
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  onPressed: () {},
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Image.asset(
                                          // 'assets/images/confirmationpostimg.png',
                                          'assets/Images/submitfeedbackimg.png',
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          height: 150,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  padding:
                                  EdgeInsets.only(top: 15.0, bottom: 15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16.0),
                                        bottomRight: Radius.circular(16.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 0),
                                        child: Text(
                                          "Feedback",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "EuclidCircularA-Bold",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 5, right: 5),
                                        child: new Text(
                                          "Rate your expierence",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                            'EuclidCircularA-Regular',
                                            color: color_darkblue,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 10),
                                            child: RatingBar.builder(
                                              initialRating: complete_rating,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 35.0,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                                complete_rating = rating;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, right: 2, left: 2),
                                        child: Text(
                                          "Write a review (optional)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                            'EuclidCircularA-Regular',
                                            color: color_darkblue,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              bottomRight:
                                              Radius.circular(10.0),
                                            ),
                                            color: colorbacktextbox),
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10, top: 0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.7,
                                              height: 40,
                                              child: TextFormField(
                                                controller: txtReview,
                                                keyboardType:
                                                TextInputType.text,
                                                textInputAction:
                                                TextInputAction.done,
                                                style: TextStyle(
                                                  fontFamily:
                                                  'EuclidCircularA-Regular',
                                                  color: color_darkblue,
                                                  fontSize: 12,
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                    'EuclidCircularA-Light',
                                                    color: colortextboxhint
                                                        .withOpacity(0.5),
                                                    fontSize: 12,
                                                  ),
                                                  hintText: 'Write here',
                                                  counterText: "",
                                                  contentPadding:
                                                  EdgeInsets.only(
                                                      left: 10.0,
                                                      bottom: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.9,
                                          height: 45,
                                          margin:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                          child: Container(
                                            child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: color_darkblue,
                                                      width: 0,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    10,
                                                  )),
                                              color: color_darkblue,
                                              highlightColor: Colors.white,
                                              splashColor:
                                              Colors.blue.withAlpha(100),
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                submitRatingStatus();
                                              },
                                              child: Stack(
                                                overflow: Overflow.visible,
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin:
                                                        EdgeInsets.fromLTRB(
                                                            30, 0, 0, 0),
                                                        child: Text(
                                                          "Submit",
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "EuclidCircularA-SemiBold",
                                                              fontSize: 14,
                                                              letterSpacing: 1,
                                                              color:
                                                              Colors.white),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 30, 0),
                                                        child: Image.asset(
                                                          'assets/Images/rightarrow.png',
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }




  void submitRatingStatus()
  {
    PostingModel posting = PostingModel();
    posting.StoreRatingStatus(widget.id).whenComplete(() {

      posting.StoreRatingAgaintPost(widget.compareDocID,complete_rating.toString(),txtReview.text.toString(),str_userName).whenComplete(() {

        print("StoreRatingAgaintPost");

      });

    });
  }
  getProfile() async {

    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();
        String primaryKeyValue = values['address'];

        String emailmain =
        await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");

        String email = values['email'];

        if(emailmain ==email) {
          setState(() {
            str_userName = values['firstName'] +" "+ values['lastName'];
            email = values['email'];
          });
        }
      });

    });
  }
}
