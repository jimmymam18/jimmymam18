import 'package:bizitme/Screens/personalinfoPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Utils/custom_progress_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  ProgressDialog _progressDialog = new ProgressDialog();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Change Password',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor:  Color(0xff4996f3),

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Form(
            key: _formKey,
            child: Column(
                  children: [
                    SizedBox(
                      height: 12.5,
                    ),
                    Center(
                      child: Image.asset('assets/Images/change password.png',height: 120,width: 120,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0,left: 15,right: 15),
                      child: TextFormField(
                        controller: oldPasswordController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(labelText: 'Old Password',labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                        ),
                       //   hintText: "old password",hintStyle: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "Montserrat"),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),),
                        //controller: _lastNameController,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Please enter a old  Password.";
                          }else if (text.length < 6) {
                            return 'Old Password must be at least 6 characters';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0,left: 15,right: 15),
                      child: TextFormField(
                        controller:newPasswordController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(labelText: 'New Password',labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                        ),
                      //    hintText: "New password",hintStyle: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "Montserrat"),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),),
                        //controller: _lastNameController,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Please enter a new password.";
                          }else if (text.length < 6) {
                            return 'New Password must be at least 6 characters';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0,left: 15,right: 15),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(labelText: 'Confirm Password',labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                        ),
                         // hintText: "Enter confirm password",hintStyle: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "Montserrat"),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),),
                        //controller: _lastNameController,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Please enter confirm password.";
                          }else if (text.length < 6) {
                            return 'Confirm Password must be at least 6 characters';
                          }else if(text != newPasswordController.text){
                            return "Password is not matching";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 80,left: 20,right: 20),
                      child: MaterialButton(
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }else{
                            chnagepassword(confirmPasswordController.text);
                          }
                         
                         // Navigator.pop(context);
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
                  ],
                )
            ),
           
            ],
          ),
        ),
      )
    );
  }

/*
  void _changePassword(String newpassword) async{
    //Create an instance of the current user.
    FirebaseUser user =  FirebaseAuth.instance.currentUser;

    //Pass in the password to updatePassword.
    user.updatePassword(newpassword).then((_){
      print("Successfully changed password");
    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    }).whenComplete(() =>  Navigator.pop(context));
  }
*/

  final databaseReference = FirebaseFirestore.instance;

  void chnagepassword(String newpassword)async{
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }


    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);

    user.updatePassword(newpassword).then((_){
      print("Successfully changed password");

    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    }).whenComplete(() {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;
      _ShowBottomSheet_success();
    });

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
                      'Your password changes saved successfully!',
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
                            MaterialPageRoute(builder: (context) => PersonalInfoPage()));
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


}
