// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:io';

import 'package:bizitme/Utils/CustomPlacePicker/src/place_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/MyUtilsClass.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/OtpRequest.dart';
import 'package:bizitme/Models/OtpResponse.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/LoginOtp.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Views/textWidgets.dart';
import 'package:bizitme/repository/common_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:place_picker/place_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../global.dart';

// import 'package:google_places_picker/google_places_picker.dart';

/*service cloud.firestore {
match /databases/{database}/documents {
match /{document=**} {

allow read, write: if request.auth.uid != null;
}   } }*/

class SignUpPage extends StatefulWidget {
  static final String routeName = '/signUpPageRoute';

  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _countryCodeController = TextEditingController();

  TextEditingController _bioController = TextEditingController();

  TextEditingController _addressController = TextEditingController();
  String userID = "";
  File _imageFile;
  final databaseReference = FirebaseFirestore.instance;
  ProgressDialog _progressDialog = ProgressDialog();
  bool progressDialog = false;

  String base64ImageTemp = "";
  String textGetOtp = "";
  Country _selectedCountry;
  File _image;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  bool email_exist = false;
  bool mobile_exist = false;

  @override
  void initState() {
    super.initState();
    _countryCodeController.text = "+1";

    // PluginGooglePlacePicker.initialize(
    //   androidApiKey: AppConstants.googleMapsAPIKey,
    //   iosApiKey: AppConstants.googleMapsAPIKey,
    // );
  }

  void _chooseImage() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _imageFile = File(imageFile.path);
      setState(() {});
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState.validate() /*|| this._imageFile == null*/) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    /*FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((firebaseUser) {
      String userID = firebaseUser.user.uid;
      AppConstants.currentUser.id = userID;
      AppConstants.currentUser.firstName = _firstNameController.text;
      AppConstants.currentUser.lastName = _lastNameController.text;
      AppConstants.currentUser.city = _cityController.text;
      AppConstants.currentUser.country = _countryController.text;
      AppConstants.currentUser.bio = _bioController.text;
      AppConstants.currentUser.email = _emailController.text;
      AppConstants.currentUser.password = _passwordController.text;
      AppConstants.currentUser.address = _addressController.text;



      AppConstants.currentUser.addUserToFirestore().whenComplete(() {
        AppConstants.currentUser
            .saveImageToFirestore(_imageFile)
            .whenComplete(() {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
              .whenComplete(() {
            Navigator.pushReplacementNamed(context, GuestHomePage.routeName);
          });
        });
      });
    });*/

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading...', dismissAfter: null);
    }

    String _imageURL = "";

    // String token = await new MyUtils().getDeviceToken();

    var _result =
        await CloudStorageService.instance.uploadUserImage(email, _imageFile);
    _imageURL = await _result.ref.getDownloadURL();
    print(_imageURL);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      /*    await databaseReference.collection("users")
          .doc(userCredential.user.uid)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'gender' : _genderController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'country': _countryController.text,
        'city': _cityController.text,
        'bio': _bioController.text,
        'isHost': "true",
        'address': _addressController.text,
        'stripeAccountLink': "",
        'image': ""+_imageURL
      });*/

      Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, true);
      Bizitme.saveSharedPrefValueString(AppConstants.CustEmail, email);
      Bizitme.saveSharedPrefValueString(AppConstants.CustProfile, _imageURL);

      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      // Navigator.pushReplacementNamed(context, GuestHomePage.routeName);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginOtp(
                  textGetMobileNo: _mobileController.text,
                  textGetOtp: textGetOtp,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  gender: _genderController.text,
                  email: _emailController.text,
                  country: _countryController.text,
                  city: _cityController.text,
                  bio: _bioController.text,
                  address: _addressController.text,
                  image: _imageFile)));
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: '',
                description: "" + e.toString(),
                my_context: context,
              ));
      print(e.toString());
    }

    /*}).catchError((onError) {
  showDialog(
  context: context,
  builder: (BuildContext context) {
  var err;
  return AlertDialog(
  title: Text("Error"),
  content: Text($onError),
  actions: [
  FlatButton(
  child: Text("Ok"),
  onPressed: () {
  Navigator.of(context).pop();
  },
  )
  ],
  );
  });*/

/*
    FirebaseFirestore.instance.collection('users')
        .doc(userCredential.user.uid)
        .set({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'bio' : _bioController.text,
      'isHost': "true",
      'email' : _emailController.text,
      'address' : _addressController.text,
      'displayImage' : _imageURL as MemoryImage
    });



    firebaseAuth
        .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text)
        .then((onValue) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(onValue.user.uid)
          .set({

      }).then((userInfoValue) {
        Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, true);
        Bizitme.saveSharedPrefValueString(AppConstants.CustProfile, _imageURL);
        Navigator.pushReplacementNamed(context, GuestHomePage.routeName);

      });
    }).catchError((onError) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            var err;
            return AlertDialog(
              title: Text("Error"),
              content: Text(onError.toString()),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });*/
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerDialog(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        _countryCodeController.text = _selectedCountry.callingCode;
      });
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale("af"),
          Locale("am"),
          Locale("ar"),
          Locale("az"),
          Locale("be"),
          Locale("bg"),
          Locale("bn"),
          Locale("bs"),
          Locale("ca"),
          Locale("cs"),
          Locale("da"),
          Locale("de"),
          Locale("el"),
          Locale("en"),
          Locale("es"),
          Locale("et"),
          Locale("fa"),
          Locale("fi"),
          Locale("fr"),
          Locale("gl"),
          Locale("ha"),
          Locale("he"),
          Locale("hi"),
          Locale("hr"),
          Locale("hu"),
          Locale("hy"),
          Locale("id"),
          Locale("is"),
          Locale("it"),
          Locale("ja"),
          Locale("ka"),
          Locale("kk"),
          Locale("km"),
          Locale("ko"),
          Locale("ku"),
          Locale("ky"),
          Locale("lt"),
          Locale("lv"),
          Locale("mk"),
          Locale("ml"),
          Locale("mn"),
          Locale("ms"),
          Locale("nb"),
          Locale("nl"),
          Locale("nn"),
          Locale("no"),
          Locale("pl"),
          Locale("ps"),
          Locale("pt"),
          Locale("ro"),
          Locale("ru"),
          Locale("sd"),
          Locale("sk"),
          Locale("sl"),
          Locale("so"),
          Locale("sq"),
          Locale("sr"),
          Locale("sv"),
          Locale("ta"),
          Locale("tg"),
          Locale("th"),
          Locale("tk"),
          Locale("tr"),
          Locale("tt"),
          Locale("uk"),
          Locale("ug"),
          Locale("ur"),
          Locale("uz"),
          Locale("vi"),
          Locale("in")
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Signup',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Color(0xff4996f3),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: _chooseImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width / 5.99,
                              child: (_imageFile == null)
                                  ? Image.asset(
                                      'assets/Images/profile_picture.png',
                                      height: 120,
                                      width: 120,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: FileImage(_imageFile),
                                      maxRadius:
                                          MediaQuery.of(context).size.width /
                                              6.0,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                labelText: 'First name',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              controller: _firstNameController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Please enter a first name";
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Last name',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              controller: _lastNameController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Please enter a last name";
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Gender',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              controller: _genderController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Please enter gender";
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              validator: (text) {
                                if (!text.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              controller: _emailController,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: [
                                          CountryCodePicker(
                                            onChanged: (CountryCode code) {
                                              print(code);
                                              _countryCodeController.text =
                                                  code.dialCode;
                                              print("VODE :" +
                                                  _countryCodeController.text);
                                            },
                                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                            initialSelection: 'US',
                                            favorite: ['+1', 'US'],
                                            // optional. Shows only country name and flag
                                            showCountryOnly: false,
                                            //showFlag: false,
                                            // optional. Shows only country name and flag when popup is closed.
                                            showOnlyCountryWhenClosed: false,
                                            // optional. aligns the flag and the Text left
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.001,
                                            color: Colors.grey,
                                          )
                                        ],
                                      )
                                      /* InkWell(
                              onTap: (){
                              //  _showCountryPicker();
                              //  _onCountryChange();
                                setState(() {});
                              },
                              child:*/ /*TextFormField(
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.grey,
                                enabled: false,
                                decoration: InputDecoration(labelText: 'country code',labelStyle: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                ),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),)),

                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                ),
                                controller: _countryCodeController,
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "Please select country code";
                                  }
                                  return null;
                                },

                              ),*/ /*

                            ),*/
                                      )),
                              new SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                        labelText: 'Mobile no',
                                        labelStyle: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        )),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.0,
                                    ),
                                    validator: (text) {
                                      if (text.isEmpty) {
                                        return "Please enter mobile number";
                                      }
                                      return null;
                                    },
                                    controller: _mobileController,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Montserrat',
                              ),
                              obscureText: true,
                              validator: (text) {
                                if (text.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              controller: _passwordController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              obscureText: true,
                              validator: (text) {
                                if (text.length < 6) {
                                  return 'Confirm Password must be at least 6 characters';
                                }

                                if (text != _passwordController.text) {
                                  return 'Enter same password';
                                }

                                return null;
                              },
                              controller: _confirmpasswordController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Country',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              controller: _countryController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Please enter a valid country";
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                labelText: 'City',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                              ),
                              controller: _cityController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Please enter a valid city";
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: InkWell(
                                child: TextFormField(
                                  cursorColor: Colors.grey,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      labelText: 'Address',
                                      labelStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat',
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      )),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                  ),
                                  controller: _addressController,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return 'Enter Address';
                                    }
                                    return null;
                                  },
                                ),
                                onTap: () async {
                                  showPlacePicker();
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  labelText: 'Bio',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Montserrat',
                                color: Colors.black,
                              ),
                              maxLines: 3,
                              controller: _bioController,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: MaterialButton(
                        onPressed: () {
                          if (_imageFile == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context1) => OKDialogBox(
                                      title: 'Select Profile Image',
                                      description: "",
                                      my_context: context,
                                    ));
                          } else {
                            if (_countryCodeController.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Please select country code",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (_mobileController.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Please enter mobile number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
//                           OtpApi();
                              if (!_formKey.currentState
                                  .validate() /*|| this._imageFile == null*/) {
                                return;
                              } else {
                                checkEmailExist();
                              }
                            }
                            setState(() {});
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                        color: Color(0xff4996f3),
                        height: MediaQuery.of(context).size.height / 15,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void OtpApi() async {
    String phoneNo = _countryCodeController.text + _mobileController.text;

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    OtpRequest otpRequest = new OtpRequest();
    otpRequest.phoneno = phoneNo;
    otpRequest.email = "1";
    otpRequest.userId = "ABC@GMAIL.COM";

    OtpResponse otpResponse = await otpRef(otpRequest);
    _progressDialog.dismissProgressDialog(context);
    progressDialog = false;

    if (otpResponse == null) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Something went wrong, Please try again',
                description: "",
                my_context: context,
              ));
    } else if (otpResponse.status == "1") {
      print("SUCCESS");
      textGetOtp = otpResponse.otp;
      print("OTP : " + textGetOtp);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginOtp(
                    textGetMobileNo: _mobileController.text,
                    textGetOtp: textGetOtp,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    gender: _genderController.text,
                    email: _emailController.text,
                    country: _countryController.text,
                    city: _cityController.text,
                    bio: _bioController.text,
                    address: _addressController.text,
                    image: _imageFile,
                    codeNumber: phoneNo,
                    password: _passwordController.text,
                  )));

      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                // title: '' + responseData.msg,
                title: otpResponse.msg,
                description: "",
                my_context: context,
              ));
    }
  }

  void showPlacePicker() async {
    // LatLng customLocation;
    // LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) =>
    //         PlacePicker(AppConstants.googleMapsAPIKey,
    //            displayLocation: customLocation,
    //         )));
    //
    // // Handle the result in your way
    // print(result.formattedAddress);
    // setState(() {
    //   _addressController.text = result.formattedAddress as String;
    // });

    String placeName = "";
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return PlacePicker(
          apiKey: AppConstants.googleMapsAPIKey,

          initialPosition: LatLng(global_lati, global_longi),

          useCurrentLocation: true,
          automaticallyImplyAppBarLeading: true,
          //usePlaceDetailSearch: true,
          hintText: "Choose Location",
          onGeocodingSearchFailed: (result) async {
            print("onGeocodingSearchFailed");
          },
          onAutoCompleteFailed: (result) async {
            print("onAutoCompleteFailed");
          },

          onPlacePicked: (result) async {
            try {
              placeName = result.formattedAddress.toString()?? "Null place name!";
              if (placeName == "") {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context1) => OKDialogBox(
                          title: 'Please drag the map to get address',
                          description: "",
                          my_context: context,
                        ));
              } else {
                Navigator.pop(context, true);
                setState(() {
                  _addressController.text = placeName;
                });
              }
            } catch (e) {

            }
          },
        );
      },
    ));

  }

  Future<void> checkEmailExist() async {
    email_exist = false;
    mobile_exist = false;

    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();

        String email = values['email'];
        String mobile = values['mobile'];

        if (_emailController.text == email) {
          email_exist = true;
        } else if (_mobileController.text == mobile) {
          //  mobile_exist=true;
        }
      });
    });

    if (email_exist == true) {
      Fluttertoast.showToast(
          msg: "Email already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (mobile_exist == true) {
      Fluttertoast.showToast(
          msg: "mobile number already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      OtpApi();
    }
    setState(() {});
  }
}
