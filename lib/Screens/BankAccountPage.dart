import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/BookingPaymentRequest.dart';
import 'package:bizitme/Models/BookingPaymentResponse.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/SendNotficationRequestModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/MyBookingPage.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/repository/common_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/painting.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:bizitme/Utils/custom_progress_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:uuid/uuid.dart';


class BankAccountPage extends StatefulWidget {

  final String priceText;
  final String documentId;
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
  final String addPostUserId;
  final String fromDate;
  final String toDate;
  final String showStartTime;
  final String showEndTime;
  final String stripeAccountLink;
  final String noOfHour;
  final String calculatedAmount;
  final String deviceToken;
  final String receiverDeviceToken;
  final String documentIdAdd;
  final String userId;
  final String subCategories;
  final List<String> stringDays;
  final List<String> names;


  BankAccountPage({Key key, this.priceText, this.documentId,this.title, this.description, this.location, this.priceDay
    ,this.priceWeek, this.priceHour, this.categoryName, this.names, this.postingDate, this.latitude,
    this.longitude, this.latlng,this.addPostUserId, this.fromDate, this.toDate, this.showStartTime,
  this.showEndTime, this.stringDays, this.stripeAccountLink, this.noOfHour, this.calculatedAmount, this.deviceToken,
  this.receiverDeviceToken, this.documentIdAdd,this.userId, this.subCategories}) : super(key: key);


  @override
  _BankAccountPageState createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  BuildContext dialog_context;

  ProgressDialog _progressDialog = new ProgressDialog();

  int _selectedDrawerIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Token _paymentToken;
  String strtokentid = "";

  var _loadImage;
  int _cIndexTab = 0;

  bool show_edit = true;
  bool show_delete = true;
  bool flagotherstabs = true;
  bool active_avail_data = false;


  Timer timer_updatelocation;

  String strUserId = "";
  String strContactnumber = "";
  String strusertype = "";
  String strbidid = "";
  String strbidprice = "";
  String stripeAccoutLink = "";

  final TextEditingController txtCardHoldername = new TextEditingController();
  final TextEditingController txtCardnumber = new TextEditingController();
  final TextEditingController txtCardExpiryMonth = new TextEditingController();
  final TextEditingController txtCardYear = new TextEditingController();
  final TextEditingController txtCardCVV = new TextEditingController();

  final TextEditingController txtCardnumber1 = new TextEditingController();
  final TextEditingController txtCardnumber2 = new TextEditingController();
  final TextEditingController txtCardnumber3 = new TextEditingController();
  final TextEditingController txtCardnumber4 = new TextEditingController();

  final FocusNode txtCardHoldername_focus = FocusNode();
  final FocusNode txtCardnumber_focus = FocusNode();
  final FocusNode txtCardExpiryMonth_focus = FocusNode();
  final FocusNode txtCardYear_focus = FocusNode();
  final FocusNode txtCardCVV_focus = FocusNode();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode txtCardnumber_focus1 = FocusNode();
  final FocusNode txtCardnumber_focus2 = FocusNode();
  final FocusNode txtCardnumber_focus3 = FocusNode();
  final FocusNode txtCardnumber_focus4 = FocusNode();
  String strCardnumber = "";
  List<String> _imagesUrl = [] ;
  List<String> dateList = [];
  String firstName = "";
  String emailmain = "";
  String deviceToken;
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  String TestKey ="pk_test_8rYgqziVzih8wJZgo1sZhBh300JNObJeax";
 // String TestKey ="pk_live_c5E5SMdZOShtWacsFRzf5YIN00lVDBJtaL";
  bool save_card_image =false;

  String receiverToken = "";
  String currentTime = "";

  void getImage()async{
    _imagesUrl.clear();
    for(int i=0; i< widget.names.length; i++){
      print("IMAGES NAME "+widget.names[i]);
      _imagesUrl.add(widget.names[i]);
    }
    setState(() {});
  }

  void getDate()async{
    dateList.clear();
    for(int i=0; i< widget.stringDays.length; i++){
      print("SELECTED DATE FROM DATE TIME PAGE: "+widget.stringDays[i]);
      dateList.add(widget.stringDays[i]);
    }
    setState(() {});
  }

  Future<String> getDeviceToken() async {
    deviceToken = await  FirebaseMessaging.instance.getToken();
    print("DEVICE ID : " +deviceToken);
    return deviceToken;
  }



  @override
  void initState() {
    //this.strbidid = widget.strbidid;
  //  this.strbidprice = widget.strbidprice;
    this.stripeAccoutLink = widget.stripeAccountLink;

  //  print(" widget.receiverDeviceToken "+  widget.receiverDeviceToken);

    getImage();
    getDate();
    getProfileData();
    super.initState();
    checkCardDetails();
    StripePayment.setOptions(StripeOptions(publishableKey: TestKey));
    getDeviceToken();

    updateTokenInAllPost();

    currentTime = DateFormat('hh:mm a').format(DateTime.now());
    setState(() {});
  }

  checkCardDetails() async {

    String str_CARD_NUMBER1 = await SHDFClass.readSharedPrefString(AppConstants.CARD_NUMBER1, "");
    String str_CARD_NUMBER2 = await SHDFClass.readSharedPrefString(AppConstants.CARD_NUMBER2, "");
    String str_CARD_NUMBER3 = await SHDFClass.readSharedPrefString(AppConstants.CARD_NUMBER3, "");
    String str_CARD_NUMBER4 = await SHDFClass.readSharedPrefString(AppConstants.CARD_NUMBER4, "");
    String str_EXPIRY_MONTH = await SHDFClass.readSharedPrefString(AppConstants.EXPIRY_MONTH, "");
    String str_EXPIRY_YEAR= await SHDFClass.readSharedPrefString(AppConstants.EXPIRY_YEAR, "");
    String str_CARD_HOLDER_NAME= await SHDFClass.readSharedPrefString(AppConstants.CARD_HOLDER_NAME, "");

    print("str_CARD_NUMBER1"+str_CARD_NUMBER1);

    if(str_CARD_NUMBER1!="")
    {
      save_card_image=true;
    }
    txtCardnumber1.text=str_CARD_NUMBER1;
    txtCardnumber2.text=str_CARD_NUMBER2;
    txtCardnumber3.text=str_CARD_NUMBER3;
    txtCardnumber4.text=str_CARD_NUMBER4;
    txtCardExpiryMonth.text=str_EXPIRY_MONTH;
    txtCardYear.text=str_EXPIRY_YEAR;
    txtCardHoldername.text=str_CARD_HOLDER_NAME;

    setState(() {

    });
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: txtCardnumber_focus1,
        ),
        KeyboardActionsItem(
          focusNode: txtCardnumber_focus2,
        ),
        KeyboardActionsItem(
          focusNode: txtCardnumber_focus3,
        ),
        KeyboardActionsItem(
          focusNode: txtCardnumber_focus4,
        ),
        KeyboardActionsItem(
          focusNode: txtCardExpiryMonth_focus,
        ),
        KeyboardActionsItem(
          focusNode: txtCardYear_focus,
        ),
        KeyboardActionsItem(
          focusNode: txtCardCVV_focus,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    dialog_context = context;
    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');
        //trigger leaving and use own data
        Navigator.pop(context, true);
        return Future.value(false);
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "",
          home: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/dashboard_toolbar.png"),
                      fit: BoxFit.none,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[],
                backgroundColor: Colors.blue,
                title: Text(
                  "Payment Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                      fontSize: 20,fontFamily: "Montserrat"
                  ),
                ),
                centerTitle: true,
              ),
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              body: DoubleBackToCloseApp(
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 5, right: 5, bottom: 5),
                  child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      child: Container(
                        height: double.infinity,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("assets/images/bg_img.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: KeyboardActions(
                          //  isDialog: widget.isDialog,
                            config: _buildConfig(context),
                            child: new Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 50.0,right: 50.0,top: 10,bottom: 0),
                                        child: Image.asset('assets/Images/card-payment.png'),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(top: 20, left: 15,),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'CARD NUMBER*',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12, color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 15, left: 15,top: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 60, height: 30,
                                              margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                              child: Platform.isIOS
                                                  ? TextFormField(
                                                maxLength: 4,
                                                cursorColor: Colors.black,
                                                controller: txtCardnumber1,

                                                onChanged: (text) {
                                                  if (text.length == 4) {
                                                    _fieldFocusChange(
                                                        context,
                                                        txtCardnumber_focus1,
                                                        txtCardnumber_focus2);
                                                  }
                                                },

                                                focusNode:
                                                txtCardnumber_focus1,
                                                onFieldSubmitted: (term) {
                                                  _fieldFocusChange(
                                                      context,
                                                      txtCardnumber_focus1,
                                                      txtCardnumber_focus2);
                                                  // process
                                                },

                                                keyboardType:
                                                TextInputType.number,

                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  counterText: "",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width:
                                                          1)),
                                                ),

                                                //Cur,sor color change
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decorationColor: Colors
                                                      .black, //Font color change
                                                ),
                                              )
                                                  : TextFormField(
                                                maxLength: 4,
                                                cursorColor: Colors.black,
                                                controller: txtCardnumber1,

                                                onChanged: (text) {
                                                  if (text.length == 4) {
                                                    _fieldFocusChange(
                                                        context,
                                                        txtCardnumber_focus1,
                                                        txtCardnumber_focus2);
                                                  }
                                                },

                                                focusNode:
                                                txtCardnumber_focus1,
                                                onFieldSubmitted: (term) {
                                                  _fieldFocusChange(
                                                      context,
                                                      txtCardnumber_focus1,
                                                      txtCardnumber_focus2);
                                                  // process
                                                },

                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                    signed: true,
                                                    decimal: true),
                                                inputFormatters: [
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],

                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  counterText: "",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width:
                                                          1)),
                                                ),

                                                //Cur,sor color change
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decorationColor: Colors
                                                      .black, //Font color change
                                                ),
                                              ),
                                            ),

                                            Container(
                                              width: 60,
                                              height: 30,
                                              margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                              child: Platform.isIOS
                                                  ? TextFormField(
                                                maxLength: 4,
                                                cursorColor: Colors.black,
                                                controller: txtCardnumber2,

                                                onChanged: (text) {
                                                  if (text.length == 4) {
                                                    _fieldFocusChange(
                                                        context,
                                                        txtCardnumber_focus2,
                                                        txtCardnumber_focus3);
                                                  }
                                                },

                                                focusNode:
                                                txtCardnumber_focus2,
                                                onFieldSubmitted: (term) {
                                                  _fieldFocusChange(
                                                      context,
                                                      txtCardnumber_focus2,
                                                      txtCardnumber_focus3);
                                                  // process
                                                },

                                                keyboardType:
                                                TextInputType.number,

                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  counterText: "",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width:
                                                          1)),
                                                ),

                                                //Cur,sor color change
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decorationColor: Colors
                                                      .black, //Font color change
                                                ),
                                              )
                                                  : TextFormField(
                                                maxLength: 4,
                                                cursorColor: Colors.black,
                                                controller: txtCardnumber2,

                                                onChanged: (text) {
                                                  if (text.length == 4) {
                                                    _fieldFocusChange(
                                                        context,
                                                        txtCardnumber_focus2,
                                                        txtCardnumber_focus3);
                                                  }
                                                },

                                                focusNode:
                                                txtCardnumber_focus2,
                                                onFieldSubmitted: (term) {
                                                  _fieldFocusChange(
                                                      context,
                                                      txtCardnumber_focus2,
                                                      txtCardnumber_focus3);
                                                  // process
                                                },

                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                    signed: true,
                                                    decimal: true),
                                                inputFormatters: [
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],

                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  counterText: "",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width:
                                                          1)),
                                                ),

                                                //Cur,sor color change
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decorationColor: Colors
                                                      .black, //Font color change
                                                ),
                                              ),
                                            ),

                                            Container(
                                                width: 60,
                                                height: 30,
                                                margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                                child: Platform.isIOS
                                                    ? TextFormField(
                                                  maxLength: 4,
                                                  cursorColor: Colors.black,
                                                  controller:
                                                  txtCardnumber3,

                                                  onChanged: (text) {
                                                    if (text.length == 4) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardnumber_focus3,
                                                          txtCardnumber_focus4);
                                                    }
                                                  },

                                                  focusNode:
                                                  txtCardnumber_focus3,
                                                  onFieldSubmitted: (term) {
                                                    _fieldFocusChange(
                                                        context,
                                                        txtCardnumber_focus3,
                                                        txtCardnumber_focus4);
                                                    // process
                                                  },
                                                  keyboardType:
                                                  TextInputType.number,
                                                  decoration:
                                                  InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    ),
                                                    counterText: "",
                                                    enabledBorder:
                                                    UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width: 1),
                                                    ),
                                                    focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1)),
                                                  ),

                                                  //Cur,sor color change
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    decorationColor: Colors
                                                        .black, //Font color change
                                                  ),
                                                )
                                                    : TextFormField(
                                                  maxLength: 4,
                                                  cursorColor: Colors.black,
                                                  controller:
                                                  txtCardnumber3,

                                                  onChanged: (text) {
                                                    if (text.length == 4) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardnumber_focus3,
                                                          txtCardnumber_focus4);
                                                    }
                                                  },

                                                  focusNode:
                                                  txtCardnumber_focus3,
                                                  onFieldSubmitted: (term) {
                                                    _fieldFocusChange(
                                                        context,
                                                        txtCardnumber_focus3,
                                                        txtCardnumber_focus4);
                                                    // process
                                                  },

                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                      signed: true,
                                                      decimal: true),
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly
                                                  ],

                                                  decoration:
                                                  InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    ),
                                                    counterText: "",
                                                    enabledBorder:
                                                    UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width: 1),
                                                    ),
                                                    focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1)),
                                                  ),

                                                  //Cur,sor color change
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    decorationColor: Colors
                                                        .black, //Font color change
                                                  ),
                                                )),

                                            Container(
                                              width: 60,
                                              height: 30,
                                              margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                              child: Platform.isIOS
                                                  ? TextFormField(
                                                maxLength: 4,
                                                cursorColor: Colors.black,
                                                controller: txtCardnumber4,

                                                focusNode:
                                                txtCardnumber_focus4,
                                                onFieldSubmitted: (term) {
                                                  _fieldFocusChange(
                                                      context,
                                                      txtCardnumber_focus4,
                                                      txtCardExpiryMonth_focus);
                                                  // process
                                                },
                                                keyboardType:
                                                TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  counterText: "",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width:
                                                          1)),
                                                ),

                                                //Cur,sor color change
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decorationColor: Colors
                                                      .black, //Font color change
                                                ),
                                              )
                                                  : TextFormField(
                                                maxLength: 4,
                                                cursorColor: Colors.black,
                                                controller: txtCardnumber4,

                                                focusNode:
                                                txtCardnumber_focus4,
                                                onFieldSubmitted: (term) {
                                                  _fieldFocusChange(
                                                      context,
                                                      txtCardnumber_focus4,
                                                      txtCardExpiryMonth_focus);
                                                  // process
                                                },

                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                    signed: true,
                                                    decimal: true),
                                                inputFormatters: [
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],

                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  counterText: "",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black,
                                                          width:
                                                          1)),
                                                ),

                                                //Cur,sor color change
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decorationColor: Colors
                                                      .black, //Font color change
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(right: 15, left: 15,top: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 0, left: 0,right: 0),
                                                  child: Text(
                                                    'EXPIRY MONTH*',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ),

                                                Container(
                                                  width: 90,
                                                  height: 35,
                                                  margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                                  child: Platform.isIOS
                                                      ? TextFormField(
                                                    maxLength: 2,
                                                    cursorColor:
                                                    Colors.black,
                                                    controller:
                                                    txtCardExpiryMonth,
                                                    focusNode:
                                                    txtCardExpiryMonth_focus,
                                                    onFieldSubmitted:
                                                        (term) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardExpiryMonth_focus,
                                                          txtCardYear_focus);
                                                      // process
                                                    },

                                                    keyboardType:
                                                    TextInputType
                                                        .number,
                                                    decoration:
                                                    InputDecoration(
                                                      hintStyle:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                      counterText: "",
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1)),
                                                    ),

                                                    //Cur,sor color change
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      decorationColor: Colors
                                                          .black, //Font color change
                                                    ),
                                                  )
                                                      : TextFormField(
                                                    maxLength: 2,
                                                    cursorColor:
                                                    Colors.black,
                                                    controller:
                                                    txtCardExpiryMonth,

                                                    focusNode:
                                                    txtCardExpiryMonth_focus,
                                                    onFieldSubmitted:
                                                        (term) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardExpiryMonth_focus,
                                                          txtCardYear_focus);
                                                      // process
                                                    },

                                                    keyboardType:
                                                    TextInputType
                                                        .numberWithOptions(
                                                        signed:
                                                        true,
                                                        decimal:
                                                        true),
                                                    inputFormatters: [
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],

                                                    decoration:
                                                    InputDecoration(
                                                      hintStyle:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                      counterText: "",
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1)),
                                                    ),

                                                    //Cur,sor color change
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      decorationColor: Colors
                                                          .black, //Font color change
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                                                  child: Text(
                                                    'EXPIRY YEAR*',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Container(width: 90, height: 35,
                                                  margin: const EdgeInsets.only(left: 0, top: 0),
                                                  child: Platform.isIOS
                                                      ? TextFormField(
                                                    maxLength: 4,
                                                    cursorColor:
                                                    Colors.black,
                                                    controller:
                                                    txtCardYear,

                                                    focusNode:
                                                    txtCardYear_focus,
                                                    onFieldSubmitted:
                                                        (term) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardYear_focus,
                                                          txtCardCVV_focus);
                                                      // process
                                                    },

                                                    keyboardType:
                                                    TextInputType
                                                        .number,

                                                    decoration:
                                                    InputDecoration(
                                                      hintStyle:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                      counterText: "",
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1)),
                                                    ),

                                                    //Cur,sor color change
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      decorationColor: Colors
                                                          .black, //Font color change
                                                    ),
                                                  )
                                                      : TextFormField(
                                                    maxLength: 4,
                                                    cursorColor:
                                                    Colors.black,
                                                    controller:
                                                    txtCardYear,

                                                    focusNode:
                                                    txtCardYear_focus,
                                                    onFieldSubmitted:
                                                        (term) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardYear_focus,
                                                          txtCardCVV_focus);
                                                      // process
                                                    },

                                                    keyboardType:
                                                    TextInputType
                                                        .numberWithOptions(
                                                        signed:
                                                        true,
                                                        decimal:
                                                        true),
                                                    inputFormatters: [
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],

                                                    decoration:
                                                    InputDecoration(
                                                      hintStyle:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                      counterText: "",
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1)),
                                                    ),

                                                    //Cur,sor color change
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      decorationColor: Colors
                                                          .black, //Font color change
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 0, left:0),
                                                  child: Text(
                                                    'CVV*',
                                                    style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Container(
                                                  width: 90,
                                                  height: 35,
                                                  margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                                  child: Platform.isIOS
                                                      ? TextFormField(
                                                    maxLength: 3,
                                                    controller:
                                                    txtCardCVV,
                                                    cursorColor:
                                                    Colors.black,
                                                    focusNode:
                                                    txtCardCVV_focus,

                                                    onFieldSubmitted:
                                                        (term) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardCVV_focus,
                                                          txtCardHoldername_focus);
                                                      // process
                                                    },
                                                    keyboardType:
                                                    TextInputType
                                                        .number,
                                                    decoration:
                                                    InputDecoration(
                                                      hintStyle:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                      counterText: "",
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1)),
                                                    ),

                                                    //Cur,sor color change
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      decorationColor: Colors
                                                          .black, //Font color change
                                                    ),
                                                  )
                                                      : TextFormField(
                                                    maxLength: 3,
                                                    controller:
                                                    txtCardCVV,
                                                    cursorColor:
                                                    Colors.black,
                                                    focusNode:
                                                    txtCardCVV_focus,

                                                    onFieldSubmitted:
                                                        (term) {
                                                      _fieldFocusChange(
                                                          context,
                                                          txtCardCVV_focus,
                                                          txtCardHoldername_focus);
                                                      // process
                                                    },

                                                    keyboardType:
                                                    TextInputType
                                                        .numberWithOptions(
                                                        signed:
                                                        true,
                                                        decimal:
                                                        true),
                                                    inputFormatters: [
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],

                                                    decoration:
                                                    InputDecoration(
                                                      hintStyle:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                      counterText: "",
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1)),
                                                    ),

                                                    //Cur,sor color change
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      decorationColor: Colors
                                                          .black, //Font color change
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),


                                      Container(
                                        margin:
                                        const EdgeInsets.only(top: 25, left: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'CARD HOLDER NAME',
                                              style: TextStyle(
                                                  fontFamily:
                                                  'Montserrat',
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize: 12,
                                                  color: Colors
                                                      .grey),
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 15,top: 5),
                                        child: new TextFormField(
                                          cursorColor: Colors.black,
                                          controller: txtCardHoldername,

                                          focusNode: txtCardHoldername_focus,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                            counterText: "",
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 1)),
                                          ),

                                          //Cur,sor color change
                                          style: TextStyle(
                                            color: Colors.black,
                                            decorationColor: Colors
                                                .black, //Font color change
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 12, left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[

                                            Text(
                                              'Amount of \$'+widget.calculatedAmount +' will be charged to your account',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                          onTap: () {

                                            if(save_card_image==true)
                                            {
                                              save_card_image=false;
                                            }
                                            else
                                            {
                                              save_card_image=true;
                                            }

                                            setState(() {

                                            });

                                          },
                                          child:
                                          new Container(
                                            padding:
                                            new EdgeInsets
                                                .only(
                                                top:
                                                15,
                                                left: 15),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[

                                                save_card_image?
                                                Image(
                                                    image:  new AssetImage("assets/Images/checkicon_payment.png"),
                                                    height: 20,
                                                    width: 20,
                                                    fit: BoxFit.contain):
                                                Image(
                                                    image:  new AssetImage("assets/Images/uncheckicon_payment.png"),
                                                    height: 20,
                                                    width: 20,
                                                    fit: BoxFit.contain),

                                                Container(
                                                  margin: const EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    'Save card for future',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'candara',
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.green),
                                                  ),
                                                )


                                              ],
                                            ),
                                          )
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          send_topayment();
                                        },
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 10),
                                            padding: EdgeInsets.all(10),
                                            width: 140,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                             color: Colors.blue
                                            ),
                                            child: GestureDetector(
                                              child: Center(
                                                child: new GestureDetector(
                                                    child: new Text("Pay Now",
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontFamily: 'Montserrat',
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                        ))),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        width: 200,
                                        height: 50,
                                        child: Image.asset(
                                          "assets/Images/stripe.png",)))
                              ],
                            )),
                      )
                  ),
                ),
                snackBar: const SnackBar(
                  content: Text('Tap back again to leave'),
                ),
              ),
            ),
          )),
    );
  }

  void send_topayment() {
    strCardnumber = txtCardnumber1.text +
        txtCardnumber2.text +
        txtCardnumber3.text +
        txtCardnumber4.text;

    if (strCardnumber == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please enter card number',
            description: "",
            my_context: context,
          ));
    } else if (strCardnumber.length < 16) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please enter valid card number',
            description: "",
            my_context: context,
          ));
    } else if (txtCardExpiryMonth.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please enter card expiry month',
            description: "",
            my_context: context,
          ));
    } else if (txtCardYear.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please enter card expiry year',
            description: "",
            my_context: context,
          ));
    } else if (txtCardCVV.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please enter card cvv',
            description: "",
            my_context: context,
          ));
    } else if (txtCardHoldername.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please enter card holder name',
            description: "",
            my_context: context,
          ));
    } else {
      if (progressDialog == false) {
        progressDialog = true;
        _progressDialog.showProgressDialog(context,
            textToBeDisplayed: 'loading...', dismissAfter: null);
      }

      send_topayment_api();

    }
  }


//---------------------------------------------------------
  Future send_topayment_api() async {

    print("save_card_image save"+ save_card_image.toString());

    if(save_card_image==true)
    {
      print("str_CARD_NUMBER1 save"+ txtCardnumber1.text.toString());

      SHDFClass.saveSharedPrefValueString(AppConstants.CARD_NUMBER1, txtCardnumber1.text.toString());
      SHDFClass.saveSharedPrefValueString(AppConstants.CARD_NUMBER2, txtCardnumber2.text.toString());
      SHDFClass.saveSharedPrefValueString(AppConstants.CARD_NUMBER3, txtCardnumber3.text.toString());
      SHDFClass.saveSharedPrefValueString(AppConstants.CARD_NUMBER4, txtCardnumber4.text.toString());
      SHDFClass.saveSharedPrefValueString(AppConstants.EXPIRY_MONTH, txtCardExpiryMonth.text.toString());
      SHDFClass.saveSharedPrefValueString(AppConstants.EXPIRY_YEAR, txtCardYear.text.toString());
      SHDFClass.saveSharedPrefValueString(AppConstants.CARD_HOLDER_NAME, txtCardHoldername.text.toString());

    }




    final CreditCard testCard = CreditCard(
      name: txtCardHoldername.text,
      number: strCardnumber,
      expMonth: int.parse(txtCardExpiryMonth.text),
      expYear: int.parse(txtCardYear.text),
      cvc: txtCardCVV.text,

    );

    StripePayment.createTokenWithCard(
      testCard,
    ).then((token) {
      _paymentToken = token;
      strtokentid = token.tokenId;

      setState(() {});

      print("strtokentid" + strtokentid);
      print("_paymentToken" + _paymentToken.toString());
      BookingApi();

    }).catchError(setError);
  }

  void setError(dynamic error) {
  /*  _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));*/

    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    showDialog(
        context: context,
        builder: (BuildContext context1) => OKDialogBox(
          title: "Invalid Card Details",
          description: "",
          my_context: context,
        ));
  }


  //===============================================================

  void BookingApi()async{
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    BookingPaymentRequest bookingPaymentRequest = new BookingPaymentRequest();
    bookingPaymentRequest.bidId = widget.documentId;
    /*if(widget.priceHour != ""){
      bookingPaymentRequest.amount = widget.priceHour;
    }else if(widget.priceDay != ""){
      bookingPaymentRequest.amount = widget.priceDay;
    }else if(widget.priceWeek != ""){
      bookingPaymentRequest.amount = widget.priceWeek;calculatedAmount
    }*/
    bookingPaymentRequest.amount = widget.calculatedAmount;
    bookingPaymentRequest.destinationAccount = stripeAccoutLink;
    bookingPaymentRequest.source = strtokentid;

    BookingPaymentResponse bookingPaymentResponse = await bookingRef(bookingPaymentRequest);
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
      addBooking(bookingPaymentResponse);

    }else{
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
           title: '' + bookingPaymentResponse.msg,
            // title: 'No Data Available',
            description: "",
            my_context: context,
          ));
    }
  }

//---------------------------------------------------------

/*  Future submit_payment() async {
    String userId =
    await SHDFClass.readSharedPrefString(AppConstants.UserId, "");

    final now = new DateTime.now();
    String strdate = DateFormat('yyyy-MM-dd').format(now);
    String strtime = DateFormat('HH:mm:ss').format(now);

    Map map = {
      "bid_id": widget.strbidid,
      "amount": widget.strbidprice,
      "source": strtokentid,
      "pay_date": strdate,
      "pay_time": strtime
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading...', dismissAfter: null);
    }

    await getPaymentSection(API.confirmationPayment, map, context);
  }

  Future<http.Response> getPaymentSection(
      String url, Map jsonMap, BuildContext context) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http
          .post(url, headers: {"Content-Type": "application/json"}, body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        _progressDialog.dismissProgressDialog(context);
        progressDialog = false;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          showDialog(
              context: context,
              builder: (BuildContext context1) => OKDialogBox(
                title: 'Check your internet connections and settings !',
                description: "",
                my_context: context,
              ));

          throw new Exception("Error while fetching data");

        } else {

          storeStripeResponse responseData = new storeStripeResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            _ShowWarningQuaDialog(context);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context1) => Dialog(
                  elevation: 10.0,
                  backgroundColor: Colors.white,
                  child: dialogContent_postsuccessfull(context, ""),
                ));

            setState(() {});
          } else {

            showDialog(
                context: context,
                builder: (BuildContext context1) => OKDialogBox(
                  title: '' + responseData.msg,
                  description: "",
                  my_context: context,
                ));

          }
        }
      });
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Check your internet connections and settings !',
            description: "",
            my_context: context,
          ));
    }
    return responseInternet;
  }*/

//------------------------------------------------------------

  /*Future storeStripeCard() async {

    await SHDFClass.readSharedPrefString(AppConstants.UserId, "");
    Map map = {

      "bid_id":widget.strbidid,
      "pid":widget.pid,
      "amount_to_pay":widget.strbidprice,
      "source":strtokentid
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading...', dismissAfter: null);
    }

    await getStoreStripeCard(API.store_stripe_card, map, context);
  }
  Future<http.Response> getStoreStripeCard(
      String url, Map jsonMap, BuildContext context) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http
          .post(url, headers: {"Content-Type": "application/json"}, body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        _progressDialog.dismissProgressDialog(context);
        progressDialog = false;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          showDialog(
              context: context,
              builder: (BuildContext context1) => OKDialogBox(
                title: 'Check your internet connections and settings !',
                description: "",
                my_context: context,
              ));

          throw new Exception("Error while fetching data");
        } else {
          ConfirmationPaymentResponse responseData =
          new ConfirmationPaymentResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            _ShowWarningQuaDialog(context);

            *//*showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context1) => Dialog(
                  elevation: 10.0,
                  backgroundColor: Colors.white,
                  child: dialogContent_postsuccessfull(context, ""),
                ));*//*

            setState(() {});
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context1) => OKDialogBox(
                  title: '' + responseData.msg,
                  description: "",
                  my_context: context,
                ));
          }
        }
      });
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Check your internet connections and settings !',
            description: "",
            my_context: context,
          ));
    }
    return responseInternet;
  }*/


//------------------------------------------------------------

  _ShowWarningQuaDialog(BuildContext context) {
    return showDialog(
        context: dialog_context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    //  height: MediaQuery.of(context).size.height* 0.40,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.height * 0.01,
                                  MediaQuery.of(context).size.height * 0.01,
                                  MediaQuery.of(context).size.height * 0.01,
                                  MediaQuery.of(context).size.height * 0.01),
                              child: Column(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    "assets/images/payment_sucess.png",
                                    scale: 6,
                                  ),
                                  new SizedBox(
                                    height: 05,
                                  ),
                                  Text(
                                    'Successful',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color((0xff44536a)),
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  new SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                        right:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                    child: Text(
                                      'Payment Completed Successfully',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color((0xff44536a)),
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  new SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(128.0)),
                                    textColor: Colors.white,
                                    color: Color((0xffFab01b)),
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                        MediaQuery.of(context).size.height *
                                            0.00,
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                        MediaQuery.of(context).size.height *
                                            0.00),
                                    child: Text(
                                      'OK',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color((0xff44536a)),
                                        fontSize: 1.8 *
                                            MediaQuery.of(context).size.height *
                                            0.01,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(dialog_context, true);
                                        Navigator.pop(context, true);
                                        // Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        });
  }


//--------------------------------------------------------------

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //GETTING USER DATA
  Future<void> getProfileData() async {

    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();
        String primaryKeyValue = values['address'];
        // print("dekh"+primaryKeyValue);

         emailmain =
        await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
        print(emailmain);

        String email = values['email'];

        if(emailmain ==email){

          setState(() {
            firstName =  values['firstName'];
            firstName = firstName;
            print("FirsetName + "+firstName);

          });
        }
      });

    });
  }


  void addBooking(BookingPaymentResponse bookingPaymentResponse)async{


    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print("Booking user idf "+user.uid);

    PostingModel posting = PostingModel();

    posting.transaction_id = bookingPaymentResponse.transactionId;

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
    posting.imageNames = _imagesUrl;
    posting.categoryName = widget.categoryName;
    posting.postingDate = widget.postingDate;
    posting.latitude = widget.latitude;
    posting.longitude = widget.longitude;
    posting.latlng = widget.latlng;
    posting.bookingStatus ="Confirmed";
    posting.fromDate = widget.fromDate;
    posting.toDate = widget.toDate;
    posting.startTime = widget.showStartTime;
    posting.endTime = widget.showEndTime;
    posting.noOfHour = widget.noOfHour;
    posting.dates = dateList;
    posting.listDates = dateList;
    posting.bookingForStatus = widget.priceText;
    posting.userEmail = emailmain ;
    posting.userName = firstName;
    posting.calculatedAmount = widget.calculatedAmount;
    posting.documentId = widget.documentIdAdd;
    posting.userId = widget.userId;
    posting.userBookingId = user.uid;
    posting.receiverDeviceToken = widget.receiverDeviceToken;
    posting.cancellationDate = "";
    posting.compareDocID = widget.documentId;
    posting.subCategories = widget.subCategories;
    posting.compareTime = currentTime;

    String docId = widget.documentId;

    String fileID = Uuid().v4(); // Generate uuid and store it.

    print("fileID "+fileID);

    posting.MyBoookingInfoInFirestore(widget.documentId).whenComplete(() {
      posting.MyOrderInfoInFirestore(widget.addPostUserId).whenComplete(() {
        posting.MyBoookingAvailableDateInfoInFirestore(docId).whenComplete(() {
          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;
//          sendNotf("Bizitme",widget.title+" post is booked");
          sendNotf("Bizitme","New Booking");
          _ShowBottomSheet_success();
        });
      });
    });


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
                      'Congratulations, your booking is confirmed',
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyBookingPage()));
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


  Future sendNotf(String title, String body1) async {
    // String strSenderToken = await SHDFClass.readSharedPrefString(AppConstants.Token, "");

    final String serverToken = "AAAACnjnL0U:APA91bGDnroPSh5vXZRrPvG1-cUS7V6pK6ic0SLRAJLrauNjvIqpLi_UJcuIGxm5aXnJGMcpZkSsMhRL0wU5PbZ-gVCSqVVsORNB-Hvxflquc3-R2uTR5GHL43m7Jw5AEUz4q9GQedG0";

    SendNotficationRequestModel sendNotficationRequestModel = new SendNotficationRequestModel();
    sendNotficationRequestModel.to = receiverToken;
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
    data.reciver_token = receiverToken;
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


  updateTokenInAllPost() async {

    try
    {

      /*
      QuerySnapshot cars;
      cars = await Firestore.instance.collection('users').getDocuments();

      if (cars != null) {
        for (int i = 0; i < cars.documents.length; i++) {
          String userIdfb = cars.documents[i].documentID;

          print("userId"+userIdfb);

          if (userIdfb == widget.userId) {
             receiverToken = cars.documents[i].data()['device_token'];
            break;
          }
        }
      }
      */


      QuerySnapshot cars;
      cars = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final List<DocumentSnapshot> documents = cars.docs;


      if (cars != null) {
        for (int i = 0; i < documents.length; i++) {
          String userIdfb = documents[i].id;

          print("userId"+userIdfb);

          if (userIdfb == widget.userId) {
            receiverToken = documents[i]['device_token'];
            print("receiverToken "+receiverToken);
            break;
          }
        }
      }


    }
    catch (e)
    {
      print("etttt"+e.toString());
    }


  }

}

