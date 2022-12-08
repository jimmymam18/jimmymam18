
import 'dart:io';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Screens/signUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:bizitme/Models/OtpRequest.dart';
import 'package:bizitme/Models/OtpResponse.dart';
import 'package:bizitme/repository/common_repository.dart';
import 'package:bizitme/Models/MyUtilsClass.dart';


class LoginOtp extends StatefulWidget {
  final String textGetOtp;
  final String textGetMobileNo;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String country;
  final String city;
  final String bio;
  final String address;
  final String password;
  final String codeNumber;
  final File image;


  LoginOtp({Key key, @required this.textGetOtp, @required this.textGetMobileNo, this.image, this.address, this.bio,
  this.city, this.country, this.email, this.gender, this.lastName, this.firstName, this.password, this.codeNumber})
      : super(key: key);

  @override
  _LoginOtpState createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp>  with TickerProviderStateMixin{
  String txtOtp = "";
  String txtResendOtp = "";
  String printOtp = "";
  String deviceId = "";
  ProgressDialog _progressDialog = ProgressDialog();
  bool visibleDialog = true;
  String strSessionToken = "";
  String strSessionAdmId = "";
  AnimationController _controller;
  int levelClock = 120;
  String visibleTimmer = '0';
  String mobilenumber = "";
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseFirestore.instance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void onLoginOtpClick() {
    print("OTP : "+widget.textGetOtp);
    if (txtOtp == "") {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: "Enter Otp",
            description: "",
            my_context: context,
          ));
    } else if (txtOtp == widget.textGetOtp) {
      _signUp();
    } else if (txtOtp == txtResendOtp) {
      _signUp();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title:  "Incorrect Otp!",
            description:"",
            my_context: context,
          ));
    }
  }


  @override
  void initState() {
    super.initState();
    printOtp = widget.textGetOtp;
    mobilenumber = widget.codeNumber;

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );
    Future.delayed(Duration(seconds: 120), () {

      setState(() {
        visibleTimmer = '1';
      });
    });
    _controller.forward();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return WillPopScope(
        onWillPop: (){
          setState(() {
            Navigator.pop(context);
          });
        },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
           body:  WillPopScope(
            onWillPop: () {
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.height * 0.00,
                    MediaQuery.of(context).size.height * 0.03,
                    MediaQuery.of(context).size.height * 0.00,
                    MediaQuery.of(context).size.height * 0.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                        width:MediaQuery.of(context).size.width,
                        child:  Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
                            onPressed: (){
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignUpPage()));
                              Navigator.pop(context);
                            },
                          ),
                        )
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height * 0.80,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Container(
                              width: MediaQuery.of(context).size.height * 0.17,
                              height: MediaQuery.of(context).size.height * 0.17,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: new DecorationImage(
                                    fit: BoxFit.contain,
                                    image: new AssetImage('assets/Images/Logo.png'),
                                  )
                              )
                          ),

                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Container(
                            child : Text(
                              'Enter OTP sent to your mobile number '+mobilenumber,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.black,
                                fontSize:
                                1.9 * MediaQuery.of(context).size.height * 0.01,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Container(
                            child: PinEntryTextField(
                              fieldWidth: MediaQuery.of(context).size.height * 0.08,
                              showFieldAsBox: true,
                              onSubmit: (String pin) {
                                txtOtp = pin;
                                print("TEXT OTP"+txtOtp);
                              }, // end onSubmit
                            ),
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          visibleTimmer == '0'?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Countdown(
                                animation: StepTween(
                                  begin: levelClock, // THIS IS A USER ENTERED NUMBER
                                  end: 0,
                                ).animate(_controller),
                              ),
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Didn\u0027t received OTP?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize:
                                  1.9 * MediaQuery.of(context).size.height * 0.01,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              new SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ResendOtp();
                                  });
                                },
                                child: Text(
                                  'Resend',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.red,
                                    fontSize: 1.9 * MediaQuery.of(context).size.height * 0.01,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ],
                          ),

                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(128.0)),
                            textColor: Colors.white,
                            color: Color((0xff1664c5)),
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.height * 0.05,
                                MediaQuery.of(context).size.height * 0.01,
                                MediaQuery.of(context).size.height * 0.05,
                                MediaQuery.of(context).size.height * 0.01),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize:
                                2.0 * MediaQuery.of(context).size.height * 0.01,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onPressed: () {
                              print(txtResendOtp);
                              onLoginOtpClick();
                              setState(() {
                              });
                            },
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),



                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      )
    );
  }


  void ResendOtp() async {
    FocusScope.of(context).unfocus();

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    OtpRequest otpRequest = new OtpRequest();
    otpRequest.phoneno = widget.codeNumber;
    otpRequest.email = "1";
    otpRequest.userId = "ABC@GMAIL.COM";

    OtpResponse otpResponse = await otpRef(otpRequest);
    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    if(otpResponse == null){
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Something went wrong, Please try again',
            description: "",
            my_context: context,
          ));
    }
    else if(otpResponse.status == "1"){
      txtResendOtp = otpResponse.otp;
     // printOtp = txtResendOtp;
      setState(() {
        visibleTimmer = '0';
        _controller = AnimationController(
            vsync: this,
            duration: Duration(
                seconds: levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );
        Future.delayed(Duration(seconds: 120), () {
          setState(() {
            visibleTimmer = '1';
          });
        });
        _controller.forward();
      });
      print(txtResendOtp);
      setState(() {

      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: "No Data Available",
                description:
                    "",
                my_context: context,
              ));
    }
  }

  Future<void> _signUp() async {
   /* if (!_formKey.currentState.validate() *//*|| this._imageFile == null*//*) {
      return;
    }*/

    String email = widget.email;
    String password = widget.password;


    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading...', dismissAfter: null);
    }

    String _imageURL = "";

    String token = await new MyUtils().getDeviceToken();


    var _result = await CloudStorageService.instance.uploadUserImage(email, widget.image);
    _imageURL = await _result.ref.getDownloadURL();
    print(_imageURL);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password
      );

        await databaseReference.collection("users")
          .doc(userCredential.user.uid)
          .set({
        'firstName':widget.firstName,
        'lastName': widget.lastName,
        'gender' : widget.gender,
        'email': widget.email,
        'mobile':widget.codeNumber,
        'country': widget.country,
        'city': widget.city,
        'bio': widget.bio,
        'isHost': "true",
        'address': widget.address,
        'stripeAccountLink': "",
        'image': ""+_imageURL,
        'device_token': token
      });

      Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, true);
      Bizitme.saveSharedPrefValueString(AppConstants.CustEmail, email);
      Bizitme.saveSharedPrefValueString(AppConstants.CustProfile, _imageURL);

      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      Navigator.pushReplacementNamed(context, GuestHomePage.routeName);


    }catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      showDialog(
          context: context,
          builder: (BuildContext context1) =>
              OKDialogBox(
                title: '',
                description: ""+e.toString(),
                my_context: context,
              ));
      print(e.toString());
    }
  }


}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontFamily: 'Montserrat',
        color: Color((0xff1664c5)),
        fontSize:
        1.9 * MediaQuery.of(context).size.height * 0.01,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        letterSpacing: 1
      ),
    );
  }
}