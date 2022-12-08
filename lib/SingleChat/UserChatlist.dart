import 'dart:async';
import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/ChatShowModel.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/SingleChat/Peoples.dart';
import 'package:bizitme/SingleChat/send_notf_request_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'ChatCountModel.dart';
import 'ChatScreen.dart';
import 'package:intl/intl.dart';

class ShareInstrumentUserChatlistPage extends StatefulWidget {
//  final Data model;

 // ShareInstrumentUserChatlistPage(this.model);

  @override
  ShareInstrumentUserChatlistPageState createState() =>
      ShareInstrumentUserChatlistPageState();
}

class ShareInstrumentUserChatlistPageState
    extends State<ShareInstrumentUserChatlistPage> {
  BuildContext dialog_context;

  int _selectedDrawerIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _loadImage = new AssetImage('assets/images/profile_default.png');
  int _cIndexTab = 0;

  bool flagotherstabs = true;

  ProgressDialog _progressDialog = ProgressDialog();
  Timer timer_updatelocation;

  String strUserype = "";
  String strUserId = "";
  String strContact = "";

  String strfirstname = "";
  String strlastname = "";
  String strBusinessname = "";
  String strDesingination = "";
  String strstreetNo = "";
  String strcity = "";
  String strcountry = "";
  String strprovince = "";
  String strpostalcode = "";
  String stremail = "";
  String strphonenumber = "";
  String strName = "";

  bool active_check = true;
  bool completed_check = false;
  bool expired_check = false;
  bool cancelled_check = false;

  String strMsg = "";
  String str_postStatus = "";
  bool active_avail_data = false;

  String instrumentId = "";
 /* List<Datalist> mypostLstApi = new List();
  List<Datalist> mypostLst = new List();*/
  List<ChatShowModel> mypostLst = new List();
  List<ChatShowModel> mypostLstApi = new List();
  List<ChatCountModel> chatEmailListWithCount = new List();
  String strProfileEmail = "";
  bool _checkLoaded = true;
  String message = "";
  String date = "";

  Timer timer;
  int counter = 0;


  @override
  void initState() {
    //timer_updatelocation = Timer.periodic(Duration(seconds: 60), (Timer t) => UPDATE_LOCATION());

    super.initState();


    timer = Timer.periodic(Duration(seconds: 0), (Timer t) => mypostLst);
    getmypost();

    //setMyData();
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    dialog_context=context;
    return Scaffold(
       resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Chat List",style: TextStyle(fontSize: 20,fontFamily: "Montserrat",),textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor:  Color(0xff4996f3),
        leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
          onPressed: (){
            Navigator.pop(context);
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
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new ExactAssetImage('assets/images/background.png'),
                            fit: BoxFit.fill,

                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                mypostLstApi.isNotEmpty
                                    ? Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: new ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: mypostLstApi.length,
                                      reverse: false,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext ctxt, int index) {

                                        String mystring = mypostLstApi[index].userName;
                                        print('${mystring[0]}');

                                        return Container(
                                            child: GestureDetector(
                                              onTap: () async {
                                                try
                                                {
                                                  if (progressDialog == false) {
                                                    progressDialog = true;
                                                    _progressDialog.showProgressDialog(dialog_context,
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
                                                  print(mypostLstApi[index].userEmail);

                                              if (cars != null) {

                                                    for (int i = 0; i < documents.length; i++) {

                                                      String emailfb = documents[i]['email'];

                                                      if (emailfb == mypostLstApi[index].userEmail) {

                                                        String displayName = mypostLstApi[index].userName;
                                                        print("DISPLAY USER NAME ON CLICK : "+displayName);
                                                        String device_token = documents[i]['device_token'];

                                                        UsersData userData = new UsersData();
                                                        userData.strEmailId = emailfb;
                                                        userData.strName = displayName;
                                                        userData.fcmToken = device_token;
                                                        userData.instrument_id = mypostLstApi[index].instrumentId;

                                                        userData.strprofilepicture =mypostLstApi[index].profileImage;

                                                        // navivagetoChatScreen(context,userData);
                                                        Route route = MaterialPageRoute(builder: (context) => ChatScreen(userData));
                                                        var nav = await Navigator.of(context).push(route);
                                                        if (nav == true || nav == null) {
                                                          getmypost();
                                                        }
                                                        break;
                                                      }
                                                    }
                                                    _progressDialog.dismissProgressDialog(dialog_context);
                                                    progressDialog = false;

                                                  }


                                                }
                                                catch(e)
                                                {
                                                  print("chaterror "+e.toString());
                                                  _progressDialog.dismissProgressDialog(dialog_context);
                                                  progressDialog = false;
                                                }

                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(left: 7, right:7),
                                                child: new Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                    ),
                                                    elevation: 5,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Center(
                                                          child: Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: new Container(
                                                              width:MediaQuery.of(context).size.width,
                                                              padding: new EdgeInsets.all(10.0),
                                                              child:


                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    flex:1,
                                                                    child:  Container(
                                                                      width: 28,
                                                                      height: 28,
                                                                      margin: EdgeInsets.only(right: 15),
                                                                      decoration: new BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: mypostLstApi[index].profileImage,
                                                                        imageBuilder: (context, imageProvider) =>
                                                                            Container(
                                                                              width: 28,
                                                                              height: 28,
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(
                                                                                  image: imageProvider,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        placeholder: (context, url) =>
                                                                        _checkLoaded
                                                                            ? Image(image: _loadImage,
                                                                          width: 30,
                                                                          height: 30,)
                                                                            :  Image(image: _loadImage,
                                                                          width: 30,
                                                                          height: 30,),
                                                                      )

                                                                      ,),),
                                                                  Expanded(
                                                                    flex:4,
                                                                    child:  Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      children: [

                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              top: 0,
                                                                              left:
                                                                              0),
                                                                          child: Row(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                margin: const EdgeInsets.only(right: 0),
                                                                                child: Text(
                                                                                  mypostLstApi[index].userName,
                                                                                  style: TextStyle(
                                                                                      fontFamily: 'candara',
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: const EdgeInsets.only(right: 0),
                                                                                width: MediaQuery.of(context).size.width * 0.45,
                                                                                child: Text(
                                                                                  mypostLstApi[index].postTitle == ""?"":" - "+mypostLstApi[index].postTitle,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(
                                                                                      fontFamily: 'candara',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),
                                                                        /* Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      top: 3,
                                                                      left:
                                                                      0),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        width:MediaQuery.of(context).size.width* 0.52,
                                                                        margin: const EdgeInsets.only(right: 0),
                                                                        child: Text(
                                                                          mypostLst[index].message,
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontFamily: 'candara',
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black54),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),*/
                                                                      ],
                                                                    ),),
                                                                  /*  Expanded(
                                                              flex:1,
                                                              child:  Container(
                                                                height: 28,
                                                              margin: const EdgeInsets.only(right: 0),
                                                              child: Text(
                                                                date,
                                                                style: TextStyle(
                                                                    fontFamily: 'candara',
                                                                    fontSize: 9,
                                                                    fontWeight: FontWeight.normal,
                                                                    color: Colors.black),
                                                              ),
                                                            ),)*/
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        new Positioned(
                                                          right: 0,
                                                          bottom: 12,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                            children: <Widget>[
                                                              Container(
                                                                margin:
                                                                const EdgeInsets.only(
                                                                    bottom: 0,
                                                                    right: 5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: <Widget>[
                                                                    mypostLstApi[index]
                                                                        .seenCount ==
                                                                        0
                                                                        ? SizedBox()
                                                                        : Container(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left: 5,
                                                                            right: 5,
                                                                            top: 3,
                                                                            bottom: 3),
                                                                        margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 5,
                                                                            right: 5),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .red,
                                                                            shape: BoxShape
                                                                                .circle),
                                                                        child: new Text(
                                                                            mypostLstApi[
                                                                            index]
                                                                                .seenCount
                                                                                .toString(),
                                                                            style:
                                                                            TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              fontFamily:
                                                                              'candara',
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize:
                                                                              14,
                                                                            )))
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ));
                                      }),
                                )
                                    :Container(
                                  height: MediaQuery.of(context).size.height* 0.80,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset('assets/Images/message_page.png',height: 120,width: 120,),
                                      ),
                                      Text("Your Message is empty",style: TextStyle(fontSize: 18,color: Colors.black,
                                          fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ],
              )
          ),
        )
      ),
    );
  }



  void getmypost() {
    showChatMessage();
  }


  void showChatMessage()async{

    strProfileEmail = await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");


    QuerySnapshot cars;
    cars = await FirebaseFirestore.instance.collection('ChatMessages').get();

    final List<DocumentSnapshot> documents = cars.docs;
    //print(chatListApi[index].custEmail);
    mypostLstApi.clear();
    mypostLst.clear();
    chatEmailListWithCount.clear();
    if (cars != null) {

      for (int i = 0; i < documents.length; i++) {

        String rec_email = documents[i]['receiver_email'];
        String send_email = documents[i]['sender_email'];
        int sender_senn = documents[i]['sender_seen'];
        int receiver_seen = documents[i]['receiver_seen'];
        String instrument_id =  documents[i]['instrument_id'];
        String date_time = documents[i]['date_time'];
        String receiver = documents[i]['receiver'];
        String sender = documents[i]['sender'];
        String profileImg = documents[i]['sender_profile'];
        String receiver_profileImg = documents[i]['receiver_profile'];
        String title="";



        List<dynamic> chatMessages = documents[i]['message'];
        final Map<String, dynamic> data = chatMessages.last;
        print(data["message"]);
         message = data["message"];
         date = data["date"];


       // print(chatMessages.last);
       /* for (int x = 0; x < chatMessages.last; x++) {
          final Map<String, dynamic> data = chatMessages[x];
          print(data["message"]);
        }*/

      //  print("instrument_id "+instrument_id);

        if (rec_email == strProfileEmail && send_email != strProfileEmail) {

          ChatCountModel chatCountModel = new ChatCountModel();
          chatCountModel.email = send_email;
          chatCountModel.seenCount = receiver_seen;
          chatCountModel.instrument_id = instrument_id;
          chatCountModel.date_time = date_time;
          chatEmailListWithCount.add(chatCountModel);

          ChatShowModel chatShowModel = new ChatShowModel();
          chatShowModel.userName = sender;
          chatShowModel.userEmail = send_email;
          chatShowModel.instrumentId = instrument_id;
          chatShowModel.profileImage = profileImg;
          chatShowModel.message = message;
          chatShowModel.postTitle = title;
          mypostLst.add(chatShowModel);

        }
        else if (rec_email != strProfileEmail && send_email == strProfileEmail) {
          ChatCountModel chatCountModel = new ChatCountModel();
          chatCountModel.email = rec_email;
          chatCountModel.seenCount = sender_senn;
          chatCountModel.instrument_id = instrument_id;
          chatCountModel.date_time = date_time;
          chatEmailListWithCount.add(chatCountModel);

          ChatShowModel chatShowModel = new ChatShowModel();
          chatShowModel.userName = receiver;
          chatShowModel.userEmail = rec_email;
          chatShowModel.instrumentId = instrument_id;
          chatShowModel.profileImage = receiver_profileImg;
          chatShowModel.message = message;
          chatShowModel.postTitle = title;
          mypostLst.add(chatShowModel);
        }
      }
    }


    for (int i = 0; i < mypostLst.length; i++) {
      for (int x = 0; x < chatEmailListWithCount.length; x++) {

        if (mypostLst[i].userEmail == chatEmailListWithCount[x].email)
        {

          mypostLst[i].seenCount = chatEmailListWithCount[x].seenCount;
          mypostLst[i].date_time = chatEmailListWithCount[x].date_time;


          if (mypostLst[i].date_time == null) {

            mypostLst[i].date_time ="2020-11-30 11:32:19:000";

          }
          print('date_time'+ chatEmailListWithCount[x].date_time.toString());
          break;
        }
      }
      mypostLstApi.add(mypostLst[i]);
    }

    for (int x = 0; x < mypostLstApi.length; x++) {
      if (mypostLstApi[x].date_time == null) {
        mypostLstApi[x].date_time ="2020-11-24 11:32:19:000";

        print('date_time'+ mypostLstApi[x].date_time.toString());
      }
    }

    try
    {
      DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
      mypostLstApi.sort((a, b) => format
          .parse(b.date_time)
          .compareTo(format.parse(a.date_time)));
    }
    catch (e)
    {
      print("cate__ee"+e.toString());
    }

    setState(() {});
  }


  Future<void> refreshList() async {
      Timer(
          Duration(milliseconds: 600),
              (){
                showChatMessage();
            setState(() {});
              });
    }


  }



