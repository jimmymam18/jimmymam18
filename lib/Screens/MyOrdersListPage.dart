import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bizitme/Screens/CancelBookingPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bizitme/global.dart';


class MyOrderListPage extends StatefulWidget {
  final String showCancleTab;

  MyOrderListPage({Key key, this.showCancleTab}) : super(key: key);


  @override
  _MyOrderListPageState createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {

  bool confirm_color=true;
  bool completed_color=false;
  bool cancelled_color=false;

  bool confirmOrder =true;
  bool completeOrder =false;
  bool cancelOrder =false;

  bool booking_date_color= false;
  bool post_title_color = false;

  String value = "0";

  bool selectindex =false;

  Color colorPrimary = Color(0xff4996f3);
  TabController _controller;
  ProgressDialog _progressDialog = new ProgressDialog();
  List<PostingModel> postList = new List();
  List<PostingModel> allPostList = new List();
  TextEditingController editingController = new TextEditingController();
  TextEditingController editingDateController = new TextEditingController();
  DateTime startDate;
  String fromDate = "";
  String showDateList = "0";
  String showCancelledDateList = "0";
  String noConfirmedBookingAvailable = "0";
  StateSetter _setState;
  final db = FirebaseFirestore.instance;
  String currentUserId = "";


  @override
  void initState() {
    // TODO: implement initState
    CategoryList();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    currentUserId = user.uid;
    print(user.uid);

    super.initState();
  }


  Future<void> _selectFromDate(BuildContext context) async {
    startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2032),
    );
    if (d != null)
      setState(() {
        fromDate = DateFormat("MM/dd/yyyy").format(startDate);
        editingDateController.text = fromDate;
      });
  }


  void _showBottomSheet_filter(){
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                _setState = setState;
                return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 230.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: const Radius.circular(18.0),
                      ),
                    ),
                    child: DefaultTabController(
                      length: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TabBar(
                                tabs: [
                                  Container(
                                    child: Text("Booking Date",
                                      style: TextStyle(
                                          fontFamily: "Montserrat", fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    child: Text("Post Title",
                                      style: TextStyle(
                                          fontFamily: "Montserrat", fontSize: 12),
                                    ),
                                  ),
                                ],
                                indicatorSize: TabBarIndicatorSize.label,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Color(0xff4996f3),
                                indicatorWeight: 0.6,
                                indicatorPadding: EdgeInsets.only(top: 2.0),
                                labelColor: Color(0xff4996f3),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _controller,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height * 0.07,
                                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,
                                                left: MediaQuery.of(context).size.height * 0.02,
                                                right: MediaQuery.of(context).size.height * 0.02,
                                                bottom: MediaQuery.of(context).size.height * 0.00),
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height * 0.01,
                                                left: MediaQuery.of(context).size.height * 0.00,
                                                right: MediaQuery.of(context).size.height * 0.02,
                                                bottom: MediaQuery.of(context).size.height * 0.00),
                                            decoration: BoxDecoration(
                                              border: Border.all( width: 1),
                                              borderRadius: BorderRadius.circular(80),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: InkWell(
                                              onTap: (){
                                                _selectFromDate(context);
                                              },
                                              child: TextField(
                                                onChanged: (value) {
                                                  _setState(() {});
                                                },
                                                enabled: false,
                                                keyboardType: TextInputType.text,
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                controller: editingDateController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  prefixIcon:Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 22, right: 8),
                                                    child: Image.asset(
                                                      'assets/Images/search.png',
                                                      height: 0, width: 0,),
                                                  ),
                                                  //Add th Hint text here.
                                                  border: InputBorder.none,
                                                  hintText: "Search",
                                                  hintStyle: TextStyle(
                                                    fontSize:
                                                    2.1 * MediaQuery.of(context).size.height * 0.01,
                                                    fontFamily: 'Montserrat',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize:
                                                  2.1 * MediaQuery.of(context).size.height * 0.01,
                                                  fontFamily: 'Montserrat',
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height * 0.07,
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,
                                              left: MediaQuery.of(context).size.height * 0.02,
                                              right: MediaQuery.of(context).size.height * 0.02,
                                              bottom: MediaQuery.of(context).size.height * 0.0),
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context).size.height * 0.01,
                                              left: MediaQuery.of(context).size.height * 0.00,
                                              right: MediaQuery.of(context).size.height * 0.02,
                                              bottom: MediaQuery.of(context).size.height * 0.0),
                                          decoration: BoxDecoration(
                                            border: Border.all( width: 1),
                                            borderRadius: BorderRadius.circular(80),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: TextField(
                                            onChanged: (value) {
                                              _setState(() {});
                                              setState(() {});
                                            },
                                            onSubmitted: (value){
                                              if(editingDateController.text == ""){

                                                   if(confirm_color==true)
                                                   {
                                                     journeyListView();
                                                   }
                                                   else
                                                     {
                                                       journeyListView2();
                                                     }

                                              }else{
                                                showDateList = "1";
                                                orderList();
                                              }
                                              Navigator.of(context).pop(true);
                                              _setState(() {});
                                              setState(() {});
                                            },
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.done,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            controller: editingController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              prefixIcon:Padding(
                                                padding: EdgeInsets.only(
                                                    left: 22, right: 8),
                                                child: Image.asset(
                                                  'assets/Images/search.png',
                                                  height: 0, width: 0,),
                                              ),
                                              //Add th Hint text here.
                                              border: InputBorder.none,
                                              hintText: "Search",
                                              hintStyle: TextStyle(
                                                fontSize: 2.1 * MediaQuery.of(context).size.height * 0.01,
                                                fontFamily: 'Montserrat',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 2.1 * MediaQuery.of(context).size.height * 0.01,
                                              fontFamily: 'Montserrat',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 150,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        editingController.text = "";
                                        editingDateController.text = "";
                                        _setState(() {});
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Color(0xff4996f3),),
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      child: Text("Cancel",style: TextStyle(fontFamily: "Montserrat"),),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: RaisedButton(
                                      onPressed: (){
                                        if(editingDateController.text == ""){

                                          if(confirm_color==true)
                                          {
                                            journeyListView();
                                          }
                                          else
                                          {
                                            journeyListView2();

                                          }

                                        }else{
                                          showDateList = "1";
                                          orderList();
                                        }
                                        Navigator.of(context).pop(true);
                                        _setState(() {});
                                        setState(() {});
                                      },
                                      color: Color(0xff4996f3),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Color(0xff4996f3),),
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      child: Text("Apply",style: TextStyle(fontFamily: "Montserrat"),),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ));
              }),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: (){
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => GuestHomePage()));
        });
      },
      child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text('Orders',style: TextStyle(fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,fontFamily: "Montserrat"),textAlign: TextAlign.center,),

              ),
              backgroundColor: Color(0xff4996f3),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: IconButton(icon: new Image.asset('assets/Images/orders-1.png',height: 20,width: 20,),
                    onPressed: (){
                      editingDateController.text = "";
                      editingController.text = "";
                      showDateList = "0";
                      _showBottomSheet_filter();
                    },),
                )
              ]
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height:3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex:1,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                          margin: EdgeInsets.only(left: 7, right:4),
                          child: RaisedButton(
                            onPressed: (){
                              if(confirm_color==true)
                              {
                              //  confirm_color=false;
                              }
                              else
                              {
                                confirm_color=true;
                                completed_color = false ;
                                cancelled_color = false ;
                              }
                              confirmOrder =true;
                              completeOrder =false;
                              cancelOrder =false;

                              //hour_day_week=1;
                              setState(() {});

                            },
                            color: confirm_color?Color(0xff4996f3):Colors.white,
                            // textColor: Colors.blue,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xff4996f3),width: 2.0),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text("Confirmed",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,
                              color: confirm_color?Colors.white:Color(0xff4996f3),
                            )),
                          ),
                        ),),

                      Expanded(
                        flex:1,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                          margin: EdgeInsets.only(left: 7, right:4),
                          child: RaisedButton(
                            onPressed: (){
                              if(cancelled_color==true)
                              {
                              //  cancelled_color=false;
                              }
                              else
                              {
                                cancelled_color=true;
                                confirm_color = false ;
                                completed_color = false ;
                              }
                              confirmOrder =false;
                              completeOrder =false;
                              cancelOrder =true;
                              //hour_day_week=1;
                              setState(() {});
                            },
                            color:cancelled_color?Color(0xff4996f3):Colors.white,
                            //textColor: Colors.blue,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xff4996f3),width: 2.0),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text("Cancelled",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,

                              color: cancelled_color?Colors.white:Color(0xff4996f3),)),
                          ),
                        ),)
                    ],
                  ),
                ),

                postList.isNotEmpty
                    ?Container(
                  height: MediaQuery.of(context).size.height* 0.70,
                  child: SingleChildScrollView(
                    child:showDateList == "0" && widget.showCancleTab == null
                        ?confirmOrder
                        ?   StreamBuilder<QuerySnapshot>(
                      stream: db.collection('users').doc(currentUserId).collection("my_order").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var doc = snapshot.data.docs;
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: postList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int position) {

                                if(editingController.text.isEmpty ){
                                  return postList[position].bookingStatus == "Confirmed"?
                                  Padding(
                                    padding: EdgeInsets.only(left: 6,right: 6),
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 10.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 4,right:4,),
                                                      child: Card(
                                                        child:  Container(
                                                          padding: EdgeInsets.all(4.0),
                                                          width: MediaQuery.of(context).size.width*0.24,
                                                          height: MediaQuery.of(context).size.width*0.24,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                                            //shape: BoxShape.rectangle,
                                                          ),child:  CachedNetworkImage(
                                                          imageUrl: postList[position].names[0],
                                                          placeholder: (context, url) => CircularProgressIndicator(),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                        ),
                                                          // Image.network(postList[position].names[0]),
                                                        ),
                                                      ),
                                                    ),

                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                      Container(
                                                        width:MediaQuery.of(context).size.width * 0.40,
                                                        child:   Text(postList[position].title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 14,
                                                              color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                                      ),
                                                        SizedBox(height: 11,),

                                                        postList[position].bookingForStatus == "Hour"
                                                            ? Row(
                                                          children: [
                                                            Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                                            SizedBox(width: 4,),
                                                            Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                fontWeight: FontWeight.w500),),
                                                          ],
                                                        ):Row(
                                                          children: [
                                                            Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                                ,fontWeight: FontWeight.bold),),
                                                            SizedBox(width: 4,),
                                                            Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                fontWeight: FontWeight.w500),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 9,),
                                                        postList[position].bookingForStatus == "Hour"
                                                            ? Row(
                                                          children: [
                                                            Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
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
                                                        SizedBox(height: 9,),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 0.60,
                                                          child:  Text(postList[position].userName,
                                                            maxLines:2,
                                                            overflow:TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                  left: 230.0,
                                                  //right: 6,

                                                  child:  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: 22.0,
                                                            alignment: Alignment.topRight,
                                                            margin: EdgeInsets.only(left: 21.3),
                                                            child: Row(
                                                              // mainAxisAlignment: MainAxisAlignment.end,
                                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                RaisedButton(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                      side: BorderSide(color: Color(0xff4996f3),),
                                                                    ),
                                                                    onPressed: () {},
                                                                    color: Color(0xff4996f3),
                                                                    textColor: Colors.white,
                                                                    child:  Text('\$'+ postList[position].calculatedAmount,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500
                                                                          ,fontFamily: 'Montserrat'),
                                                                    )

                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 9,
                                                          ),

                                                          Row(
                                                            children: [
                                                              Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                              SizedBox(width: 4,),
                                                              Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                  fontWeight: FontWeight.w500),),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 9,
                                                          ),
                                                          postList[position].bookingForStatus == "Hour"
                                                              ?Row(
                                                            children: [
                                                              Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                              SizedBox(width: 4,),
                                                              Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                  fontWeight: FontWeight.w500),),
                                                            ],
                                                          )
                                                              :Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 38.0,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                                                    bottomRight: Radius.circular(9.0)),
                                                color: Color(0xfff8fcff),
                                              ),

                                              child:  Padding(
                                                padding: EdgeInsets.only(left: 10,right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [

                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.75,
                                                      child: Text( postList[position].address,
                                                        maxLines:2,
                                                        overflow:TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                                        ),),
                                                    ),
                                                    //  Image.asset('assets/Images/add_location.png',height: 14,),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
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
                                        String bookingForStatus = postList[position].bookingForStatus;
                                        String fromDate = postList[position].fromDate;
                                        String toDate = postList[position].toDate;
                                        String startTime = postList[position].startTime;
                                        String endTime = postList[position].endTime;
                                        String noOfHour = postList[position].noOfHour;
                                        String email = postList[position].userEmail;
                                        String chatUserIdd = postList[position].userId;
                                        String click ="Order";

                                        String documnetId = postList[position].documentId;


                                        String calculatedAmount = postList[position].calculatedAmount;
                                        String transaction_id = postList[position].transaction_id;
                                        String receiverDeviceToken = postList[position].receiverDeviceToken;
                                        String id = postList[position].id;
                                        String compareDocID = postList[position].compareDocID;
                                        String subCategories = postList[position].subCategories;
                                        String compareTime = postList[position].compareTime;


                                        print(doc[position].id);
                                        String checkDocumentId = doc[position].id;


                                        List<String> imageList = postList[position].names;

                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) =>
                                                CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                                                  location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                  postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                                                  fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                                                  documnetId: documnetId, userId: chatUserIdd,checkDocumentId:checkDocumentId,compareDocID:compareDocID,
                                                    subCategories:subCategories, compareTime: compareTime,)));

                                        from_mybooking=false;
                                        setState(() {});

                                      },
                                    ),
                                  ):Container();
                                }

                                else if (postList[position]
                                    .title
                                    .toLowerCase()
                                    .contains(editingController.text) ) {
                                  return postList[position].bookingStatus == "Confirmed"?
                                  Padding(
                                    padding: EdgeInsets.only(left: 6,right: 6),
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 10.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 4,right:4,),
                                                      child: Card(
                                                        child:  Container(
                                                          padding: EdgeInsets.all(4.0),
                                                          width: MediaQuery.of(context).size.width*0.24,
                                                          height: MediaQuery.of(context).size.width*0.24,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                                            //shape: BoxShape.rectangle,
                                                          ),child: CachedNetworkImage(
                                                          imageUrl: postList[position].names[0],
                                                          placeholder: (context, url) => CircularProgressIndicator(),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                        ),
                                                        ),
                                                      ),
                                                    ),

                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(('${postList[position].title.toLowerCase()}'),
                                                          style: TextStyle(fontSize: 14,
                                                              color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                                        SizedBox(height: 11,),

                                                        postList[position].bookingForStatus == "Hour"
                                                            ? Row(
                                                          children: [
                                                            Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                                            SizedBox(width: 4,),
                                                            Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                fontWeight: FontWeight.w500),),
                                                          ],
                                                        ):Row(
                                                          children: [
                                                            Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                                                ,fontWeight: FontWeight.bold),),
                                                            SizedBox(width: 4,),
                                                            Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                fontWeight: FontWeight.w500),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 9,),
                                                        postList[position].bookingForStatus == "Hour"
                                                            ? Row(
                                                          children: [
                                                            Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
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
                                                        SizedBox(height: 9,),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 0.60,
                                                          child:  Text( postList[position].userName,
                                                            maxLines:2,
                                                            overflow:TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                  left: 230.0,
                                                  //right: 6,

                                                  child:  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: 22.0,
                                                            alignment: Alignment.topRight,
                                                            margin: EdgeInsets.only(left: 21.3),
                                                            child: Row(
                                                              // mainAxisAlignment: MainAxisAlignment.end,
                                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                RaisedButton(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                      side: BorderSide(color: Color(0xff4996f3),),
                                                                    ),
                                                                    onPressed: () {},
                                                                    color: Color(0xff4996f3),
                                                                    textColor: Colors.white,
                                                                    child:  Text('\$'+ postList[position].calculatedAmount,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500
                                                                          ,fontFamily: 'Montserrat'),
                                                                    )

                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 9,
                                                          ),

                                                          Row(
                                                            children: [
                                                              Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                              SizedBox(width: 4,),
                                                              Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                  fontWeight: FontWeight.w500),),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 9,
                                                          ),
                                                          postList[position].bookingForStatus == "Hour"
                                                              ?Row(
                                                            children: [
                                                              Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                                              SizedBox(width: 4,),
                                                              Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                                                  fontWeight: FontWeight.w500),),
                                                            ],
                                                          )
                                                              :Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 38.0,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                                                    bottomRight: Radius.circular(9.0)),
                                                color: Color(0xfff8fcff),
                                              ),

                                              child:  Padding(
                                                padding: EdgeInsets.only(left: 10,right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [

                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.75,
                                                      child: Text( postList[position].address,
                                                        maxLines:2,
                                                        overflow:TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                                        ),),
                                                    ),
                                                    //  Image.asset('assets/Images/add_location.png',height: 14,),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
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
                                        String bookingForStatus = postList[position].bookingForStatus;
                                        String fromDate = postList[position].fromDate;
                                        String toDate = postList[position].toDate;
                                        String startTime = postList[position].startTime;
                                        String endTime = postList[position].endTime;
                                        String noOfHour = postList[position].noOfHour;
                                        String email = postList[position].userEmail;
                                        String click ="Order";

                                        String calculatedAmount = postList[position].calculatedAmount;
                                        String transaction_id = postList[position].transaction_id;
                                        String receiverDeviceToken = postList[position].receiverDeviceToken;
                                        String id = postList[position].id;
                                        String compareDocID = postList[position].compareDocID;
                                        String documnetId = postList[position].documentId;
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
                                                  fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                                                    checkDocumentId:checkDocumentId,compareDocID:compareDocID, documnetId: documnetId,subCategories:subCategories, compareTime: compareTime,)));
                                        from_mybooking=false;


                                        setState(() {});

                                      },
                                    ),
                                  ):Container();
                                }

                                else
                                {
                                  noConfirmedBookingAvailable = "1";
                                  return Container();
                                }

                              });
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    )
                        :journeyListView2()
                        :confirmOrder?journeyDateFilterListView():journeyDateFilterListView2()

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

                Container(
                  // child:compltebooking ==true?completedBookingListView():Container()
                  child: completeOrder == true? Container(
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
                  )
                      :Container(),
                ),
              ],
            ),
          )
      ),
    );
  }



  ListView journeyListView(){
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: postList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {

          if(editingController.text.isEmpty ){
            return postList[position].bookingStatus == "Confirmed"?
            Padding(
                padding: EdgeInsets.only(left: 6,right: 6),
                child: GestureDetector(
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 4,right:4,),
                                  child: Card(
                                    child:  Container(
                                      padding: EdgeInsets.all(4.0),
                                      width: MediaQuery.of(context).size.width*0.24,
                                      height: MediaQuery.of(context).size.width*0.24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                        //shape: BoxShape.rectangle,
                                      ),child:  CachedNetworkImage(
                                      imageUrl: postList[position].names[0],
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                    // Image.network(postList[position].names[0]),
                                    ),
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(postList[position].title,
                                      style: TextStyle(fontSize: 14,
                                          color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                    SizedBox(height: 11,),

                                    postList[position].bookingForStatus == "Hour"
                                        ? Row(
                                      children: [
                                        Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ):Row(
                                      children: [
                                        Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                            ,fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    SizedBox(height: 9,),
                                    postList[position].bookingForStatus == "Hour"
                                        ? Row(
                                      children: [
                                        Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
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
                                    SizedBox(height: 9,),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.60,
                                      child:  Text(postList[position].userName,
                                        maxLines:2,
                                        overflow:TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              left: 230.0,
                              //right: 6,

                              child:  Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 22.0,
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(left: 21.3),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(0.0),
                                                  side: BorderSide(color: Color(0xff4996f3),),
                                                ),
                                                onPressed: () {},
                                                color: Color(0xff4996f3),
                                                textColor: Colors.white,
                                                child:  Text('\$'+ postList[position].calculatedAmount,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500
                                                      ,fontFamily: 'Montserrat'),
                                                )

                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),

                                      Row(
                                        children: [
                                          Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                          SizedBox(width: 4,),
                                          Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      postList[position].bookingForStatus == "Hour"
                                          ?Row(
                                        children: [
                                          Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                          SizedBox(width: 4,),
                                          Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500),),
                                        ],
                                      )
                                          :Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 38.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                                bottomRight: Radius.circular(9.0)),
                            color: Color(0xfff8fcff),
                          ),

                          child:  Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  child: Text( postList[position].address,
                                    maxLines:2,
                                    overflow:TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                    ),),
                                ),
                                //  Image.asset('assets/Images/add_location.png',height: 14,),
                              ],
                            ),
                          ),
                        ),

                      ],
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
                    String bookingForStatus = postList[position].bookingForStatus;
                    String fromDate = postList[position].fromDate;
                    String toDate = postList[position].toDate;
                    String startTime = postList[position].startTime;
                    String endTime = postList[position].endTime;
                    String noOfHour = postList[position].noOfHour;
                    String email = postList[position].userEmail;
                    String chatUserIdd = postList[position].userId;
                    String click ="Order";

                   String documnetId = postList[position].documentId;
                   print("SOCUment Id : "+documnetId);

                    String calculatedAmount = postList[position].calculatedAmount;
                    String transaction_id = postList[position].transaction_id;
                    String receiverDeviceToken = postList[position].receiverDeviceToken;
                    String id = postList[position].id;
                    String subCategories = postList[position].subCategories;
                    String compareTime = postList[position].compareTime;


                    List<String> imageList = postList[position].names;

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                            CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                              location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                              postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                              fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                            documnetId: documnetId, userId: chatUserIdd,subCategories:subCategories, compareTime: compareTime,)));

                    from_mybooking=false;
                    setState(() {});

                  },
                ),
              ):Container();
          }

          else if (postList[position]
              .title
              .toLowerCase()
              .contains(editingController.text) ) {
            return postList[position].bookingStatus == "Confirmed"?
            Padding(
              padding: EdgeInsets.only(left: 6,right: 6),
              child: GestureDetector(
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4,right:4,),
                                child: Card(
                                  child:  Container(
                                    padding: EdgeInsets.all(4.0),
                                    width: MediaQuery.of(context).size.width*0.24,
                                    height: MediaQuery.of(context).size.width*0.24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                      //shape: BoxShape.rectangle,
                                    ),child: CachedNetworkImage(
                                    imageUrl: postList[position].names[0],
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  ),
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(('${postList[position].title.toLowerCase()}'),
                                    style: TextStyle(fontSize: 14,
                                        color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                  SizedBox(height: 11,),

                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                      SizedBox(width: 4,),
                                      Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ):Row(
                                    children: [
                                      Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                          ,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 4,),
                                      Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  SizedBox(height: 9,),
                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
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
                                  SizedBox(height: 9,),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.60,
                                    child:  Text( postList[position].userName,
                                      maxLines:2,
                                      overflow:TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            left: 230.0,
                            //right: 6,

                            child:  Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 22.0,
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(left: 21.3),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                                side: BorderSide(color: Color(0xff4996f3),),
                                              ),
                                              onPressed: () {},
                                              color: Color(0xff4996f3),
                                              textColor: Colors.white,
                                              child:  Text('\$'+ postList[position].calculatedAmount,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500
                                                    ,fontFamily: 'Montserrat'),
                                              )

                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),

                                    Row(
                                      children: [
                                        Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    postList[position].bookingForStatus == "Hour"
                                        ?Row(
                                      children: [
                                        Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    )
                                        :Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 38.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                              bottomRight: Radius.circular(9.0)),
                          color: Color(0xfff8fcff),
                        ),

                        child:  Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text( postList[position].address,
                                  maxLines:2,
                                  overflow:TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                  ),),
                              ),
                              //  Image.asset('assets/Images/add_location.png',height: 14,),
                            ],
                          ),
                        ),
                      ),

                    ],
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
                  String bookingForStatus = postList[position].bookingForStatus;
                  String fromDate = postList[position].fromDate;
                  String toDate = postList[position].toDate;
                  String startTime = postList[position].startTime;
                  String endTime = postList[position].endTime;
                  String noOfHour = postList[position].noOfHour;
                  String email = postList[position].userEmail;
                  String click ="Order";

                  String calculatedAmount = postList[position].calculatedAmount;
                  String transaction_id = postList[position].transaction_id;
                  String receiverDeviceToken = postList[position].receiverDeviceToken;
                  String id = postList[position].id;
                  String subCategories = postList[position].subCategories;
                  String compareTime = postList[position].compareTime;

                  List<String> imageList = postList[position].names;

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                            location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                            postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                            fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                              subCategories:subCategories, compareTime: compareTime, )));
                  from_mybooking=false;


                  setState(() {});

                },
              ),
            ):Container();
          }

          else
            {
              noConfirmedBookingAvailable = "1";
            return Container();
            }

        });
  }

  ListView journeyListView2(){
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: postList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          double amount;
          if(postList[position].bookingStatus == "Cancelled"){
             amount = double.parse(postList[position].calculatedAmount)-(20*double.parse(postList[position].calculatedAmount))/100;
            print("CAALCULATED AMOUNT "+amount.toString());
          }

          if(editingController.text.isEmpty ){
            return postList[position].bookingStatus == "Cancelled"?
            Padding(
                padding: EdgeInsets.only(left: 6,right: 6),
                child: GestureDetector(
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 4,right:4,),
                                  child: Card(
                                    child:  Container(
                                      padding: EdgeInsets.all(4.0),
                                      width: MediaQuery.of(context).size.width*0.24,
                                      height: MediaQuery.of(context).size.width*0.24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                        //shape: BoxShape.rectangle,
                                      ),child:  CachedNetworkImage(
                                      imageUrl: postList[position].names[0],
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                    // Image.network(postList[position].names[0]),
                                    ),
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(postList[position].title,
                                      style: TextStyle(fontSize: 14,
                                          color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                    SizedBox(height: 11,),

                                    postList[position].bookingForStatus == "Hour"
                                        ? Row(
                                      children: [
                                        Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ):Row(
                                      children: [
                                        Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                            ,fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    SizedBox(height: 9,),
                                    postList[position].bookingForStatus == "Hour"
                                        ? Row(
                                      children: [
                                        Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
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
                                    SizedBox(height: 9,),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.60,
                                      child:  Text(postList[position].userName,
                                        maxLines:2,
                                        overflow:TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              left: 230.0,
                              //right: 6,

                              child:  Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 22.0,
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(left: 21.3),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(0.0),
                                                  side: BorderSide(color:  Colors.red,),
                                                ),
                                                onPressed: () {},
                                                color:  Colors.red,
                                                textColor: Colors.white,
                                                child:  Text('\$'+ amount.round().toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500
                                                      ,fontFamily: 'Montserrat'),
                                                )

                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),

                                      Row(
                                        children: [
                                          Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                          SizedBox(width: 4,),
                                          Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      postList[position].bookingForStatus == "Hour"
                                          ?Row(
                                        children: [
                                          Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                          SizedBox(width: 4,),
                                          Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500),),
                                        ],
                                      )
                                          :Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 38.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                                bottomRight: Radius.circular(9.0)),
                            color: Color(0xfff8fcff),
                          ),

                          child:  Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  child: Text( postList[position].address,
                                    maxLines:2,
                                    overflow:TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                    ),),
                                ),
                                //  Image.asset('assets/Images/add_location.png',height: 14,),
                              ],
                            ),
                          ),
                        ),

                      ],
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
                    String bookingForStatus = postList[position].bookingForStatus;
                    String fromDate = postList[position].fromDate;
                    String toDate = postList[position].toDate;
                    String startTime = postList[position].startTime;
                    String endTime = postList[position].endTime;
                    String noOfHour = postList[position].noOfHour;
                    String email = postList[position].userEmail;
                    String chatUserIdd = postList[position].userId;
                    String totalAmount = postList[position].calculatedAmount;
                    String click ="Order";

                   String documnetId = postList[position].documentId;
                   print("SOCUment Id : "+documnetId);

                    String calculatedAmount = postList[position].calculatedAmount;
                    String transaction_id = postList[position].transaction_id;
                    String receiverDeviceToken = postList[position].receiverDeviceToken;
                    String cancellationDate = postList[position].cancellationDate;
                    String compareDocID = postList[position].compareDocID;
                    String id = postList[position].id;
                    String subCategories = postList[position].subCategories;
                    String compareTime = postList[position].compareTime;

                    List<String> imageList = postList[position].names;

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                            CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                              location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                              postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                              fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                            documnetId: documnetId,cancellationDate:cancellationDate,
                              userId: chatUserIdd,cancellationPost:"Cancelled",totalAmount:totalAmount,compareDocID:compareDocID,
                              compareTime: compareTime,
                              refundAmount: amount.round().toString(),subCategories:subCategories)));


                    from_mybooking=false;
                    setState(() {});

                  },
                ),
              ):Container();
          }

          else if (postList[position]
              .title
              .toLowerCase()
              .contains(editingController.text) ) {
            return postList[position].bookingStatus == "Cancelled"?
            Padding(
              padding: EdgeInsets.only(left: 6,right: 6),
              child: GestureDetector(
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4,right:4,),
                                child: Card(
                                  child:  Container(
                                    padding: EdgeInsets.all(4.0),
                                    width: MediaQuery.of(context).size.width*0.24,
                                    height: MediaQuery.of(context).size.width*0.24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                      //shape: BoxShape.rectangle,
                                    ),child: CachedNetworkImage(
                                    imageUrl: postList[position].names[0],
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  ),
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text( ('${postList[position].title.toLowerCase()}'),
                                    style: TextStyle(fontSize: 14,
                                        color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                  SizedBox(height: 11,),

                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                      SizedBox(width: 4,),
                                      Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ):Row(
                                    children: [
                                      Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                          ,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 4,),
                                      Text(postList[position].fromDate,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  SizedBox(height: 9,),
                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
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
                                  SizedBox(height: 9,),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.60,
                                    child:  Text(postList[position].userName,
                                      maxLines:2,
                                      overflow:TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            left: 230.0,
                            //right: 6,

                            child:  Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 22.0,
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(left: 21.3),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                                side: BorderSide(color: Colors.red,),
                                              ),
                                              onPressed: () {},
                                              color: Colors.red,
                                              textColor: Colors.white,
                                              child: Text('\$'+ amount.round().toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500
                                                    ,fontFamily: 'Montserrat'),
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),

                                    Row(
                                      children: [
                                        Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    postList[position].bookingForStatus == "Hour"
                                        ?Row(
                                      children: [
                                        Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    )
                                        :Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 38.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                              bottomRight: Radius.circular(9.0)),
                          color: Color(0xfff8fcff),
                        ),

                        child:  Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text( postList[position].address,
                                  maxLines:2,
                                  overflow:TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                  ),),
                              ),
                              //  Image.asset('assets/Images/add_location.png',height: 14,),
                            ],
                          ),
                        ),
                      )
                    ],
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
                  String bookingForStatus = postList[position].bookingForStatus;
                  String fromDate = postList[position].fromDate;
                  String toDate = postList[position].toDate;
                  String startTime = postList[position].startTime;
                  String endTime = postList[position].endTime;
                  String noOfHour = postList[position].noOfHour;
                  String email = postList[position].userEmail;
                  String totalAmount = postList[position].calculatedAmount;
                  String click ="Order";

                  String calculatedAmount = postList[position].calculatedAmount;
                  String transaction_id = postList[position].transaction_id;
                  String receiverDeviceToken = postList[position].receiverDeviceToken;
                  String cancellationDate = postList[position].cancellationDate;
                  String compareDocID = postList[position].compareDocID;
                  String id = postList[position].id;
                  String subCategories = postList[position].subCategories;
                  String compareTime = postList[position].compareTime;

                  List<String> imageList = postList[position].names;

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                            location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                            postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                            fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                              cancellationPost:"Cancelled",cancellationDate:cancellationDate,totalAmount:totalAmount,
                              compareDocID:compareDocID,compareTime:compareTime,
                              refundAmount: amount.round().toString(),subCategories:subCategories)));
                  from_mybooking=false;


                  setState(() {});

                },
              ),
            ):Container();
          }

          else
            {
            return Container();
            }

        });
  }


  ListView journeyDateFilterListView() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: postList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          if (postList[position]
              .fromDate
              .toLowerCase()
              .contains(editingDateController.text) ) {
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
                    children: [
                      Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4,right:4,),
                                child: Card(
                                  child:  Container(
                                    padding: EdgeInsets.all(4.0),
                                    width: MediaQuery.of(context).size.width*0.24,
                                    height: MediaQuery.of(context).size.width*0.24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                      //shape: BoxShape.rectangle,
                                    ),child: CachedNetworkImage(
                                    imageUrl: postList[position].names[0],
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  ),
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  ('${postList[position].title.toLowerCase()}'),
                                    style: TextStyle(fontSize: 14,
                                        color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                  SizedBox(height: 11,),

                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                      SizedBox(width: 4,),
                                      Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ):Row(
                                    children: [
                                      Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                          ,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 4,),
                                      Text(('${postList[position].fromDate.toLowerCase()}'),style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  SizedBox(height: 9,),
                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                      SizedBox(width: 4,),
                                      Text(('${postList[position].fromDate.toLowerCase()}'),style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
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
                                  SizedBox(height: 9,),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.60,
                                    child:  Text(postList[position].userName,
                                      maxLines:2,
                                      overflow:TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            left: 230.0,
                            //right: 6,

                            child:  Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 22.0,
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(left: 21.3),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                                side: BorderSide(color: Color(0xff4996f3),),
                                              ),
                                              onPressed: () {},
                                              color:postList[position].bookingStatus == "Cancelled"?Colors.red: Color(0xff4996f3),
                                              textColor: Colors.white,
                                              child:  Text('\$'+ postList[position].calculatedAmount,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500
                                                    ,fontFamily: 'Montserrat'),
                                              )

                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),

                                    Row(
                                      children: [
                                        Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    postList[position].bookingForStatus == "Hour"
                                        ?Row(
                                      children: [
                                        Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    )
                                        :Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 38.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                              bottomRight: Radius.circular(9.0)),
                          color: Color(0xfff8fcff),
                        ),

                        child:  Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text( postList[position].address,
                                  maxLines:2,
                                  overflow:TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                  ),),
                              ),
                              //  Image.asset('assets/Images/add_location.png',height: 14,),
                            ],
                          ),
                        ),
                      ),

                    ],
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
                  String bookingForStatus = postList[position].bookingForStatus;
                  String fromDate = postList[position].fromDate;
                  String toDate = postList[position].toDate;
                  String startTime = postList[position].startTime;
                  String endTime = postList[position].endTime;
                  String noOfHour = postList[position].noOfHour;
                  String email = postList[position].userEmail;
                  String click ="Order";

                  String calculatedAmount = postList[position].calculatedAmount;
                  String transaction_id = postList[position].transaction_id;
                  String receiverDeviceToken = postList[position].receiverDeviceToken;
                  String id = postList[position].id;
                  String subCategories = postList[position].subCategories;
                  String compareTime = postList[position].compareTime;

                  List<String> imageList = postList[position].names;

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          CancelBookingPage
                            (id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                            location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                            postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                            fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                          subCategories:subCategories, compareTime: compareTime,)));

                  from_mybooking=false;

                  setState(() {});

                },
              ),
            );
          }else{
            if(noConfirmedBookingAvailable == "0"){
              noConfirmedBookingAvailable = "1";
            }
            return Container();
          }
        });
  }

  ListView journeyDateFilterListView2() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: postList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          if (postList[position]
              .fromDate
              .toLowerCase()
              .contains(editingDateController.text) ) {
            return postList[position].bookingStatus == "Cancelled"?
            Padding(
              padding: EdgeInsets.only(left: 6,right: 6),
              child: GestureDetector(
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4,right:4,),
                                child: Card(
                                  child:  Container(
                                    padding: EdgeInsets.all(4.0),
                                    width: MediaQuery.of(context).size.width*0.24,
                                    height: MediaQuery.of(context).size.width*0.24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                      //shape: BoxShape.rectangle,
                                    ),child: CachedNetworkImage(
                                    imageUrl: postList[position].names[0],
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  ),
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(postList[position].userName,
                                    style: TextStyle(fontSize: 14,
                                        color:Color(0xff4996f3),fontFamily: "Montserrat",fontWeight: FontWeight.w400),),
                                  SizedBox(height: 11,),

                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("No.of hours :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                      SizedBox(width: 4,),
                                      Text(postList[position].noOfHour+" hrs",style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ):Row(
                                    children: [
                                      Text("From Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"
                                          ,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 4,),
                                      Text(('${postList[position].fromDate.toLowerCase()}'),style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  SizedBox(height: 9,),
                                  postList[position].bookingForStatus == "Hour"
                                      ? Row(
                                    children: [
                                      Text("Date :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat"),),
                                      SizedBox(width: 4,),
                                      Text(('${postList[position].fromDate.toLowerCase()}'),style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
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
                                  SizedBox(height: 9,),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.60,
                                    child:  Text( ('${postList[position].title.toLowerCase()}'),
                                      maxLines:2,
                                      overflow:TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: "MontSerrat"),),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            left: 230.0,
                            //right: 6,

                            child:  Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 22.0,
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(left: 21.3),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                                side: BorderSide(color: Colors.red,),
                                              ),
                                              onPressed: () {},
                                              color:  Colors.red,
                                              textColor: Colors.white,
                                              child:  Text('\$'+ postList[position].calculatedAmount,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500
                                                    ,fontFamily: 'Montserrat'),
                                              )

                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),

                                    Row(
                                      children: [
                                        Text("Start Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].startTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    postList[position].bookingForStatus == "Hour"
                                        ?Row(
                                      children: [
                                        Text("End Time :",style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                        SizedBox(width: 4,),
                                        Text(postList[position].endTime,style: TextStyle(color: Colors.black,fontSize: 9,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    )
                                        :Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 38.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0),
                              bottomRight: Radius.circular(9.0)),
                          color: Color(0xfff8fcff),
                        ),

                        child:  Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text( postList[position].address,
                                  maxLines:2,
                                  overflow:TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11,fontFamily: "Montserrat",
                                  ),),
                              ),
                              //  Image.asset('assets/Images/add_location.png',height: 14,),
                            ],
                          ),
                        ),
                      ),

                    ],
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
                  String bookingForStatus = postList[position].bookingForStatus;
                  String fromDate = postList[position].fromDate;
                  String toDate = postList[position].toDate;
                  String startTime = postList[position].startTime;
                  String endTime = postList[position].endTime;
                  String noOfHour = postList[position].noOfHour;
                  String email = postList[position].userEmail;
                  String click ="Order";

                  String calculatedAmount = postList[position].calculatedAmount;
                  String transaction_id = postList[position].transaction_id;
                  String receiverDeviceToken = postList[position].receiverDeviceToken;
                  String id = postList[position].id;
                  String subCategories = postList[position].subCategories;
                  String compareTime = postList[position].compareTime;

                  List<String> imageList = postList[position].names;

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          CancelBookingPage(id: id.toString(),receiverDeviceToken: receiverDeviceToken,transaction_id: transaction_id,calculatedAmount: calculatedAmount,title: title, description: description,
                            location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                            postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,bookingForStatus: bookingForStatus,
                            fromDate:fromDate, toDate:toDate, startTime:startTime, endTime:endTime, noOfHour:noOfHour,userEmail: email,click: click,
                          subCategories:subCategories, compareTime: compareTime,)));

                  from_mybooking=false;

                  setState(() {});

                },
              ),
            ):Container();
          }else{
            return Container();
          }
        });
  }


  Future<void> orderList() async {
    postList.clear();

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    Query query = FirebaseFirestore.instance
        .collection('users').doc(user.uid).collection("my_order");
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
        String username = values['userName'];
        String useremail = values['userEmail'];
        String bookingForStatus = values['bookingForStatus'];
        String calculatedAmount = values['calculatedAmount'];
        String documnetId = values['documentId'];
        String chatUserId = values['userBookingId'];

        String transaction_id = values['transaction_id'];
        String receiverDeviceToken = values['receiverDeviceToken'];
        String cancellationDate = values['cancellationDate'];
        String compareDocID = values['compareDocID'];
        String subCategories = values['subCategories'];
        String compareTime = values['compareTime'];



        posting.names = List.from(document['imageNames']);
        print("images list "+posting.names.length.toString());

      /*  posting.address = address;
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
        posting.userName = username;
        posting.userEmail = useremail;
        posting.calculatedAmount = calculatedAmount;*/


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
            posting.userName = username;
            posting.userEmail = useremail;
            posting.calculatedAmount = calculatedAmount;
            posting.documentId = documnetId;
            posting.userId = chatUserId;
            posting.transaction_id = transaction_id;
            posting.receiverDeviceToken = receiverDeviceToken;
            posting.cancellationDate = cancellationDate;
            posting.compareDocID = compareDocID;
            posting.compareTime = compareTime;
          //  posting.subCategories = subCategories;
            posting.id = id;


          }
        }
        postList.add(posting);
      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

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
       // print(values);
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

      orderList();
      setState(() {});
    });
  }

}
