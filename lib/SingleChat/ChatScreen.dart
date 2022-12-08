
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Utils/MyUtilClass.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/SingleChat/ChatMessageModel.dart';
import 'package:bizitme/SingleChat/Peoples.dart';
import 'package:bizitme/Utils/custom_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bizitme/SingleChat/send_notf_request_model.dart' as send_notf_req;
import 'package:http/http.dart' as http;
import 'ItemSingleChat.dart';

import 'package:bizitme/Utils/SHDF.dart';

class ChatScreen extends StatefulWidget {
  UsersData usersData;

  ChatScreen(this.usersData);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  bool canEditable = false;
  bool isTexting = false;
  bool isStartRecording = false;
  bool show_sendLayout = true;
  String strMsg = "";
  String strChattingmessage = "No chat history available";

  ProgressDialog _progressDialog = ProgressDialog();

  final TextEditingController txtMsg = TextEditingController();
  ScrollController _controller = new ScrollController();

  bool _isComposingMessage = false;
  bool availstatus = false;
  final reference = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get query =>
      FirebaseFirestore.instance.collection('users').snapshots();
  var _loadImage = new AssetImage('assets/images/noimage.png');
  String strprofilepicture = "";
  bool _checkLoaded = true;
  String currentUserChat = "";
  String strProfileName = "";
  String strProfileEmail = "";
  String profileImage = "";
  String  strSenderToken = "";

  @override
  void initState() {
    // TODO: implement initState.

    getProfileData();

    currentUserChat = widget.usersData.strName;
    strprofilepicture = widget.usersData.strprofilepicture;

   /* if(widget.usersData.post_status=="Completed"){

      show_sendLayout=false;

    }
    else
      {
        show_sendLayout=true;

      }*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(

          leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
            onPressed: (){
              Navigator.pop(context, true);
            },
          ),
          /*GestureDetector(
              onTap: () {

                Navigator.pop(context, true);

              },
              child: Container(
              //  padding: const EdgeInsets.only(left: 0.0, top: 8.0, bottom: 8.0),
                child: Container(
                    child: Image.asset("assets/Images/back.png", fit: BoxFit.cover,
                        scale: 17,)),
              )),*/
          actions: <Widget>[

          ],
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                    imageUrl:  strprofilepicture,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          width: 35,
                          height: 35,
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

                ,),

              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.usersData.strName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'candara',
                  ),
                ),
              ),
            ],
          ),

          centerTitle: false,
        ),

        body: WillPopScope(
            onWillPop: () {
              Navigator.pop(context, true);
            },
            child: new Container(
              child: new Column(
                children: <Widget>[
                  new Expanded(
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: availstatus?
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        // reverse: true,
                        addAutomaticKeepAlives: true,
                        //addSemanticIndexes: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 10),
                        children: messageList.map((value) {
                          return ItemSingleChatMe(
                              value, widget.usersData, playerRefreshPosition,strProfileEmail);
                        }).toList(),
                      ): new Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              strChattingmessage,
                              style: TextStyle(
                                  fontFamily: 'candara',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          )),
                    ),
                  ),
                  new Divider(height: 1.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        child: new Center(
                          child: new Container(
                            margin: new EdgeInsetsDirectional.only(
                                start: 0, end: 0, top: 0),
                            height: 1,
                            // color:Colors.grey,
                            color: Colors.blueGrey[50],
                          ),
                        ),
                      ),
                      show_sendLayout?Container(
                        color: Colors.blue,
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child:
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35.0),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Colors.grey)
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child:
                                        TextField(
                                          controller: txtMsg,
                                          textCapitalization:
                                          TextCapitalization.sentences,
                                          keyboardType: TextInputType.multiline,
                                          textInputAction: TextInputAction.newline,
                                          maxLines: null,

                                          decoration: InputDecoration(
                                              contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 15.0),
                                              hintText: "Write message",
                                              border: InputBorder.none),
                                          onChanged: (text) {
                                            if (text == "") {
                                              isTexting = false;
                                              setState(() {});
                                            } else {
                                              isTexting = true;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                child: Image.asset(
                                  "assets/Images/chatsendimg.png",
                                  fit: BoxFit.contain,
                                  height: 40,
                                ),
                                onLongPress: () {
                                  setState(() {
                                    //_showBottom = true;
                                  });
                                },
                                onTap: () {
                                  if (isTexting) {
                                    strMsg = txtMsg.text;
                                    isTexting = false;
                                    txtMsg.clear();

                                    setState(() {});
                                    sendChat("text");
                                    print("chat clicked");
                                  } else {
                                    print("audio clicked");
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ):Container(),
                    ],
                  ),
                ],
              ),
              decoration: Theme.of(context).platform == TargetPlatform.iOS
                  ? new BoxDecoration(
                      border: new Border(
                          top: new BorderSide(
                      color: Colors.grey[200],
                    )))
                  : null,
            )));
  }

  String selectedChatDocument = "";
  int seenCount = 0;

  // send msg
  Future<void> sendChat(String type) async {

   /* strProfileName=  await SHDFClass.readSharedPrefString(AppConstants.CustName, "");
    strProfileEmail= await SHDFClass.readSharedPrefString(AppConstants.CustEmail,"");*/

    ChatMessageModel chatMessageModel = new ChatMessageModel();
    //   String key = await cryptor.generateRandomKey();
    //  chatMessageModel.key = key;

  //  final String encrypted = await cryptor.encrypt(strMsg,  chatMessageModel.key);
 //   chatMessageModel.postid = widget.usersData.postid;
    chatMessageModel.instrument_id = widget.usersData.instrument_id;
    chatMessageModel.message = strMsg;
    chatMessageModel.file_type = type;
    chatMessageModel.sender_email = strProfileEmail;
    chatMessageModel.date = new MyUtils().getCurrentDate();
    chatMessageModel.time = new MyUtils().getCurrentTimeWithSeconds();

    List<ChatMessageModel> groupMessageModelListTemp = new List();
    groupMessageModelListTemp.add(chatMessageModel);


    final now = new DateTime.now();
    String strdate = DateFormat('yyyy-MM-dd').format(now);
    String strtime = DateFormat('HH:mm:ss').format(now);


    if (selectedChatDocument == "") {
      FirebaseFirestore.instance.collection('ChatMessages').doc().set({
        'sender': strProfileName,
        'sender_email': strProfileEmail,
        'sender_profile': profileImage,
        'receiver_seen': seenCount + 1,
        'sender_seen': 0,
        'receiver': widget.usersData.strName,
        'receiver_email': widget.usersData.strEmailId,
        'receiver_profile': widget.usersData.strprofilepicture,
        'message': jsonDecode(jsonEncode(groupMessageModelListTemp)),
        'instrument_id': widget.usersData.instrument_id,
        'date_time':strdate+" "+strtime+":000",
        //'title':widget.usersData.title
      }).then((onValue) async {
        txtMsg.clear();

        isTexting = false;
        getDocumentID();
        sendNotf(strProfileName, strMsg, widget.usersData.fcmToken, "single_chat", type);

        strMsg = "";
        setState(() {});
      }).catchError((onError) {});
    } else {
      int scount = 0;
      int scount2 = 0;

      if (iamSender) {
        scount = seenCount + 1;
        scount2 = 0;
      } else {
        scount2 = seenCount + 1;
        scount = 0;
      }

      FirebaseFirestore.instance
          .collection("ChatMessages")
          .doc(selectedChatDocument)
          .update({
        'receiver_seen': scount,
        'sender_seen': scount2,
        'message': FieldValue.arrayUnion(jsonDecode(jsonEncode(groupMessageModelListTemp))),
        'date_time':strdate+" "+strtime+":000"
       // 'title':widget.usersData.title
      }).whenComplete(() async {
        txtMsg.clear();
        isTexting = false;
        sendNotf(strProfileName, strMsg, widget.usersData.fcmToken, "single_chat", type);

        strMsg = "";

        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    if (_timerNew != null) {
      _timerNew.cancel();
    }
    currentUserChat = "";
    super.dispose();
  }

  Timer _timerNew;

  void startTimer() {
    const oneSec = const Duration(seconds: 2);
    _timerNew = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          print("timer");
          getDocumentID();
        },
      ),
    );
  }

  // get document id of current chat if available
  Future<void> getDocumentID() async {
    //  strProfileEmail= await Bizitme.readSharedPrefString(AppConstants.CustEmail,"");

    QuerySnapshot cars;
    cars = await FirebaseFirestore.instance.collection('ChatMessages').get();
    final List<DocumentSnapshot> documents = cars.docs;

    if (cars != null) {
      for (int i = 0; i < documents.length; i++) {
        String mycheckSenderEmail = documents[i]['sender_email'];
        String mycheckReceiverEmail = documents[i]['receiver_email'];
        String userEmailID = widget.usersData.strEmailId;
        String instrument_id =  documents[i]['instrument_id'];

        if ((mycheckSenderEmail == strProfileEmail ||
            mycheckReceiverEmail == strProfileEmail) &&
            (mycheckSenderEmail == userEmailID ||
                mycheckReceiverEmail == userEmailID) && instrument_id == widget.usersData.instrument_id)
        {
          selectedChatDocument = documents[i].id;

          try {

            String email1 = documents[i]['receiver_email'];
            String email2 = documents[i]['sender_email'];

            if (email1 != strProfileEmail) {
              seenCount = documents[i]['receiver_seen'];

              FirebaseFirestore.instance
                  .collection("ChatMessages")
                  .doc(selectedChatDocument)
                  .update({
                'sender_seen': 0,
              }).whenComplete(() async {});

              iamSender = true;
            } else {
              seenCount = documents[i]['sender_seen'];

              FirebaseFirestore.instance
                  .collection("ChatMessages")
                  .doc(selectedChatDocument)
                  .update({
                'receiver_seen': 0,
              }).whenComplete(() async {});

              iamSender = false;
            }
          } catch (e) {}
          break;
        }
      }

      if (selectedChatDocument != "") {
        if (_timerNew != null) {
          _timerNew.cancel();
        }

        refreshList();
      } else {
        if (_timerNew == null) {
          startTimer();
        }
      }
    }
  }

  bool iamSender = false;
  List<ChatMessageModel> messageList = new List();

  // refresh list of chat
  Future<void> refreshList() async {
    List<ChatMessageModel> chatListTemp = new List();

    FirebaseFirestore.instance
        .collection('ChatMessages')
        .doc(selectedChatDocument)
        .snapshots()
        .listen((event) async {
      List<dynamic> chatMessages = event['message'];

      try {
        String email1 = event['receiver_email'];
        String email2 = event['sender_email'];

        if (email1 != strProfileEmail) {
          seenCount = event['receiver_seen'];
          iamSender = true;
          print("I AM SENDER");
        } else {
          seenCount = event['sender_seen'];
          iamSender = false;
          print("I AM RECEIVER");
        }
      } catch (e) {}

      print("seencount" + seenCount.toString());
      chatListTemp.clear();
      String preDate = "";
      for (int x = 0; x < chatMessages.length; x++) {
        final Map<String, dynamic> data = chatMessages[x];

        String senderEmail = data["sender_email"];
        String date = data["date"];
        String time = data["time"];
        String message = data["message"];
        String file_type = data["file_type"];

        ChatMessageModel groupMessageModel = new ChatMessageModel();
        groupMessageModel.sender_email = senderEmail;
        groupMessageModel.message = message;
        groupMessageModel.file_type = file_type;

        if (MyUtils().checkNull(file_type) == "audio") {
          String key = data["key"];
          print(key); // - A string to encrypt.

          //   String decrypted = await cryptor.decrypt(message, key);
          //    print(decrypted); // - A string to encrypt.

          groupMessageModel.message = message;

          groupMessageModel.isContainsFile = true;
          //  groupMessageModel.message = message;

        } else {
          try {
            String key = data["key"];
            print(key); // - A string to encrypt.

            // String decrypted = await cryptor.decrypt(message, key);
            // print(decrypted); // - A string to encrypt.

            groupMessageModel.message = message;
          } catch (e) {
            // unable to decrypt (wrong key or forged data)
          }
          // groupMessageModel.message = message;
        }

        if (x == 0) {
          preDate = date;
          groupMessageModel.date = date;
        } else {
          if (preDate != date) {
            groupMessageModel.date = date;
            preDate = date;
          } else {
            groupMessageModel.date = "";
          }
        }
        groupMessageModel.time = time;

        chatListTemp.add(groupMessageModel);
      }

      messageList.clear();
      messageList.addAll(chatListTemp);

      setState(() {

        if(messageList.length>0)
        {
          strChattingmessage="";
          availstatus=true;

        }
        else{
          strChattingmessage="No chat history available";
          availstatus=false;
        }

      });
      Timer(
          Duration(milliseconds: 600),
          () => _controller.animateTo(
                _controller.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 800),
              ));
    });
  }

  playerRefreshPosition(ChangerModel value) {
    for (int i = 0; i < messageList.length; i++) {
      if (value.status == "start") {
        if (value.message == messageList[i].message) {
          messageList[i].isPlaying = true;
        } else {
          messageList[i].isPlaying = false;
        }
      } else {
        if (value.message == messageList[i].message) {
          messageList[i].isPlaying = false;
        } else {
          messageList[i].isPlaying = false;
        }
      }
    }
    setState(() {
      messageList;
    });
  }

  String audioFileName = "";


  // send notification
  Future sendNotf(String title, String body1, String token, String type,
      String file_type) async {

    String strSenderToken =
    await SHDFClass.readSharedPrefString(AppConstants.Token, "");
    strProfileEmail= await SHDFClass.readSharedPrefString(AppConstants.CustEmail,"");

    final String serverToken =
        'AAAACnjnL0U:APA91bGDnroPSh5vXZRrPvG1-cUS7V6pK6ic0SLRAJLrauNjvIqpLi_UJcuIGxm5aXnJGMcpZkSsMhRL0wU5PbZ-gVCSqVVsORNB-Hvxflquc3-R2uTR5GHL43m7Jw5AEUz4q9GQedG0';
    print("token" + widget.usersData.fcmToken);

    send_notf_req.SendNotficationRequestModel sendNotficationRequestModel =
    new send_notf_req.SendNotficationRequestModel();

    sendNotficationRequestModel.to = widget.usersData.fcmToken;
    sendNotficationRequestModel.sound = "default";
    sendNotficationRequestModel.priority = "high";

    send_notf_req.Data data = new send_notf_req.Data();
    //data.androidChannelId = "noti_push_app_1";
    data.clickAction = "FLUTTER_NOTIFICATION_CLICK";
    data.sound = "default";
    data.title = title;

    String msg = "";
    if (file_type == "text") {
      msg = body1;
    } else {
      msg = "Voice message";
    }

    data.body = msg;

    /*  data.type = type;
    data.file_type = file_type;
    data.sender_emailid = strProfileEmail;
    data.sender_profile = strProfileImage;
    data.reciver_token = widget.usersData.fcmToken;
    data.sender_token = strSenderToken;*/

    print("strSenderToken"+strSenderToken);
    send_notf_req.Notification notf = new send_notf_req.Notification();
//    notf.sound = "default";
    notf.title = title;
    notf.body = msg;
    //  notf.contentAvailable = true;
    notf.androidChannelId = "noti_push_app_1";
    sendNotficationRequestModel.notification = notf;

    var body = json.encode(sendNotficationRequestModel);
    print("Chatbody"+body);

    try {
      var responseInternet = await http
          .post( Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'key=$serverToken',
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

  Future<void> getProfileData() async {

    String emailmain = await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
    print(emailmain);

    QuerySnapshot cars;
    cars = await FirebaseFirestore.instance
        .collection('users')
        .get();

    final List<DocumentSnapshot> documents = cars.docs;

    try
    {
      if (cars != null) {

        for (int i = 0; i < documents.length; i++) {


          String email =  documents[i]['email'];


          if(emailmain ==email){

            setState(() {
              strProfileName =  documents[i]['firstName'];
              profileImage = documents[i]['image'];
              print("IMAGE URL : "+profileImage);
              strProfileEmail = documents[i]['email'];
              strSenderToken = documents[i]['device_token'];

            });

          }

        }
      }
    }
    catch(e)
    {
      print("eecccc "+e.toString());
    }



    getDocumentID();
  }


}
