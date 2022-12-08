import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/CancellationPolicy.dart';
import 'package:bizitme/Screens/CancellationPolicyPage.dart';
import 'package:bizitme/Screens/CategoryDeatails.dart';
import 'package:bizitme/Screens/DateAndTimePage.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/SingleChat/ChatScreen.dart';
import 'package:bizitme/SingleChat/Peoples.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:bizitme/Screens/WishlistPage.dart';
import 'package:bizitme/Screens/guestHomePage.dart';

class ListCusrsolPage extends StatefulWidget {
  final String from;
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
  final String documentId;
  final String documentIdAdd;
  final String addPostUserId;
  final String stripeAccountLink;
  final String receiverDeviceToken;
  final String deviceToken;
  final String userId;
  final String subCategories;
  final List<String> names;

  ListCusrsolPage(
      {Key key,
      this.from,
      this.title,
      this.description,
      this.location,
      this.priceDay,
      this.priceWeek,
      this.priceHour,
      this.categoryName,
      this.names,
      this.postingDate,
      this.latitude,
      this.longitude,
      this.latlng,
      this.documentId,
      this.addPostUserId,
      this.deviceToken,
      this.receiverDeviceToken,
        this.documentIdAdd,
        this.userId,
        this.subCategories,
      this.stripeAccountLink})
      : super(key: key);

  @override
  _ListCusrsolPageState createState() => _ListCusrsolPageState();
}

class _ListCusrsolPageState extends State<ListCusrsolPage> {
  List<String> names = new List();
  String radioStatus = "";
  String radioText = "";
  String emailId = "";
  String token = "";
  String name = "";
  String profilePicture = "";
  ProgressDialog _progressDialog = new ProgressDialog();

  bool favourite_on = false;

  void getImage() {
    names.clear();
    for (int i = 0; i < widget.names.length; i++) {
      print("IMAGES NAME " + widget.names[i]);
      names.add(widget.names[i]);
    }
  }


  @override
  void initState() {
    CheckFavourite();
    getImage();
    getProfileData();
    super.initState();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(widget.from=="wishlist")
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '1')));

     /*     Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WishlistPage()));
          setState(() {});*/
        }
        else
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryDeatails(
                      titleName: widget.categoryName,
                    )));
            setState(() {});
          }


        },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Montserrat_Medium",
              ),
              textAlign: TextAlign.center),
          centerTitle: true,
          backgroundColor: Color(0xff4996f3),
          leading: IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {

              if(widget.from=="wishlist")
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '1')));

                /*   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WishlistPage()));
                setState(() {});*/
              }
              else
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryDeatails(
                          titleName: widget.categoryName,
                        )));
                setState(() {});
              }

            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: 200.0,
                      width: 420.0,
                      child: Carousel(
                        images: names
                            .map((e) => Container(
                                  child: Image.network(e),
                                ))
                            .toList(),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat_Medium",
                                  color: Colors.black),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                             InkWell(
                               onTap: ()
                               {

                                 if(favourite_on==true)
                                 {
                                   unFavourite().whenComplete(() {
                                     _progressDialog.dismissProgressDialog(context);
                                     progressDialog = false;
                                     favourite_on=false;
                                     setState(() {});
                                   });
                                 }
                                 else
                                   {
                                     addToFavourite().whenComplete(() {
                                       _progressDialog.dismissProgressDialog(context);
                                       progressDialog = false;
                                       favourite_on=true;
                                       setState(() {});

                                     });
                                   }



                               },

                               child:
                               favourite_on?
                               Image.asset(
                                 'assets/Images/favourite_on.png',
                                 height: 32,
                                 width: 32,
                               )
                               :Image.asset(
                                 'assets/Images/favourite_off.png',
                                 height: 32,
                                 width: 32,
                               ),
                             ),

                             InkWell(
                               onTap: (){
                                 checkUserToken();
                                 setState(() {});
                               },
                               child: Image.asset(
                                 'assets/Images/chat.png',
                                 height: 32,
                                 width: 32,
                               ),
                             )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      flex: 0,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Category',
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
                                        Text(
                                          " " + widget.categoryName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Posting Date',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Montserrat_Medium'),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/Images/date.png',
                                          height: 14,
                                          width: 16,
                                        ),
                                        Text(" " + widget.postingDate,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    "Montserrat_Medium")),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.01,
                            top: MediaQuery.of(context).size.height * 0.01 ),
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
                                    widget.subCategories == null || widget.subCategories ==
                                        ""?"NA": widget.subCategories,
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
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 0, bottom: 0, top: 0),
                        ),
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Montserrat_Medium',
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                widget.priceHour != "" && widget.priceHour != null
                                    ? Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            radioStatus = "1";
                                            radioText = "Hour";
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              radioStatus == "1"
                                                  ? Image.asset(
                                                      'assets/Images/radio_on.png',
                                                      height: 14,
                                                      width: 16,
                                                    )
                                                  : Image.asset(
                                                      'assets/Images/radio_off.png',
                                                      height: 14,
                                                      width: 16,
                                                    ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  '\$'+ widget.priceHour.toString() +
                                                      "/Hour",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.priceDay != "" && widget.priceDay != null
                                    ? Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            radioStatus = "2";
                                            radioText = "Day";
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              radioStatus == "2"
                                                  ? Image.asset(
                                                      'assets/Images/radio_on.png',
                                                      height: 14,
                                                      width: 16,
                                                    )
                                                  : Image.asset(
                                                      'assets/Images/radio_off.png',
                                                      height: 14,
                                                      width: 16,
                                                    ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  '\$' +
                                                      widget.priceDay +
                                                      "/Day",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.priceWeek != "" &&  widget.priceWeek != null
                                    ? Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            radioStatus = "3";
                                            radioText = "Week";
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              radioStatus == "3"
                                                  ? Image.asset(
                                                      'assets/Images/radio_on.png',
                                                      height: 14,
                                                      width: 16,
                                                    )
                                                  : Image.asset(
                                                      'assets/Images/radio_off.png',
                                                      height: 14,
                                                      width: 16,
                                                    ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  '\$' +
                                                      widget.priceWeek +
                                                      "/Week",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 12.0, right: 0, bottom: 0, top: 7),
                            ),
                            Text(
                              '(Price inclusive for all taxes)',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.start,
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
                    margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Montserrat_Medium',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 12.0, right: 0, bottom: 0, top: 5),
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Montserrat_Medium',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 12.0, right: 0, bottom: 0, top: 6),
                        ),
                        Row(
                          children: [
                           InkWell(
                             onTap:(){
                               openMap();
                               setState(() {});
                             },
                             child:  Container(
                               width: MediaQuery.of(context).size.width * 0.80,
                               child: Text(
                                 widget.location,
                                 style: TextStyle(
                                     fontSize: 12,
                                     fontFamily: "Montserrat_Medium",
                                     fontWeight: FontWeight.w400),
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    elevation: 7.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>DateAndTimePage(priceText: radioText,documentId: widget.documentId,)));
                      if (radioText == "") {
                        Fluttertoast.showToast(
                            msg: "Please select price",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DateAndTimePage(
                                    title: widget.title,
                                    description: widget.description,
                                    priceText: radioText,
                                    documentId: widget.documentId,
                                    location: widget.location,
                                    priceDay: widget.priceDay,
                                    priceHour: widget.priceHour,
                                    priceWeek: widget.priceWeek,
                                    categoryName: widget.categoryName,
                                    names: widget.names,
                                    postingDate: widget.postingDate,
                                    latitude: widget.latitude,
                                    longitude: widget.longitude,
                                    latlng: widget.latlng,
                                    addPostUserId: widget.addPostUserId,
                                    deviceToken: widget.deviceToken,
                                    documentIdAdd: widget.documentIdAdd,
                                    userId: widget.userId,
                                    receiverDeviceToken: widget.receiverDeviceToken,
                                    stripeAccountLink:
                                        widget.stripeAccountLink,
                                    subCategories:widget.subCategories)));
                      }
                    },
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    color: Color(0xff4996f3),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CancellationPolicy()));
                    },
                    child: Text(
                      'Cancellation Policy',
                      style: TextStyle(
                          color: Color(0xff2196f3),
                          fontSize: 12,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

    print("clicked");

    QuerySnapshot cars;
    cars = await FirebaseFirestore
        .instance
        .collection(
        'users')
        .get();
    final List<DocumentSnapshot> documents = cars.docs;



    if (cars != null) {

      for (int i = 0; i <documents.length; i++) {
        print(documents[i].reference.id);
        String emailfb = documents[i]['email'];

        if (documents[i].reference.id ==widget.userId) {

          String displayName = name;

          String device_token = documents[i]['device_token'];

          UsersData userData = new UsersData();
          userData.strEmailId = emailId;
          userData.strName = displayName;
          userData.fcmToken = device_token;
          userData.instrument_id =  widget.documentId;
          userData.strprofilepicture = profilePicture;
          userData.title = widget.title;

          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;

          // navivagetoChatScreen(context,userData);
          Route route = MaterialPageRoute(builder: (context) => ChatScreen(userData));
          var nav = await Navigator.of(context).push(route);
          if (nav == true || nav == null) {

          }
          break;
        }
      }
    }



  }


/*  void checkUserToken() async{
    String emailmain =
    await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
    print(emailmain);

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading your chat...', dismissAfter: null);
    }

    print("clicked");
    QuerySnapshot cars;
    cars = await Firestore
        .instance
        .collection(
        'users')
        .getDocuments();

    print(cars.documents.length);

    if (cars != null) {

      for (int i = 0; i <cars.documents.length; i++) {
        String emailfb = cars.documents[i].data()['email'];

        if (emailfb ==emailmain) {

          String displayName = name;

          String device_token = cars.documents[i].data()['device_token'];

          UsersData userData = new UsersData();
          userData.strEmailId = emailId;
          userData.strName = displayName;
          userData.fcmToken = device_token;
          userData.instrument_id =  widget.documentId;
          userData.strprofilepicture = profilePicture;
          userData.title = widget.title;

          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;

          // navivagetoChatScreen(context,userData);
          Route route = MaterialPageRoute(builder: (context) => ChatScreen(userData));
          var nav = await Navigator.of(context).push(route);
          if (nav == true || nav == null) {

          }
          break;
        }
      }
    }
  }*/


  Future<void> getProfileData() async {

    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();
        print(document.id);
        String primaryKeyValue = values['address'];

        if(document.id == widget.userId){

          setState(() {
            name =  values['firstName'];
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


  //Add FAVOURITE
  Future<void> addToFavourite() async {

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    Map<String, dynamic> data = {
      "title": widget.title,
      "description": widget.description,
      "location": widget.location,
      "priceHour": widget.priceHour,
      "priceDay": widget.priceDay,
      "priceWeek": widget.priceWeek,
      "categoryName": widget.categoryName,
      "postingDate": widget.postingDate,
      "latitude": widget.latitude,
      "longitude": widget.longitude,
      "latlng": widget.latlng,
      "documentId": widget.documentId,
      "documentIdAdd": widget.documentIdAdd,
      "addPostUserId": widget.addPostUserId,
      "stripeAccountLink": widget.stripeAccountLink,
      "receiverDeviceToken": widget.receiverDeviceToken,
      "deviceToken": widget.deviceToken,
      "userId": widget.userId,
      "names": widget.names,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    //  await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);

    try
    {
      DocumentReference reference =  await FirebaseFirestore.instance.collection('users').doc(user.uid).collection("my_wishlist").add(data);
      print("reference id "+reference.id);


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

  Future<void> unFavourite() async {

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
          .where("documentId", isEqualTo :widget.documentId)
          .get().then((value){
        value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("users")
              .doc(user.uid)
              .collection("my_wishlist").doc(element.id).delete().then((value){

            print("Success!");

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


  Future<void> CheckFavourite() async {

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
          .where("documentId", isEqualTo :widget.documentId)
          .get().then((value){
        value.docs.forEach((element) {

          favourite_on=true;
setState(() {
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
