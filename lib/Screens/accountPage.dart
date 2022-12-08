import 'package:auto_size_text/auto_size_text.dart';
import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Screens/hostHomePage.dart';
import 'package:bizitme/Screens/loginPage.dart';
import 'package:bizitme/Screens/personalinfoPage.dart';
import 'package:bizitme/Screens/viewProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _hostingTitle = 'To Host Dashboard';
   String email="",name="";

  Future<void> _logout() async {
   // Navigator.of(context, rootNavigator: true).pop();
    Bizitme.saveSharedPrefValueBoolean(AppConstants.Session, false);
    Bizitme.saveSharedPrefValueString(AppConstants.CustEmail, "");
    Bizitme.saveSharedPrefValueString(AppConstants.CustProfile, "");

    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

 /* void _changeHosting() {
    if (AppConstants.currentUser.isHost) {
      if (AppConstants.currentUser.isCurrentlyHosting) {
        AppConstants.currentUser.isCurrentlyHosting = false;
        Navigator.pushNamed(
          context,
          GuestHomePage.routeName,
        );
      } else {
        AppConstants.currentUser.isCurrentlyHosting = true;
        Navigator.pushNamed(
          context,
          HostHomePage.routeName,
        );
      }
    } else {
      AppConstants.currentUser.becomeHost().whenComplete(() {
        AppConstants.currentUser.isCurrentlyHosting = true;
        Navigator.pushNamed(
          context,
          HostHomePage.routeName,
        );
      });
    }
  }*/

  @override
  void initState() {
   /* if (AppConstants.currentUser.isHost) {
      if (AppConstants.currentUser.isCurrentlyHosting) {
        _hostingTitle = 'To Guest Dashboard';
      } else {
        _hostingTitle = 'To Host Dashboard';
      }
    } else {
      _hostingTitle = 'Become a host';
    }
*/
    getProfile();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
               /* MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProfilePage(
                          contact:
                              AppConstants.currentUser.createContactFromUser(),
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: MediaQuery.of(context).size.width / 9.5,
                    child: CircleAvatar(
                      backgroundImage: AppConstants.currentUser.displayImage,
                      radius: MediaQuery.of(context).size.width / 10,
                    ),
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      AutoSizeText(
                       email,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              MaterialButton(
                height: MediaQuery.of(context).size.height / 9.0,
                onPressed: () {
                  Navigator.pushNamed(context, PersonalInfoPage.routeName);
                },
                child: AccountPageListTile(
                  text: 'Personal Information',
                  iconData: Icons.person,
                ),
              ),
              MaterialButton(
                height: MediaQuery.of(context).size.height / 9.0,

                child: AccountPageListTile(
                  text: _hostingTitle,
                  iconData: Icons.hotel,
                ),
              ),
              MaterialButton(
                height: MediaQuery.of(context).size.height / 9.0,
                onPressed: _logout,
                child: AccountPageListTile(
                  text: 'Logout',
                  iconData: null,
                ),
              ),
            ],
          ),
        ],
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

class AccountPageListTile extends StatelessWidget {
  final String text;
  final IconData iconData;



  AccountPageListTile({Key key, this.text, this.iconData}) : super(key: key);

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
