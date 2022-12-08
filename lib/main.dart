import 'dart:async';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/DashboardCategoryPage.dart';
import 'package:bizitme/Screens/ForgotPasswordScreen.dart';
import 'package:bizitme/Screens/HouseListPage.dart';
import 'package:bizitme/Screens/MainStartPage.dart';
import 'package:bizitme/Screens/MyBookingPage.dart';
import 'package:bizitme/Screens/RVListPage.dart';
import 'package:bizitme/Screens/RoomListPage.dart';
import 'package:bizitme/Screens/SelectionPage.dart';
import 'package:bizitme/Screens/SelectionRvPersonalPage.dart';
import 'package:bizitme/Screens/StorageListPage.dart';
import 'package:bizitme/Screens/UploadCategoryImage.dart';
import 'package:bizitme/Screens/bookPostingPage.dart';
import 'package:bizitme/Screens/conversationPage.dart';
import 'package:bizitme/Screens/createPostingPage.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Screens/hostHomePage.dart';
import 'package:bizitme/Screens/loginPage.dart';
import 'package:bizitme/Screens/personalinfoPage.dart';
import 'package:bizitme/Screens/signUpPage.dart';
import 'package:bizitme/Screens/viewProfilePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/LoginOtp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Bizitme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        MainStartPage.routeName: (context) => MainStartPage(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        SelectionPage.routeName: (context) => SelectionPage(),
        SelectionRvPersonalPage.routeName: (context) => SelectionRvPersonalPage(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        GuestHomePage.routeName: (context) => GuestHomePage(),
        PersonalInfoPage.routeName: (context) => PersonalInfoPage(),
        ViewProfilePage.routeName: (context) => ViewProfilePage(),
        BookPostingPage.routeName: (context) => BookPostingPage(),
        ConversationPage.routeName: (context) => ConversationPage(),
        HostHomePage.routeName: (context) => HostHomePage(),
        CreatePostingPage.routeName: (context) => CreatePostingPage(),

        RVListPage.routeName: (context) => RVListPage(),
        StorageListPage.routeName: (context) => StorageListPage(),
        RoomListPage.routeName: (context) => RoomListPage(),
        HouseListPage.routeName: (context) => HouseListPage(),
      },
    );

  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    handleSession(context);
  }

  void handleSession(BuildContext context) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool Session = preferences.getBool(AppConstants.Session);

    Future.delayed(Duration(seconds: 4), ()  {

      if (Session == true) {
        Navigator.pushReplacementNamed(context,GuestHomePage.routeName);
      }else {
        Navigator.pushReplacementNamed(context, MainStartPage.routeName);
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 180,
          height: 180,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          child: Image.asset("assets/Images/Logo.png"
            ,fit: BoxFit.contain,
          ),
        ),
      ),

    );
  }
}
