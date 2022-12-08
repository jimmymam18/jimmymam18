
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/CancelBookingPage.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizitme/global.dart';

final List<String> _spaceTypes = [
  'Gold Salon and Spa',
];



class MyBookingPage extends StatefulWidget {
  final String switchPage;
   String showCancleTab;

  MyBookingPage({Key key, this.switchPage, this.showCancleTab}) : super(key: key);

  @override
  _MyBookingPageState createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {

  bool confirmbooking =true;
  bool compltebooking =false;
  bool cancelbooking =false;

  bool confirm_color=true;
  bool completed_color=false;
  bool cancelled_color=false;

  int confirmed_complete_cancel =0;

  ProgressDialog _progressDialog = new ProgressDialog();
  List<PostingModel> postList = new List();
  List<PostingModel> allPostList = new List();
 String latitude = "";
  String  longitude = "";
  final db = FirebaseFirestore.instance;
  String currentUserId = "";


  @override
  void initState(){
    super.initState();

    CategoryList();
    //bookingList();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    currentUserId = user.uid;
    print(user.uid);

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      if(widget.switchPage == "1"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '4')));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '0')));
      }
      setState(() {});
    },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
            onPressed: (){
              if(widget.switchPage == "1"){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '4')));
              }else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '0')));
              }
              setState(() {});
            },),
          title: Text('My Booking',style: TextStyle(fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,fontFamily: "montserrat"),),
          backgroundColor:  Color(0xff4996f3),
          centerTitle: true,),

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height:3,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex:1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                        margin: EdgeInsets.only(left: 7, right:4),
                        child: RaisedButton(
                          onPressed: (){
                            confirmbooking =true;
                            compltebooking =false;
                            cancelbooking =false;

                            if(confirm_color==true)
                            {
                            //  confirm_color=false;
                            }
                            else
                            {
                              confirm_color=true;
                              completed_color = false ;
                              cancelled_color = false ;
                              widget.showCancleTab = null;
                            }

                            setState(() {
                              //confirmBookingListView();
                            });

                          },
                          color: confirm_color && widget.showCancleTab == null?Color(0xff4996f3):Colors.white,
                          // textColor: Colors.blue,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xff4996f3),width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Confirmed",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,
                            color: confirm_color  && widget.showCancleTab == null?Colors.white:Color(0xff4996f3),
                          )),
                        ),
                      ),),

                    Expanded(
                      flex:1,
                      child:  Container(
                        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                        margin: EdgeInsets.only(left: 4, right:7),
                        child: RaisedButton(
                          onPressed: (){
                            confirmbooking =false;
                            compltebooking =false;
                            cancelbooking =true;

                            if(cancelled_color==true)
                            {
                             // cancelled_color=false;

                            }
                            else
                            {
                              cancelled_color=true;
                              confirm_color = false ;
                              completed_color = false ;
                            }

                            //confirmed_complete_cancel ="2";
                            setState(() {
                              //cancelledBookingListView();

                            });
                          },
                          color:cancelled_color == true?Color(0xff4996f3)
                              :widget.showCancleTab != null?Color(0xff4996f3):Colors.white,
                          //textColor: Colors.blue,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xff4996f3),width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Cancelled",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,

                            color: cancelled_color==true ?Colors.white
                                :widget.showCancleTab != null?Colors.white:Color(0xff4996f3),)),
                        ),
                      ),)

                  ],
                ),
              ),

              //Listview start here
              postList.isNotEmpty
              ?Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: confirmbooking ==true && widget.showCancleTab == null?
                  StreamBuilder<QuerySnapshot>(
                    stream: db.collection('users').doc(currentUserId).collection("my_booking").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var doc = snapshot.data.docs;
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: postList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int position) {
                              //var parseDate = Jiffy(postList[position].fromDate, "dd-MMM-yyyy");
                              var parseMonth ;
                              var parseDate ;
                              var parseYear;
                              if(postList[position].fromDate != null){
                                 parseMonth = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("MMM");
                                 parseDate = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("dd");
                                 parseYear = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("yyyy");
                                print(parseMonth);
                              }

                              return postList[position].bookingStatus == "Confirmed"
                                  ?Padding(
                                padding: EdgeInsets.only(left: 6,right: 6),
                                child: GestureDetector(
                                  child: Card(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                      ),
                                      child:  Wrap(
                                        children: [
                                          Row(
                                            children:[
                                              Container(
                                                width: 252.0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(6.0),
                                                      child:  Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left:2.0),
                                                            width:MediaQuery.of(context).size.width * 0.60,
                                                            child: Text(postList[position].title,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black,
                                                                  fontFamily: "Montserrat"),),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            child:  Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child:
                                                                postList[position].bookingForStatus == "Hour"
                                                                    ? Row(
                                                                  children: [
                                                                    Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                                        ,fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].noOfHour,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                )
                                                                    :Row(
                                                                  children: [
                                                                    Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                                        ,fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                                ),
                                                                Expanded(child:
                                                                Row(
                                                                  children: [
                                                                    Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                                        fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                                )
                                                              ],
                                                            ),
                                                            padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child:
                                                                postList[position].bookingForStatus == "Hour"
                                                                    ? Row(
                                                                  children: [
                                                                    Text("Date :",style: TextStyle(color: Colors.grey,
                                                                        fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                )
                                                                    :Row(
                                                                  children: [
                                                                    Text("To Date :",style: TextStyle(color: Colors.grey,
                                                                        fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].toDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                                ),
                                                                Expanded(child:
                                                                postList[position].bookingForStatus == "Hour"
                                                                    ? Row(
                                                                  children: [
                                                                    Text("End Time :",style: TextStyle(color: Colors.grey,
                                                                        fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                )
                                                                    :Container(),
                                                                )

                                                              ],
                                                            ), ),

                                                          Container(
                                                            margin: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 0),
                                                            child: Row(
                                                              children: [
                                                                Text("Total Amount:",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                                    fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                                SizedBox(width: 4,),
                                                                Text("\$"+postList[position].calculatedAmount,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                    fontWeight: FontWeight.w500),),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      height: 40.0,
                                                      margin: EdgeInsets.only(left: 9,right: 8,top: 2),

                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.0),
                                                          bottomLeft: Radius.circular(10.0),),
                                                        color: Color(0xfff8fcff),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              latitude = postList[position].latitude;
                                                              longitude = postList[position].longitude;
                                                              openMap();
                                                              setState(() {});
                                                            },
                                                            child:  Container(
                                                              width:MediaQuery.of(context).size.width * 0.60,
                                                              child: Text(postList[position].address,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: 10,
                                                                    fontFamily: "Montserrat",
                                                                    //fontWeight: FontWeight.w500,
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: (){
                                                              latitude = postList[position].latitude;
                                                              longitude = postList[position].longitude;
                                                              openMap();
                                                            },
                                                            child: Image.asset('assets/Images/add_location.png',height: 14,
                                                              width: 15,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration:BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                                                    bottomLeft: Radius.circular((10.0),),topRight: Radius.circular(10.0),
                                                    bottomRight: Radius.circular(10.0),
                                                  ),
                                                  color: Color(0xffe2f1ff),
                                                ),
                                                height: 110.0,
                                                width: 84.0,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(parseMonth.toString(),style: TextStyle(fontSize: 16,color: Colors.black,
                                                        fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(parseDate.toString(),style: TextStyle(fontSize: 20,color: Colors.black,
                                                        fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(parseYear.toString(),style: TextStyle(fontSize: 16,color: Colors.black,
                                                        fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                  onTap: (){

                                    from_mybooking=true;

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
                                    String bookingForStatus = postList[position].bookingForStatus;
                                    String fromDate = postList[position].fromDate;
                                    String toDate = postList[position].toDate;
                                    String startTime = postList[position].startTime;
                                    String endTime = postList[position].endTime;
                                    String noOfHour = postList[position].noOfHour;
                                    String userId = postList[position].userId;
                                    String documnetId = postList[position].documentId;
                                    String calculatedAmount = postList[position].calculatedAmount;
                                    String transaction_id = postList[position].transaction_id;
                                    String receiverDeviceToken = postList[position].receiverDeviceToken;
                                    String id = postList[position].id;
                                    String compareDocID = postList[position].compareDocID;
                                    String subCategories = postList[position].subCategories;
                                    String compareTime = postList[position].compareTime;

                                    List<String> imageList = postList[position].names;


                                    print(doc[position].id);
                                   String checkDocumentId = doc[position].id;

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                                              location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                              postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                                              fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,
                                              userId:userId,documnetId:documnetId,checkDocumentId:checkDocumentId,compareDocID:compareDocID
                                            ,subCategories:subCategories, compareTime:compareTime,)));
                                    setState(() {});
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>CancelBookingPage()));

                                  },
                                ),

                              )
                                  :Container();

                            });
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  )
                      :StreamBuilder<QuerySnapshot>(
                    stream: db.collection('all_post').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var doc = snapshot.data.docs;
                       return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: postList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int position) {
                              var parseMonth ;
                              var parseDate ;
                              var parseYear;
                              if(postList[position].fromDate != null){
                                parseMonth = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("MMM");
                                parseDate = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("dd");
                                parseYear = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("yyyy");
                                print(parseMonth);
                              }
                              double amount;
                              if(postList[position].bookingStatus == "Cancelled"){
                                amount = double.parse(postList[position].calculatedAmount)-(20*double.parse(postList[position].calculatedAmount))/100;
                                print("CAALCULATED AMOUNT "+amount.toString());
                              }


                              return postList[position].bookingStatus == "Cancelled"
                                  ?Padding(
                                padding: EdgeInsets.only(left: 6,right: 6),
                                child: GestureDetector(
                                  child: Card(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                      ),
                                      child:  Wrap(
                                        children: [
                                          Row(
                                            children:[
                                              Container(
                                                width: 252.0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(6.0),
                                                      child:  Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left:2.0),
                                                            width:MediaQuery.of(context).size.width * 0.60,
                                                            child: Text(postList[position].title,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black,
                                                                  fontFamily: "Montserrat"),),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            child:  Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child:
                                                                postList[position].bookingForStatus == "Hour"
                                                                    ? Row(
                                                                  children: [
                                                                    Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                                        ,fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].noOfHour,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                )
                                                                    :Row(
                                                                  children: [
                                                                    Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                                        ,fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                                ),
                                                                Expanded(child:
                                                                Row(
                                                                  children: [
                                                                    Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                                        fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                                )
                                                              ],
                                                            ),
                                                            padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child:
                                                                postList[position].bookingForStatus == "Hour"
                                                                    ? Row(
                                                                  children: [
                                                                    Text("Date :",style: TextStyle(color: Colors.grey,
                                                                        fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                )
                                                                    :Row(
                                                                  children: [
                                                                    Text("To Date :",style: TextStyle(color: Colors.grey,
                                                                        fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].toDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                                ),
                                                                Expanded(child:
                                                                postList[position].bookingForStatus == "Hour"
                                                                    ? Row(
                                                                  children: [
                                                                    Text("End Time :",style: TextStyle(color: Colors.grey,
                                                                        fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 4,),
                                                                    Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                        fontWeight: FontWeight.w500),),
                                                                  ],
                                                                )
                                                                    :Container(),
                                                                )

                                                              ],
                                                            ), ),

                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:   Container(
                                                                  margin: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text("Total Amount:",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                                          fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                                      SizedBox(width: 4,),
                                                                      Text("\$"+postList[position].calculatedAmount,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                          fontWeight: FontWeight.w500),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                              postList[position].bookingStatus == "Cancelled"
                                                                  ? Expanded(
                                                                child:
                                                                Container(
                                                                  margin: EdgeInsets.only(left: 0,right: 5,top: 5,bottom: 0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text("Refund Amount:",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                                          fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                                      SizedBox(width: 4,),
                                                                      Text("\$"+amount.round().toString(),style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                          fontWeight: FontWeight.w500),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                                  :Container(),
                                                            ],
                                                          )


                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      height: 40.0,
                                                      margin: EdgeInsets.only(left: 9,right: 8,top: 2),

                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.0),
                                                          bottomLeft: Radius.circular(10.0),),
                                                        color: Color(0xfff8fcff),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              latitude = postList[position].latitude;
                                                              longitude = postList[position].longitude;
                                                              openMap();
                                                              setState(() {});
                                                            },
                                                            child:  Container(
                                                              width:MediaQuery.of(context).size.width * 0.60,
                                                              child: Text(postList[position].address,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: 10,
                                                                    fontFamily: "Montserrat",
                                                                    //fontWeight: FontWeight.w500,
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: (){
                                                              latitude = postList[position].latitude;
                                                              longitude = postList[position].longitude;
                                                              openMap();
                                                            },
                                                            child: Image.asset('assets/Images/add_location.png',height: 14,
                                                              width: 15,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration:BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                                                    bottomLeft: Radius.circular((10.0),),topRight: Radius.circular(10.0),
                                                    bottomRight: Radius.circular(10.0),
                                                  ),
                                                  color:Colors.red,
                                                ),
                                                height: 110.0,
                                                width: 84.0,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(parseMonth.toString(),style: TextStyle(fontSize: 16,color: Colors.white,
                                                        fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(parseDate.toString(),style: TextStyle(fontSize: 20,color: Colors.white,
                                                        fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(parseYear.toString(),style: TextStyle(fontSize: 16,color: Colors.white,
                                                        fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
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
                                    String bookingForStatus = postList[position].bookingForStatus;
                                    String fromDate = postList[position].fromDate;
                                    String toDate = postList[position].toDate;
                                    String startTime = postList[position].startTime;
                                    String endTime = postList[position].endTime;
                                    String noOfHour = postList[position].noOfHour;
                                    String userId = postList[position].userId;
                                    String documnetId = postList[position].documentId;
                                    String calculatedAmount = postList[position].calculatedAmount;
                                    String transaction_id = postList[position].transaction_id;
                                    String receiverDeviceToken = postList[position].receiverDeviceToken;
                                    String cancellationDate = postList[position].cancellationDate;
                                    String compareDocID = postList[position].compareDocID;
                                    String compareTime = postList[position].compareTime;
                                    String id = postList[position].id;

                                    List<String> imageList = postList[position].names;

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                                                location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                                                fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,
                                                userId:userId,documnetId:documnetId,cancellationDate:cancellationDate,compareDocID:compareDocID,
                                                cancellationPost:"Cancelled",totalAmount:calculatedAmount, compareTime: compareTime, refundAmount: amount.round().toString())));
                                    setState(() {});

                                  },
                                ),

                              )
                                  :Container();

                            });
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  )
                ),
              )
              :Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height* 0.70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Data Available",style: TextStyle(fontFamily: "Montserrat",fontSize: 15,fontWeight: FontWeight.w500,
                      color: completed_color?Colors.blue:Color(0xff4996f3),
                    )),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),);
  }


  ListView confirmBookingListView() {

    bool show_list=false;
    for(int i =0;i<postList.length;i++)
    {
      if(postList[i].bookingStatus == "Confirmed")
      {
        show_list=true;
      }
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);

    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: postList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          //var parseDate = Jiffy(postList[position].fromDate, "dd-MMM-yyyy");
          var parseMonth ;
          var parseDate ;
          var parseYear;
          if(postList[position].fromDate != null){
            parseMonth = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("MMM");
            parseDate = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("dd");
            parseYear = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("yyyy");
            print(parseMonth);
          }
          return postList[position].bookingStatus == "Confirmed"
              ?Padding(
            padding: EdgeInsets.only(left: 6,right: 6),
            child: GestureDetector(
              child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                  child:  Wrap(
                    children: [
                      Row(
                        children:[
                          Container(
                            width: 252.0,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.0),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left:2.0),
                                        width:MediaQuery.of(context).size.width * 0.60,
                                        child: Text(postList[position].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black,
                                              fontFamily: "Montserrat"),),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                  child: Column(
                                    children: [
                                      Padding(
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child:
                                            postList[position].bookingForStatus == "Hour"
                                                ? Row(
                                              children: [
                                                Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                    ,fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].noOfHour,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            )
                                                :Row(
                                              children: [
                                                Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                    ,fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            ),
                                            Expanded(child:
                                            Row(
                                              children: [
                                                Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                    fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child:
                                            postList[position].bookingForStatus == "Hour"
                                                ? Row(
                                              children: [
                                                Text("Date :",style: TextStyle(color: Colors.grey,
                                                    fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            )
                                                :Row(
                                              children: [
                                                Text("To Date :",style: TextStyle(color: Colors.grey,
                                                    fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].toDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            ),
                                            Expanded(child:
                                            postList[position].bookingForStatus == "Hour"
                                                ? Row(
                                              children: [
                                                Text("End Time :",style: TextStyle(color: Colors.grey,
                                                    fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            )
                                                :Container(),
                                            )

                                          ],
                                        ), ),

                                      Container(
                                        margin: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 0),
                                        child: Row(
                                          children: [
                                            Text("Total Amount:",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                            SizedBox(width: 4,),
                                            Text("\$"+postList[position].calculatedAmount,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  height: 40.0,
                                  margin: EdgeInsets.only(left: 9,right: 8,top: 2),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.0),
                                      bottomLeft: Radius.circular(10.0),),
                                    color: Color(0xfff8fcff),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          latitude = postList[position].latitude;
                                          longitude = postList[position].longitude;
                                          openMap();
                                          setState(() {});
                                        },
                                        child:  Container(
                                          width:MediaQuery.of(context).size.width * 0.60,
                                          child: Text(postList[position].address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "Montserrat",
                                                //fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          latitude = postList[position].latitude;
                                          longitude = postList[position].longitude;
                                          openMap();
                                        },
                                        child: Image.asset('assets/Images/add_location.png',height: 14,
                                          width: 15,),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular((10.0),),topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              color: Color(0xffe2f1ff),
                            ),
                            height: 110.0,
                            width: 84.0,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Text(parseMonth.toString(),style: TextStyle(fontSize: 16,color: Colors.black,
                                    fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(parseDate.toString(),style: TextStyle(fontSize: 20,color: Colors.black,
                                    fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(parseYear.toString(),style: TextStyle(fontSize: 16,color: Colors.black,
                                    fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              onTap: (){

                from_mybooking=true;

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
                String bookingForStatus = postList[position].bookingForStatus;
                String fromDate = postList[position].fromDate;
                String toDate = postList[position].toDate;
                String startTime = postList[position].startTime;
                String endTime = postList[position].endTime;
                String noOfHour = postList[position].noOfHour;
                String userId = postList[position].userId;
                String documnetId = postList[position].documentId;
                String calculatedAmount = postList[position].calculatedAmount;
                String transaction_id = postList[position].transaction_id;
                String receiverDeviceToken = postList[position].receiverDeviceToken;
                String id = postList[position].id;
                String compareTime = postList[position].compareTime;

                List<String> imageList = postList[position].names;

             //   print(doc[position].documentID);


                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>
                        CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                          location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                          postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                          fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,
                          userId:userId,documnetId:documnetId,compareTime: compareTime,)));
                setState(() {});
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>CancelBookingPage()));

              },
            ),

          )
              :Container();

        });



  }

  ListView completedBookingListView() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _spaceTypes.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: EdgeInsets.only(left: 6,right: 6),
            child: GestureDetector(
              child: Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                ),

                child: Column(
                  children :[
                    Container(
                      padding: EdgeInsets.all(6.0),
                      child:  Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_spaceTypes[position],
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black,
                                fontFamily: "Montserrat"),),

                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("From :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                      ,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 4,),
                                  Text("3 hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,
                                      fontFamily: "Montserrat",fontWeight: FontWeight.w500),),
                                  SizedBox(width: 4,),
                                  Text("09:00 AM",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(left: 8,right: 10,top: 5,bottom: 3),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 5,top: 5,bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("To :",style: TextStyle(color: Colors.grey,
                                      fontSize: 9,fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold),),
                                  SizedBox(width: 4,),
                                  Text("12/7/2021",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500),),
                                ],
                              ),

                            ],
                          ),
                        )],
                    ),
                    SizedBox(
                      height:4,
                    ),

                    Container(
                      height: 40.0,
                      //margin: EdgeInsets.only(left: 9,right: 0),
                      width:double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),),
                        color: Color(0xfff8fcff),
                      ),
                      child:  Padding(padding: EdgeInsets.only(left: 9,right: 65),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2195 Sycamore Lake Road, Menasha',style: TextStyle(fontSize: 10,fontFamily: "Montserrat",
                                //fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
                            ),

                            Image.asset('assets/Images/add_location.png',height: 14,),
                          ],
                        ),
                      ),

                    ),
                  ],
                ),
              ),
              onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>CancelBookingPage()));
              },
            ),
          );
        });
  }

   ListView cancelledBookingListView() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: postList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          var parseMonth ;
          var parseDate ;
          var parseYear;
          if(postList[position].fromDate != null){
            parseMonth = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("MMM");
            parseDate = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("dd");
            parseYear = Jiffy(postList[position].fromDate, "MM/dd/yyyy").format("yyyy");
            print(parseMonth);
          }

          double amount;
          if(postList[position].bookingStatus == "Cancelled"){
            amount = double.parse(postList[position].calculatedAmount)-(20*double.parse(postList[position].calculatedAmount))/100;
            print("CAALCULATED AMOUNT "+amount.toString());
          }


          return postList[position].bookingStatus == "Cancelled"
              ?Padding(
            padding: EdgeInsets.only(left: 6,right: 6),
            child: GestureDetector(
              child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                  child:  Wrap(
                    children: [
                      Row(
                        children:[
                          Container(
                            width: 252.0,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.0),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left:2.0),
                                        width:MediaQuery.of(context).size.width * 0.60,
                                        child: Text(postList[position].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black,
                                              fontFamily: "Montserrat"),),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                  child: Column(
                                    children: [
                                      Padding(
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child:
                                            postList[position].bookingForStatus == "Hour"
                                                ? Row(
                                              children: [
                                                Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                    ,fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].noOfHour,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            )
                                                :Row(
                                              children: [
                                                Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                    ,fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            ),
                                            Expanded(child:
                                            Row(
                                              children: [
                                                Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                    fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child:
                                            postList[position].bookingForStatus == "Hour"
                                                ? Row(
                                              children: [
                                                Text("Date :",style: TextStyle(color: Colors.grey,
                                                    fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            )
                                                :Row(
                                              children: [
                                                Text("To Date :",style: TextStyle(color: Colors.grey,
                                                    fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].toDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                            ),
                                            Expanded(child:
                                            postList[position].bookingForStatus == "Hour"
                                                ? Row(
                                              children: [
                                                Text("End Time :",style: TextStyle(color: Colors.grey,
                                                    fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            )
                                                :Container(),
                                            )

                                          ],
                                        ), ),

                                     Row(
                                       children: [
                                       Expanded(
                                         child:   Container(
                                           margin: EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 0),
                                           child: Row(
                                             children: [
                                               Text("Total Amount:",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                   fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                               SizedBox(width: 4,),
                                               Text("\$"+postList[position].calculatedAmount,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                   fontWeight: FontWeight.w500),),
                                             ],
                                           ),
                                         ),
                                       ),

                                         postList[position].bookingStatus == "Cancelled"
                                       ? Expanded(
                                          child:
                                          Container(
                                            margin: EdgeInsets.only(left: 0,right: 5,top: 5,bottom: 0),
                                            child: Row(
                                              children: [
                                                Text("Refund Amount:",style: TextStyle(color: Colors.grey,fontSize: 9,
                                                    fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                SizedBox(width: 4,),
                                                Text("\$"+amount.round().toString(),style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                          ),
                                        )
                                         :Container(),
                                       ],
                                     )


                                    ],
                                  ),
                                ),

                                Container(
                                  height: 40.0,
                                  margin: EdgeInsets.only(left: 9,right: 8,top: 2),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.0),
                                      bottomLeft: Radius.circular(10.0),),
                                    color: Color(0xfff8fcff),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          latitude = postList[position].latitude;
                                          longitude = postList[position].longitude;
                                          openMap();
                                          setState(() {});
                                        },
                                        child:  Container(
                                          width:MediaQuery.of(context).size.width * 0.60,
                                          child: Text(postList[position].address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "Montserrat",
                                                //fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          latitude = postList[position].latitude;
                                          longitude = postList[position].longitude;
                                          openMap();
                                        },
                                        child: Image.asset('assets/Images/add_location.png',height: 14,
                                          width: 15,),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular((10.0),),topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              color:Colors.red,
                            ),
                            height: 110.0,
                            width: 84.0,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Text(parseMonth.toString(),style: TextStyle(fontSize: 16,color: Colors.white,
                                    fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(parseDate.toString(),style: TextStyle(fontSize: 20,color: Colors.white,
                                    fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(parseYear.toString(),style: TextStyle(fontSize: 16,color: Colors.white,
                                    fontWeight: FontWeight.w500,fontFamily: "Montserrat"),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
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
                String bookingForStatus = postList[position].bookingForStatus;
                String fromDate = postList[position].fromDate;
                String toDate = postList[position].toDate;
                String startTime = postList[position].startTime;
                String endTime = postList[position].endTime;
                String noOfHour = postList[position].noOfHour;
                String userId = postList[position].userId;
                String documnetId = postList[position].documentId;
                String calculatedAmount = postList[position].calculatedAmount;
                String transaction_id = postList[position].transaction_id;
                String receiverDeviceToken = postList[position].receiverDeviceToken;
                String cancellationDate = postList[position].cancellationDate;
                String compareDocID = postList[position].compareDocID;
                String id = postList[position].id;
                String compareTime = postList[position].compareTime;

                List<String> imageList = postList[position].names;

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>
                        CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                          location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                          postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                          fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,
                          userId:userId,documnetId:documnetId,cancellationDate:cancellationDate,compareDocID:compareDocID,
                            cancellationPost:"Cancelled",totalAmount:calculatedAmount, compareTime:compareTime,refundAmount: amount.round().toString())));
                setState(() {});

              },
            ),

          )
              :Container();

        });
  }


  Future<void> bookingList() async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    Query query = FirebaseFirestore.instance
        .collection('users').doc(user.uid).collection("my_booking");
    print("query   "+query.toString());
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);
        PostingModel posting = PostingModel();



        String id =  document.id;
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
        String fromDate = values['fromDate'];
        String toDate = values['toDate'];
        String startTime = values['startTime'];
        String endTime = values['endTime'];
        String noOfHour = values['noOfHour'];
        String bookingForStatus = values['bookingForStatus'];
        String calculatedAmount = values['calculatedAmount'];
        String documnetId = values['documentId'];
        String transaction_id = values['transaction_id'];
        String receiverDeviceToken = values['receiverDeviceToken'];
        String cancellationDate = values['cancellationDate'];
        String compareDocID = values['compareDocID'];
        String subCategories = values['subCategories'];
        String compareTime = values['compareTime'];

        posting.names = List.from(document['imageNames']);
        print("images list "+posting.names.length.toString());

        for(int i=0; i<allPostList.length; i++){
          if(allPostList[i].documentId == documnetId){

            if(allPostList[i].address != address){
              posting.address = allPostList[i].address;
            }else{
              posting.address = address;
            }

            if(allPostList[i].title != title){
              posting.title = allPostList[i].title;
            }else{
              posting.title = title;
            }

            if(allPostList[i].description != description){
              posting.description = allPostList[i].description;
            }else{
              posting.description = description;
            }

            if(allPostList[i].categoryName != categoryName){
              posting.categoryName = allPostList[i].categoryName;
            }else{
              posting.categoryName = categoryName;
            }

            if(allPostList[i].priceDay != priceDay){
              posting.priceDay = allPostList[i].priceDay;
            }else{
              posting.priceDay = priceDay;
            }

            if(allPostList[i].priceHour != priceHour){
              posting.priceHour = allPostList[i].priceHour;
            }else{
              posting.priceHour = priceHour;
            }

            if(allPostList[i].priceWeek != priceWeek){
              posting.priceWeek = allPostList[i].priceWeek;
            }else{
              posting.priceWeek = priceWeek;
            }

            if(allPostList[i].postingDate != postingDate){
              posting.postingDate = allPostList[i].postingDate;
            }else{
              posting.postingDate = postingDate;
            }

            if(allPostList[i].latitude != latitude){
              posting.latitude = allPostList[i].latitude;
            }else{
              posting.latitude = latitude;
            }

            if(allPostList[i].longitude != longitude){
              posting.longitude = allPostList[i].longitude;
            }else{
              posting.longitude = longitude;
            }

            if(allPostList[i].latlng != latlng){
              posting.latlng = allPostList[i].latlng;
            }else{
              posting.latlng = latlng;
            }

            if(allPostList[i].subCategories != subCategories){
              posting.subCategories = allPostList[i].subCategories;
            }else{
              posting.subCategories = subCategories;
            }

            posting.wishList = wishList;
            posting.bookingStatus = bookingStatus;
            posting.userId = userId;
            posting.stripeAccountLink = stripeAccountLink;
            posting.fromDate = fromDate;
            posting.toDate = toDate;
            posting.startTime = startTime;
            posting.endTime = endTime;
            posting.noOfHour = noOfHour;
            posting.bookingForStatus = bookingForStatus;
            posting.calculatedAmount = calculatedAmount;
            posting.documentId = documnetId;
            posting.transaction_id = transaction_id;
            posting.receiverDeviceToken = receiverDeviceToken;
        //    posting.subCategories = subCategories;
            posting.cancellationDate = cancellationDate;
            posting.compareDocID = compareDocID;
            posting.compareTime = compareTime;
            posting.id = id;
         }

        }



      /* posting.address = address;
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
        posting.fromDate = fromDate;
        posting.toDate = toDate;
        posting.startTime = startTime;
        posting.endTime = endTime;
        posting.noOfHour = noOfHour;
        posting.bookingForStatus = bookingForStatus;
        posting.calculatedAmount = calculatedAmount;
        posting.documentId = documnetId;
        posting.transaction_id = transaction_id;
        posting.receiverDeviceToken = receiverDeviceToken;
        posting.cancellationDate = cancellationDate;
        posting.compareDocID = compareDocID;
        posting.subCategories = subCategories;
        posting.id = id;*/

        postList.add(posting);
      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;
     // CategoryList();
      setState(() {});

    });
  }


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
        .collection('all_post');
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
        String wishList = values['wishList'];
        String bookingStatus = values['bookingStatus'];
        String userId = values['userId'];
        String stripeAccountLink = values['stripeAccountLink'];
        String deviceToken = values['deviceToken'];
        String documentID = values['documentId'];
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
        posting.wishList = wishList;
        posting.bookingStatus = bookingStatus;
        posting.userId = userId;
        posting.stripeAccountLink = stripeAccountLink;
        posting.deviceToken = deviceToken;
        posting.documentId = documentID;
        posting.subCategories = subCategories;

        allPostList.add(posting);

      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      // postFirebaseList();
      setState(() {});
    });


    bookingList();

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
}




