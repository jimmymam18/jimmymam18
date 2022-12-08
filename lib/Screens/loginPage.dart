import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/MyUtilsClass.dart';
import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Models/userObjects.dart';
import 'package:bizitme/Screens/ForgotPasswordScreen.dart';
import 'package:bizitme/Screens/MainStartPage.dart';
import 'package:bizitme/Screens/SelectionPage.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Screens/signUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthentication;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = '/loginPageRoute';
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ProgressDialog _progressDialog = ProgressDialog();
  bool progressDialog = false;

  void _signUp() {
    Navigator.pushNamed(context, SignUpPage.routeName);
   /* if (_formKey.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      AppConstants.currentUser = User();
      AppConstants.currentUser.email = email;
      AppConstants.currentUser.password = password;
      }*/
  }


  Future<void> _login() async {

    UserCredential userCredential;
    if (_formKey.currentState.validate()) {

      if (progressDialog == false) {
        progressDialog = true;
        _progressDialog.showProgressDialog(context,
            textToBeDisplayed: 'Loading...', dismissAfter: null);
      }

      String email = _emailController.text;
      String password = _passwordController.text;

      try {
         userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password
        );

         String userId = userCredential.user.uid;
         Bizitme.saveSharedPrefValueString(AppConstants.UserId, userId);
         print("user id : "+userCredential.user.uid);


         Bizitme.saveSharedPrefValueString(AppConstants.CustEmail, email);
         Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, true);

         checkAndUpdateUserDetails(email.toString(),userCredential.user.uid);
         updateTokenInAllPostTaable(userId.toString(),userCredential.user.uid);

         _progressDialog.dismissProgressDialog(context);
         progressDialog = false;

         Navigator.pushReplacementNamed(context, GuestHomePage.routeName);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;

          showDialog(
              context: context,
              builder: (BuildContext context1) =>
                  OKDialogBox(
                    title: 'No user found for that email.',
                    description: "",
                    my_context: context,
                  ));
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {

          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;


          showDialog(
              context: context,
              builder: (BuildContext context1) =>
                  OKDialogBox(
                    title: 'Wrong password provided for that user.',
                    description: "",
                    my_context: context,
                  ));

          print('Wrong password provided for that user.');
        }
      }


      /*  FirebaseAuthentication.FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((firebaseUser) {
          String userID = firebaseUser.user.uid;
          AppConstants.currentUser = User(id: userID);
          AppConstants.currentUser
              .getPersonalInfoFromFirestore()
              .whenComplete(() {
            Navigator.pushNamed(context, GuestHomePage.routeName);
          });
        });*/
    }
  }


  //check and update user into database
  checkAndUpdateUserDetails(String email,String uid) async {

    try
    {

      String token = await new MyUtils().getDeviceToken();

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'email': email,
          'device_token': token,
        });
      }
      else
      {
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'email': email,
          'device_token': token,
        });
      }





    }
    catch (e)
    {
      print("etttt"+e.toString());
    }


  }

  updateTokenInAllPostTaable(String userId,String uid) async {

    try
    {
      String token = await new MyUtils().getDeviceToken();

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('all_post')
          .where('userId', isEqualTo: userId)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {

      }
      else
      {
        FirebaseFirestore.instance.collection('all_post').doc(userId).update({
          'device_token': token,
        });
      }





    }
    catch (e)
    {
      print("etttt"+e.toString());
    }


  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope( onWillPop: (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainStartPage()));
      setState(() {});
    },
    child:Scaffold(
      body: new Container(
      width: double.infinity,
      height: double.infinity,
        child: new SafeArea(
        child:SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width,
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainStartPage()));
                      },
                    ),
                  )
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/Images/Logo.png"
                            ,fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 35.0),
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Email'),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Password'),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                ),
                                obscureText: true,
                                validator: (text) {
                                  if (text.length < 6) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: MaterialButton(
                          onPressed: () {

                            print("LOOGINN");
                            _login();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                          color: Color(0xff4996f3),
                          height: MediaQuery.of(context).size.height / 16,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: MaterialButton(
                          onPressed: () {
                            _signUp();
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.grey,
                          height: MediaQuery.of(context).size.height / 16,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child:
                        Container(
                          alignment: Alignment.centerRight,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',

                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = ()  {
                                      Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
        ),
      ),
    )
    );
  }


}
