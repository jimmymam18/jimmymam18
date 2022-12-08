import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RVListPage extends StatefulWidget {
  static final String routeName = '/RVListRoute';
  RVListPage({Key key}) : super(key: key);

  @override
  _RVListPageState createState() => _RVListPageState();
}

class _RVListPageState extends State<RVListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('RVs Nearby me',
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
                                child:  Image.asset("assets/images/rv1.jpg"
                                  ,fit: BoxFit.fill,
                                ),
                              )
                          ),
                          SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child:Text("2013 Fort hunter",
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
                          Text("Seatbealt 5 ,Sleeps 4,30 fts",
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
                              child:  Image.asset("assets/images/rv2.jpg"
                                ,fit: BoxFit.fill,
                              ),
                            )
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child:Text("2019 tata",
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
                              Text("Seatbealt 8 ,Sleeps 8,35 fts",
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