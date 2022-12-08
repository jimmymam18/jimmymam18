import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/BankAccountPage.dart';
import 'package:bizitme/Screens/CancellationPolicy.dart';
import 'package:bizitme/Screens/CancellationPolicyPage.dart';
import 'package:bizitme/Screens/MainStartPage.dart';
import 'package:bizitme/Screens/MyBookingPage.dart';
import 'package:bizitme/Screens/MyPostPage.dart';
import 'package:bizitme/Screens/ShowMessagePage.dart';
import 'package:bizitme/Screens/TermsAndConditon.dart';
import 'package:bizitme/Screens/UploadPhotosNext.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Screens/personalinfoPage.dart';
import 'package:bizitme/SingleChat/UserChatlist.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePageClass extends StatefulWidget {
  @override
  _ProfilePageClassState createState() => _ProfilePageClassState();
}

class _ProfilePageClassState extends State<ProfilePageClass> {
  bool Status = false;

  // int selectIndex;
  List<Widget> listWidget = [
    //  ProfilePageClass(),
  ];
  var value;
  String name = "";
  String _imageUrl = "https://woceoeic";
  bool _checkLoaded = true;
  var _loadImage = new AssetImage('assets/images/profile_default.png');

  @override
  void initState(){
    super.initState();
    getProfileData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var value;
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => GuestHomePage()));
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 2.0,
          title: Text('Profile',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500)),
          backgroundColor: Color(0xff4996f3),
          leading: IconButton(
            icon: new Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white38,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left:15, top: 10, bottom: 15),
                  child: Row(
                    children: [
                     /* CircleAvatar(
                        backgroundImage:CachedNetworkImageProvider(_imageUrl,),
                        child: Image.asset(
                          'assets/Images/user.png'),
                        radius: MediaQuery.of(context).size.width / 11,
                      ),*/
                      Container(
                        width:60,
                        height: 60,
                        margin: EdgeInsets.only(right: 1),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: _imageUrl,
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

                        ,),

                      Container(
                        padding: EdgeInsets.only(
                            left: 0.0,  bottom: 0, right: 10),
                        child: Column(
                          children: [
                            new Container(
                              padding: EdgeInsets.only(
                                  left: 10.0),
                              child: Text(
                                name,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontFamily: "Montserrat_ExtraBold"),
                              ),
                            ),
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoPage()));
                                  setState(() {});
                                },
                                child:  Container(
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                            ),
                            /* FlatButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoPage()));
                            },
                            child:
                          ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                RaisedButton(
                  elevation: 0.2,
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyPostPage(switchPage: "1",)));
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Images/my_post.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                            ),
                            Text('My Post',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                        Image.asset(
                          'assets/Images/arrow.png',
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                RaisedButton(
                  elevation: 0.2,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyBookingPage(switchPage: "1",)));
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Images/my_booking.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                            ),
                            Text('My Booking',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                        Image.asset(
                          'assets/Images/arrow.png',
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                RaisedButton(
                  elevation: 0.2,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareInstrumentUserChatlistPage()));
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Images/message.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                            ),
                            Text('Message',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                        Image.asset(
                          'assets/Images/arrow.png',
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                RaisedButton(
                  elevation: 0.2,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsAndConditon()));
                    setState(() {});
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Images/tc.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                            ),
                            Text('Terms of Service',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                        Image.asset(
                          'assets/Images/arrow.png',
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                RaisedButton(
                  elevation: 0.2,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CancellationPolicy()));
                    setState(() {});
                  },
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Images/cancel_policy.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                            ),
                            Text('Cancellation Policy',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Image.asset(
                          'assets/Images/arrow.png',
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                RaisedButton(
                  elevation: 0.2,
                  onPressed: () {
                    _ShowLogoutDialog(context);
                    setState(() {});
                  },
                  color: Color(0xffffffff),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Images/logout.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                            ),
                            Text('Logout',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }


  //LOGOUT APP
  _ShowLogoutDialog(BuildContext context) {
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
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      "Are you sure want to Logout?",
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
                              SHDFClass.saveSharedPrefValueString(AppConstants.UserId, null);
                              Bizitme.saveSharedPrefValueString(AppConstants.CustEmail, null);
                              Bizitme.saveSharedPrefValueString(AppConstants.StripeAccountLink, null);
                              Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, null);
                              Bizitme.saveSharedPrefValueBoolean(AppConstants.UserId, null);
                              Bizitme.saveSharedPrefValueBoolean(AppConstants.Token, null);
                              Bizitme.saveSharedPrefValueBoolean(AppConstants.TokenUser, null);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainStartPage()));
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
            _imageUrl = values['image'];
            print("IMAGE URL : "+_imageUrl);
            String lastName = values['lastName'];

            name = firstName +" " +lastName;
            print(name);


          });
        }
      });

    });
    setState(() {});
  }


}
