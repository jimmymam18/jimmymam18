
import 'dart:ui';

import 'package:bizitme/Screens/SelectionRvPersonalPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  static final String routeName = '/SelectionPageRoute';
  SelectionPage({Key key}) : super(key: key);

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child:Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text(
                        'Please Select Personal/business',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //fontFamily: 'Coolveticarg',
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
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
                                    Navigator.pushNamed(context, SelectionRvPersonalPage.routeName);
                                  },
                                  child:Column(
                                      children: <Widget>[
                                        Container(
                                          width: 120,
                                          height: 100,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          child: Image.asset("assets/Images/user.png"
                                            ,fit: BoxFit.contain,
                                          ),
                                        ),
                                        Center(child: Text("Personal",
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
                                onTap: (){print("tapped");},
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 120,
                                        height: 100,
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset("assets/Images/business.png"
                                          ,fit: BoxFit.contain,
                                        ),
                                      ),
                                      Center(child: Text("Business",
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
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

}