import 'package:bizitme/Screens/RVListPage.dart';
import 'package:bizitme/Screens/StorageListPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HouseListPage.dart';
import 'RoomListPage.dart';

class SelectionRvPersonalPage extends StatefulWidget {
  static final String routeName = '/SelectionRvPersonalRoute';
  SelectionRvPersonalPage({Key key}) : super(key: key);

  @override
  _SelectionRvPersonalPageState createState() => _SelectionRvPersonalPageState();
}

class _SelectionRvPersonalPageState extends State<SelectionRvPersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Coolveticarg',
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(
                   height: 50,
                 ),
                 Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Card(
                         elevation: 5,
                         margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                               bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                         child:
                         new Material(
                           child: new InkWell(
                             onTap: (){
                               Navigator.pushNamed(context, RVListPage.routeName);
                             },
                             child:Column(
                                 children: <Widget>[
                                   Container(
                                     width: 120,
                                     height: 100,
                                     margin: EdgeInsets.all(10),
                                     child: Image.asset("assets/images/rv-round.png"
                                       ,fit: BoxFit.fitWidth,
                                     ),
                                   ),
                                   Center(child: Text("RV",
                                     style: TextStyle(
                                       fontSize: 16.0,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'Montserrat',
                                     ),
                                     textAlign: TextAlign.center,
                                   )),
                                   SizedBox(height: 5,),
                                 ]
                             ),
                           ),
                           color: Colors.transparent,
                         ),
                       ),
                       Card(
                         elevation: 5,
                         margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                               bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                         child: new Material(
                           child: new InkWell(
                             onTap: (){ Navigator.pushNamed(context, StorageListPage.routeName);},
                             child: Column(
                                 children: <Widget>[
                                   Container(
                                     width: 120,
                                     height: 100,
                                     margin: EdgeInsets.all(10),
                                     child: Image.asset("assets/images/storage-round.png"
                                       ,fit: BoxFit.fitWidth,
                                     ),
                                   ),
                                   Center(child: Text("Storage",
                                     style: TextStyle(
                                       fontSize: 16.0,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'Montserrat',
                                     ),
                                     textAlign: TextAlign.center,
                                   )),
                                   SizedBox(height: 5,),
                                 ]
                             ),
                           ),
                           color: Colors.transparent,
                         ),
                       ),

                     ]
                 ),
                SizedBox(height: 20,),
                 Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 5,
                          margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                          child:
                          new Material(
                            child: new InkWell(
                              onTap: (){ Navigator.pushNamed(context, RoomListPage.routeName);},
                              child:Column(
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 100,
                                      margin: EdgeInsets.all(10),
                                      child: Image.asset("assets/images/room-round.png"
                                        ,fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    Center(child: Text("Room",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                    SizedBox(height: 5,),
                                  ]
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                        ),
                        Card(
                          elevation: 5,
                          margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                          child: new Material(
                            child: new InkWell(
                              onTap: (){

                                Navigator.pushNamed(context, HouseListPage.routeName);

                                },
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 100,
                                      margin: EdgeInsets.all(10),
                                      child: Image.asset("assets/images/home-round.png"
                                        ,fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    Center(child: Text("House",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                    SizedBox(height: 5,),
                                  ]
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                        ),

                      ]
                  ),
              ],
            ),
          ),
        ),
    );
  }

}
