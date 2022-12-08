import 'dart:io';

import 'package:bizitme/Screens/DashboardCategoryPage.dart';
import 'package:bizitme/Screens/MyOrdersListPage.dart';
import 'package:bizitme/Screens/accountPage.dart';
import 'package:bizitme/Screens/explorePage.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Screens/inboxPage.dart';
import 'package:bizitme/Screens/savedPage.dart';
import 'package:bizitme/Screens/tripsPage.dart';
import 'package:bizitme/Utils/LocalNotificationConfig.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


import 'ProfilePage.dart';
import 'WishlistPage.dart';

class GuestHomePage extends StatefulWidget {
  static final String routeName = '/guestHomePageRoute';
  final String indexCount;
  GuestHomePage({Key key, this.indexCount}) : super(key: key);

  @override
  _GuestHomePageState createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {

  int _selectedIndex = 0;
  DateTime currentBackPressTime;


  final List<String> _pageTitles = [
    'Explore',
    'Wishlist',
    'Add Post',
    'Request',
    'Profile',
  ];


  //EXIT APP
  _ShowExitDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: _buildChildExit(context),
          );
        });
  }

  //CUSTOM DIALOG CODE
  _buildChildExit(BuildContext context) => Container(
      child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      "Sure you want to Exit?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1,
                          fontFamily: "SEGOEUI",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.height * 0.01,
                          ),

                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child:  Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height * 0.01,
                                  top: 10,
                                  bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.20,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "No",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1,
                                              fontFamily: "SEGOEUI",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      )),
                                ],
                              ),

                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.01,
                              right: MediaQuery.of(context).size.height * 0.01,
                              top: MediaQuery.of(context).size.height * 0.01,
                              bottom: MediaQuery.of(context).size.height * 0.01),
                          child:InkWell(
                            onTap: (){
                              SystemNavigator.pop();
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height * 0.01,
                                  top: 10,
                                  bottom: 10),
                              decoration: BoxDecoration(
                                color:Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.20,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1,
                                              fontFamily: "SEGOEUI",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize:14),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  new SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ],
          )));



  // URL LAUNCHER TO OPEN APP STORE
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


/*
  checkVersion() async {
    final checkVersion = CheckVersion(context: context);
    final appStatus = await checkVersion.getVersionStatus();
    if (appStatus.canUpdate) {
      _showVersionDialog(context);
    }
    print("canUpdate ${appStatus.canUpdate}");
    print("localVersion ${appStatus.localVersion}");
    print("appStoreLink ${appStatus.appStoreUrl}");
    print("storeVersion ${appStatus.appStoreUrl}");
  }
*/


  //DIALOG IF UPDATE IS AVAILABLE
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(''),
            ),
            /* FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),*/
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL('https://play.google.com/store/apps/details?id=com.appacore.bizitme'),
            ),
          ],
        );
      },
    );
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LocalNotificationConfi localNotificationConfi = new LocalNotificationConfi();



  @override
  void initState(){
    super.initState();
    // checkVersion();
    if(widget.indexCount == null){
      _selectedIndex = 0;
    }else{
      _selectedIndex = int.parse(widget.indexCount);
    }

    localNotificationConfi.init(_scaffoldKey);
    configueFirebaseMsg();

     setState(() {});
  }

  configueFirebaseMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("ininitialmsg ${message}");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // onMessage when app is open
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print("inonmessage ${message}");

      localNotificationConfi.displayNotification(message.notification.title,message.notification.body);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      // onResume and onLaunch combination

      print('A new onMessageOpenedApp event was published!');
      print("inonmessageopenedapp ${message}");


    });


  }



  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0.0;
    return WillPopScope( onWillPop: (){
      if(_selectedIndex == 2 ||_selectedIndex == 3 || _selectedIndex == 4){
        _selectedIndex = 0;
      }else{
        _ShowExitDialog(context);
      }

      setState(() {});
    },
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: _getBody(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: keyboardIsOpened ? null : FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DashBoardCategoryPage()));
            setState(() {
              _selectedIndex = _selectedIndex;
            },
            );
          },
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/Images/add_post.png',),
                ]
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 54,
          child: BottomNavigationBar(
            elevation: 40,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/Images/explore_bl.png', height: 20,
                    width: 20,
                    color: _selectedIndex == 0 ? Colors.red : Colors.black),
                title: Text('Explore', style: TextStyle(fontSize: 12,
                  color: _selectedIndex == 0 ? Colors.red : Colors.black,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,),),
              ),

              BottomNavigationBarItem(
                icon: Image.asset('assets/Images/wishlist_bl.png', height: 20,
                    width: 20,
                    color: _selectedIndex == 1 ? Colors.red : Colors.black),
                title: Text('Wishlist', style: TextStyle(fontSize: 12,
                    color: _selectedIndex == 1 ? Colors.red : Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),),

              ),

              BottomNavigationBarItem(
                icon: Image.asset('assets/Images/add_post.png', height: 20,
                    width: 0,
                    color: _selectedIndex == 2 ? Colors.red : Colors.black),
                title: Text('AddPost', style: TextStyle(fontSize: 12,
                    color: _selectedIndex == 2 ? Colors.red : Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),),
              ),

              BottomNavigationBarItem(
                icon: Image.asset('assets/Images/orders-1.png', height: 20,
                    width: 20,
                    color: _selectedIndex == 3 ? Colors.red : Colors.black),
                title: Text('Order', style: TextStyle(fontSize: 12,
                    color: _selectedIndex == 3 ? Colors.red : Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),),

              ),

              BottomNavigationBarItem(
                icon: Image.asset('assets/Images/profile_bl.png', height: 20,
                    width: 20,
                    color: _selectedIndex == 4 ? Colors.red : Colors.black),
                title: Text('Profile', style: TextStyle(fontSize: 12,
                    color: _selectedIndex == 4 ? Colors.red : Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),),

              ),
            ],
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),

        ),
      ),);
  }


  void _onItemTapped(int index) {

    if (index == 2) {
      return;
    }
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  Widget _getBody(int index) {

    switch (index) {
      case 0:
        return ExplorePage();
      case 1:
        return WishlistPage();
      case 2:
        return null;
      case 3:
        return MyOrderListPage();
      case 4:
        return ProfilePageClass();
    }
    return Center(child: Text("There is no page builder for this index."),);

  }


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
     // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    return Future.value(true);
  }

}
