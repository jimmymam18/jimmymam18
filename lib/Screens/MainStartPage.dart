import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/StripeDetails/StripeDetailRequest.dart';
import 'package:bizitme/Models/StripeDetails/StripeDetailResponse.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/signUpPage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:bizitme/repository/common_repository.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizitme/Screens/LoginOtp.dart';

import '../global.dart';
import 'guestHomePage.dart';
import 'loginPage.dart';

class MainStartPage extends StatefulWidget {
  static final String routeName = '/MainStartPageRoute';
  MainStartPage({Key key}) : super(key: key);

  @override
  _MainStartPageState createState() => _MainStartPageState();
}




class _MainStartPageState extends State<MainStartPage>{


  @override
  void initState() {
    setInitialLocation();
    super.initState();
   }

  void setInitialLocation() async {

    await Geolocator.getCurrentPosition().then((value) =>
    {

      print("latitude ---" + value.latitude.toString()),
      print("longitude ---" + value.longitude.toString()),

      global_lati= value.latitude,
      global_longi= value.longitude

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        child: new Container(
          width: double.infinity,
          height: double.infinity,
          child: new SafeArea(
            child:SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 200, 50, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/Images/Logo.png",fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Form(
                        child: Column(
                          children: <Widget>[
                         Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: MaterialButton(
                          onPressed: () {
                            // Navigator.pushReplacementNamed(context, GuestHomePage.routeName);
                            // GetStripeDetail();
                            Navigator.pushReplacementNamed(context, LoginPage.routeName);
                          },
                          child: Text(
                            'Already a member?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                            color: Color(0xff4996f3),
                            height: MediaQuery.of(context).size.height / 16,
                             minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            ),
                           ),
                         ),
                         Padding(
                         padding: const EdgeInsets.only(top: 20.0),
                          child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpPage.routeName);
                          },
                           child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.grey,
                          height: MediaQuery.of(context).size.height / 16,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child:
                                Center(
                                 child: RichText(
                                 text: TextSpan(
                                  children: [
                                TextSpan(
                                  text: "Want to learn more?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                TextSpan(
                                  text: " Click here.",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final url = 'http://bizit.me/';
                                      if (await canLaunch(url)) {
                                        await launch(
                                          url,
                                          forceSafariVC: false,
                                        );
                                      }
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
          ),),

      ),
          ),
    ),
        snackBar: SnackBar(
          content: Text("Tap Again to exit..."),
      ),
    ),
    );
  }



}