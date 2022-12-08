import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorageListPage extends StatefulWidget {
  static final String routeName = '/StorageListRoute';
  StorageListPage({Key key}) : super(key: key);

  @override
  _StorageListPageState createState() => _StorageListPageState();
}

class _StorageListPageState extends State<StorageListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Storage Nearby me',
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
                              child:Text("Small 5' x 10'",
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
                              Text("Outside unit ,Drive-up access",
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
                              Text("\$72/month",
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
                              child:Text("Medium 10' x 10'",
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
                              Text("Outside unit , Drive-up access",
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
                              Text("\$84/month",
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
                                        text: "46610 S Zara Street San Antonio, TX 75111",
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