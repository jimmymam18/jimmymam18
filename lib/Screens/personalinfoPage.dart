import 'dart:io';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/MyUtilsClass.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/ChangePasswordPage.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Utils/CustomPlacePicker/src/place_picker.dart';
import 'package:bizitme/Views/textWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../global.dart';
// import 'package:place_picker/entities/location_result.dart';
// import 'package:place_picker/widgets/place_picker.dart';

class PersonalInfoPage extends StatefulWidget {
  static final String routeName = '/PersonalInfoPageRoute';
  PersonalInfoPage({Key key}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _cityController;
  TextEditingController _countryController;
  TextEditingController _bioController;
  TextEditingController _addressController;
  TextEditingController _genderController;
  String _imageURL ="";
  String _imageSelectURL = "";
  String stripeAccountLink = "";
  ProgressDialog _progressDialog = ProgressDialog();
  bool progressDialog = false;


  final databaseReference = FirebaseFirestore.instance;

  File _newImageFile;

  void _chooseImage() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _newImageFile = File(imageFile.path);
      setState(() {});
    }
  }

  Future<void> _saveInfo() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
   /* var userCredential;
    await databaseReference.collection("users")
        .doc(userCredential.user.uid)
        .updateData({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'bio': _bioController.text,
      'isHost': "true",
      'email': _emailController.text,
      
    });*/



   if(_newImageFile != null){
     var _result = await CloudStorageService.instance
         .uploadUserImage(_emailController.text, _newImageFile);
     _imageURL = await _result.ref.getDownloadURL();
     print(_imageURL);
   }



    var firebaseUser = await FirebaseAuth.instance.currentUser;
    print(firebaseUser.uid);

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Loading...', dismissAfter: null);
    }


     FirebaseFirestore.instance
         .collection('users')
         .doc(firebaseUser.uid)
         .update({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'bio': _bioController.text,
      'isHost': "true",
      'email': _emailController.text,
      'address': _addressController.text,
       'gender':_genderController.text,
      'image': _imageURL,
    }).catchError((e) {
       _progressDialog.dismissProgressDialog(context);
       progressDialog = false;
       print(e);
     }).then((_) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;
      Navigator.pushNamed(context, GuestHomePage.routeName);
      print("successsssssssssssssssss!");

    });

    print("GENDER : "+_genderController.text);
   /* AppConstants.currentUser.firstName = _firstNameController.text;
    AppConstants.currentUser.lastName = _lastNameController.text;
    AppConstants.currentUser.city = _cityController.text;
    AppConstants.currentUser.country = _countryController.text;
    AppConstants.currentUser.bio = _bioController.text;

    AppConstants.currentUser.updateUserInFirestore().whenComplete(() async {
      if (_newImageFile != null) {
        var _result = await CloudStorageService.instance
            .uploadUserImage(AppConstants.currentUser.email, _newImageFile);
       String _imageURL = await _result.ref.getDownloadURL();

      } else {
        Navigator.pushNamed(context, GuestHomePage.routeName);
      }
    });*/
  }


  void _ShowBottomSheet_success() {
    showModalBottomSheet(
        context: context,
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
                      'Your profile changes saved successfully!',
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => GuestHomePage(indexCount: '0',)));
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

  @override
   initState() {
    getProfileData();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '4')));
      setState(() {});
    },
    child:Scaffold(
      appBar: AppBar(
        title: Text('Personal Information',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading:  IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuestHomePage(indexCount: '4')));

          },
        ),
        backgroundColor:  Color(0xff4996f3),
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
                   /*   Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                        child: Image.network(_imageURL,height: 120,width: 120,),

                      ),*/
                      MaterialButton(
                        onPressed: _chooseImage,
                        child:
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: MediaQuery.of(context).size.width / 5.99,
                          child:
                          (_newImageFile == null) ?
                          CircleAvatar(
                            backgroundImage:CachedNetworkImageProvider(_imageURL),
                            child: Image.asset(
                              _imageURL == ""? 'assets/Images/user.png':_imageURL,),
                            radius: MediaQuery.of(context).size.width / 6,
                          )
                              :
                          CircleAvatar(
                            backgroundImage: FileImage(_newImageFile),
                            radius: MediaQuery.of(context).size.width / 6,
                          ),

                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(labelText: 'First name',labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                          controller: _firstNameController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a valid first name.";
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
                          decoration: InputDecoration(labelText: 'Last name',labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),),
                          controller: _lastNameController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a valid last name.";
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 5.0),
                      //   child: TextFormField(
                      //     cursorColor: Colors.grey,
                      //     controller: _genderController,
                      //     decoration: InputDecoration(labelText: 'Gender',labelStyle: TextStyle(
                      //       fontSize: 14.0,
                      //       fontFamily: 'Montserrat',
                      //       color: Colors.grey,
                      //     ),
                      //         focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),)),
                      //     validator: (text) {
                      //       if (text.isEmpty) {
                      //         return "Please select gender ";
                      //       }
                      //       return null;
                      //     },
                      //     textCapitalization: TextCapitalization.words,
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                          enabled: false,
                          controller: _emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(labelText: 'Country',labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),

                          controller: _countryController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a valid country.";
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
                          decoration: InputDecoration(labelText: 'City',labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                          controller: _cityController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a valid city.";
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child:InkWell(
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              enabled: false,
                              decoration: InputDecoration(labelText: 'Address', labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),

                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Enter Address';
                                }
                                return null;
                              },
                              controller: _addressController,
                            ),

                            onTap:() async {
                              showPlacePicker();
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(labelText: 'Bio',labelStyle: TextStyle(color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: "Montserrat",),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),

                          controller: _bioController,
                          //maxLines: 3,
                          // validator: (text) {
                          //   if (text.isEmpty) {
                          //     return "Please enter a valid bio.";
                          //   }
                          //   return null;
                          // },
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordPage()));
                            },
                            child: Text("Change Password",style: TextStyle(color: Colors.blue,fontSize: 14,
                                fontFamily: "Montserrat",fontWeight: FontWeight.w600),),),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                        child: MaterialButton(
                          onPressed: () {
                            _updateProfile();

                            //Navigator.pushNamed(context, LoginPage.routeName);
                          },
                          child: Text(
                            'Save',
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
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }


  Future<void> getProfileData() async {

    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();
        String primaryKeyValue = values['address'];
       // print("dekh"+primaryKeyValue);

        String emailmain =
            await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");
        print(emailmain);

        String email = values['email'];

        if(emailmain ==email){

          setState(() {
            String firstName =  values['firstName'];
            _imageURL = values['image'];
            print("IMAGE URL : "+_imageURL);
            String lastName = values['lastName'];
            String city = values['city'];
            String country = values['country'];
            String address = values['address'];
            String bio = values['bio'];
            String gender = values['gender'];
            stripeAccountLink = values['stripeAccountLink'];


            _firstNameController =
                TextEditingController(text: firstName);
            _lastNameController =
                TextEditingController(text: lastName);
            _emailController =
                TextEditingController(text: email);

            _addressController = TextEditingController(text: address);
            _cityController =
                TextEditingController(text: city);
            _countryController =
                TextEditingController(text: country);
            _bioController = TextEditingController(text: bio);
            _genderController = TextEditingController(text: gender);

          });
        }
      });

    });
    setState(() {});
  }


  Future<void> _updateProfile() async {

    if (!_formKey.currentState.validate()) {
      return;
    }

    String token = await new MyUtils().getDeviceToken();

    if(_newImageFile != null){
      print("NEW IMAGE FILE : "+_newImageFile.toString());
      var _result = await CloudStorageService.instance
          .uploadImage(_newImageFile);
      _imageURL = await _result.ref.getDownloadURL();
      print(_imageURL);
    }


    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);


    await databaseReference.collection("users")
        .doc(user.uid)
        .set({
      'firstName':_firstNameController.text,
      'lastName': _lastNameController.text,
      'gender' : _genderController.text,
      'email': _emailController.text,
      'country': _countryController.text,
      'city': _cityController.text,
      'bio': _bioController.text,
      'isHost': "true",
      'address': _addressController.text,
      'image': _imageURL,
      'stripeAccountLink': stripeAccountLink,
      'device_token': token
    }).whenComplete(() {
      _ShowBottomSheet_success();
    });



  }



  void showPlacePicker() async {
/*    LatLng customLocation;
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(AppConstants.googleMapsAPIKey,
              displayLocation: customLocation,
            )));

    // Handle the result in your way
    print(result.formattedAddress);
    setState(() {
      _addressController.text = result.formattedAddress as String;
    });*/

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

}
