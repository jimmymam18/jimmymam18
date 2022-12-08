import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HouseListPage extends StatefulWidget {
  static final String routeName = '/HouseListRoute';
  HouseListPage({Key key}) : super(key: key);

  @override
  _HouseListPageState createState() => _HouseListPageState();
}

class _HouseListPageState extends State<HouseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('House Nearby me',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: new SafeArea(
        child: Container(
            padding: new EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                  child: new Material(
                    child: Column(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              height: 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                child:  Image.asset("assets/images/storage2.jpg"
                                  ,fit: BoxFit.fill,
                                ),
                              )
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:Text("Villa Us",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Text("On entering the villa you are met with light and spacious open plan living.",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Text("2 BHK",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Text("\$250/night",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child:
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "4910 S Zara Street San Antonio, TX 76611",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Montserrat',
                                            color: Colors.black
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(Icons.navigation, size: 14,),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                        ]
                    ),

                    color: Colors.transparent,
                  ),
                ),
                SizedBox(height: 15,),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.only(left:10.0,top:0,right:10.0,bottom:0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10), topLeft:  Radius.circular(10)),),
                  child: new Material(
                    child: Column(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              height: 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                child:  Image.asset("assets/images/storage1.jpg"
                                  ,fit: BoxFit.fill,
                                ),
                              )
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:Text("lemo villa",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Text("The pool is 10m*6m and 1,80m deep – in the integrated pool area there are 4 refreshing jet spas.",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Text("4 BHK",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Text("\$180/night",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child:
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "4510 S Zara Street San Antonio, TX 79111",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Montserrat',
                                            color: Colors.black
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(Icons.navigation, size: 14,),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                        ]
                    ),

                    color: Colors.transparent,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}