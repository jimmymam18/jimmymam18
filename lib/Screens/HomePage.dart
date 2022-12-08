import 'package:auto_size_text/auto_size_text.dart';
import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Screens/hostHomePage.dart';
import 'package:bizitme/Screens/loginPage.dart';
import 'package:bizitme/Screens/personalinfoPage.dart';
import 'package:bizitme/Screens/viewProfilePage.dart';
import 'package:bizitme/Utils/Colors.dart';
import 'package:bizitme/Utils/categoryList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _hostingTitle = 'To Host Dashboard';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   String email="",name="";


  OutlineInputBorder allTFBorder;



  Future<void> _logout() async {
   // Navigator.of(context, rootNavigator: true).pop();
    Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, false);
    Bizitme.saveSharedPrefValueString(AppConstants.CustEmail, "");
    Bizitme.saveSharedPrefValueString(AppConstants.CustProfile, "");

    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }
  List<CategoryList> categoryListModel = new List();

  List<String> type_name = new List();
  List<String> type_image = new List();
  var unselectedColor = Colors.white;

  @override
  void initState() {
    super.initState();

    type_name.add("RV");
    type_image.add("assets/images/rv.png");

    type_name.add("Storage");
    type_image.add("assets/images/storage.png");

    type_name.add("Room");
    type_image.add("assets/images/room.png");

    type_name.add("House");
    type_image.add("assets/images/house.png");

    type_name.add("Health & Beauty");
    type_image.add("assets/images/health_beauty.png");

    type_name.add("Workspace");
    type_image.add("assets/images/workspace.png");

    type_name.add("Studio");
    type_image.add("assets/images/studio.png");

    type_name.add("Event");
    type_image.add("assets/images/event.png");

    type_name.add("Hopitality");
    type_image.add("assets/images/hospitality.png");

    type_name.add("Bio-Tech");
    type_image.add("assets/images/bio_tech.png");

    for (int i = 0; i < type_name.length; i++) {

      CategoryList shipmentTypeModel = new CategoryList();
      shipmentTypeModel.type_name = type_name[i];
      shipmentTypeModel.type_image = type_image[i];

      categoryListModel.add(shipmentTypeModel);

    }
    setState(() {});

  }

  initUI() {
    allTFBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: whitecolor, width: 1.5));
  }




  @override
  Widget build(BuildContext context) {
    initUI();
    return SafeArea(
      child:
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 55,
          elevation: 5,
          flexibleSpace:  Container(
              color: colorDarkTheme,
              height: 55,
              child: new Container(
                  padding: new EdgeInsets.only(
                    top: 2,
                  ),
                  child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin:
                              const EdgeInsets
                                  .only(
                                  top: 10,left: 10),
                              child:
                              GestureDetector(
                                  onTap:
                                      () {

                                  },
                                  child:
                              Container(

                                child:
                                Image.asset(
                                    "assets/Images/Logo.png",
                                    height:25,
                                    fit: BoxFit.contain)

                                ,
                              )
                              ),
                            ),


                          ],
                        ),


                      ]))),

          actions: <Widget>[

            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .end,
              children: <Widget>[
                GestureDetector(
                    onTap:
                        () {

                    },
                    child: new Container(
                        margin: const EdgeInsets.only(
                            left:
                            10),
                        child: Image.asset(
                            "assets/images/notificationimg.png",
                            height: 25,
                            width: 25,
                            fit: BoxFit.contain)
                    )),
                SizedBox(
                  width: 10.0,
                ),

              ],
            )

          ],
          backgroundColor: Colors.white,
          centerTitle: true,
        ),

       body: DoubleBackToCloseApp(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                        Container(
                          margin: EdgeInsets.only(top:10),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                fillColor: Colors.black,
                                hintText: "Search by category ",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 5,right:5,left: 5 ),
                                  child: Image.asset(
                                    "assets/images/searchimg.png",
                                    width: 5,
                                    height: 5,
                                  ),
                                ),

/*
                                      Icon(
                                        MdiIcons.emailOutline,
                                        size: 22,
                                      ),
*/
                                border: InputBorder.none,

                                isDense: true,
                                contentPadding: EdgeInsets.zero),
                            keyboardType: TextInputType.text,
                          ),
                        ),

                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Container(
                          margin:
                          const EdgeInsets
                              .only(
                              top: 10,left: 15),
                          child: Text(
                            'Browse Categories',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child:
                      AnimationLimiter(
                        child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          padding: const EdgeInsets.all(4.0),
                          physics:
                          const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: categoryListModel.map((value) {
                            return new AnimationConfiguration
                                .staggeredGrid(
                              position: 5,
                              duration:
                              const Duration(milliseconds: 600),
                              columnCount: categoryListModel.length,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: 140,
                                      child: new Stack(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              //

                                            },
                                            child: Container(
                                                color: unselectedColor,
                                                child: new Card(
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors
                                                            .white70,
                                                        width:
                                                        5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        0),
                                                  ),
                                                  elevation:
                                                  10,
                                                  child:
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: <
                                                        Widget>[
                                                      Container(
                                                        margin:
                                                        EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                                        child: Image.asset(
                                                            value.type_image,
                                                            width: MediaQuery.of(context).size.height * 0.05,
                                                            height: MediaQuery.of(context).size.height * 0.05,
                                                            fit: BoxFit.contain),
                                                      ),
                                                      Container(
                                                        margin:
                                                        EdgeInsets.only(
                                                          top:
                                                          MediaQuery.of(context).size.height * 0.01,
                                                          left:
                                                          MediaQuery.of(context).size.height * 0.01,
                                                          right:
                                                          MediaQuery.of(context).size.height * 0.01,
                                                          bottom:
                                                          2,
                                                        ),
                                                        child:
                                                        Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              width: 85,
                                                              child: Text(value.type_name,
                                                                  textAlign: TextAlign.center,
                                                                  /*       overflow:
                                                                  TextOverflow.ellipsis,*/
                                                                  style: TextStyle(
                                                                    fontFamily: 'Montserrat',

                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      new SizedBox(
                                                        height:
                                                        MediaQuery.of(context).size.height * 0.01,
                                                      )
                                                    ],
                                                  ),
                                                ) ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
          snackBar: const SnackBar(
            content: Text('Tap back again to leave'),
          ),
        ),


      ),
    );
  }

  getProfile() async {

  //  var user = firebase.auth().currentUser;

  /*  if (user != null) {
      user.providerData.forEach(function (profile) {
      console.log("Sign-in provider: " + profile.providerId);
      console.log("  Provider-specific UID: " + profile.uid);
      console.log("  Name: " + profile.displayName);
      console.log("  Email: " + profile.email);
      console.log("  Photo URL: " + profile.photoURL);
      });
    }*/

   /* db = FirebaseDatabase.instance.reference().child("users");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        print(values["firstName"]);
      });
    });*/




    var query = FirebaseFirestore.instance.collection('users');

    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> values = document.data();
        String primaryKeyValue = values['address'];

        String emailmain =
            await Bizitme.readSharedPrefString(AppConstants.CustEmail, "");

        String email = values['email'];

        if(emailmain ==email) {
          setState(() {
            name = values['firstName'] +" "+ values['lastName'];
            email = values['email'];
          });
        }
      });

    });


  }
}

class HomePageListTile extends StatelessWidget {
  final String text;
  final IconData iconData;



  HomePageListTile({Key key, this.text, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: Text(
        this.text,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal,
          fontFamily: 'Montserrat'),
      ),
      trailing: Icon(
        this.iconData,
        size: 35.0,
      ),
    );
  }

}
