import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Screens/MyOrdersListPage.dart';
import 'package:bizitme/Screens/MyPostPage.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPostWarningPage extends StatefulWidget {
  final String title;
  final String description;
  final String location;
  final String priceHour;
  final String priceDay;
  final String priceWeek;
  final String categoryName;
  final String postingDate;
  final String latitude;
  final String longitude;
  final String latlng;
  final String subCategories;
  final List<String> names;
  final List<String> documentId;

  MyPostWarningPage({Key key, this.title, this.description, this.location, this.priceDay
    ,this.priceWeek, this.priceHour, this.categoryName, this.names, this.postingDate, this.documentId, this.latitude,
  this.longitude, this.latlng, this.subCategories}) : super(key: key);

  @override
  _MyPostWarningPageState createState() => _MyPostWarningPageState();
}

class _MyPostWarningPageState extends State<MyPostWarningPage> {

  List<String> names = new List();

  void _ShowBottomSheet_Continueclick() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/Images/Success.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Success!',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'You Post deleted successfully ',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Back"),
                        ),
                      ),
                      Container(
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {},
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Continue"),
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Container(
                  //       //margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                  //       child: MaterialButton(
                  //         onPressed: () {
                  //           Navigator.pop(context);
                  //           // Navigator.pushNamed(context, LoginPage.routeName);
                  //         },
                  //         child: Text(
                  //           'Back',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16.0,
                  //             fontFamily: 'Montserrat',
                  //             color: Colors.blue,
                  //           ),
                  //         ),
                  //         color: Colors.white,
                  //         height: 20,
                  //         minWidth: double.infinity,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       //margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                  //       child: MaterialButton(
                  //         onPressed: () {
                  //           Navigator.pop(context);
                  //           // Navigator.pushNamed(context, LoginPage.routeName);
                  //         },
                  //         child: Text(
                  //           'Continue',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16.0,
                  //             fontFamily: 'Montserrat',
                  //             color: Colors.blue,
                  //           ),
                  //         ),
                  //         color: Colors.white,
                  //         height: 20,
                  //         minWidth: double.infinity,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        });
  }


  void getImage(){
    names.clear();
    for(int i=0; i< widget.names.length; i++){
      print("IMAGES NAME "+widget.names[i]);
      names.add(widget.names[i]);
    }
  }

  @override
  void initState(){
    getImage();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyPostPage()));
        setState(() {});

      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Post',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Montserrat",
              ),
              textAlign: TextAlign.center),
          centerTitle: true,
          backgroundColor: Color(0xff4996f3),
          leading: IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyPostPage()));
              setState(() {});
            },
          ),
        /*  actions: [
            InkWell(
              onTap: () {
                _ShowBottomSheet_warningPage();
              },
              child: Icon(Icons.delete),
            ),
          ],*/
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: 200.0,
                      width: 420.0,
                      child: Carousel(
                        images: names.map((e) => Container(
                          child: Image.network(e),
                        )).toList(),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                        top: MediaQuery.of(context).size.height * 0.03 ),
                    child: Row(
                      children: [
                    Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                      child:  Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat_Medium",
                            color: Colors.black),
                      ),
                    )

                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/Images/favourite_off.png',
                              height: 28,
                              width: 28,
                            ),
                            Image.asset(
                              'assets/Images/chat.png',
                              height: 28,
                              width: 28,
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     Expanded(child:  Container(
                       margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                           top: MediaQuery.of(context).size.height * 0.03 ),
                       width: MediaQuery.of(context).size.width * 0.49,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Text(
                             'Category',
                             style: TextStyle(
                               color: Colors.black,
                               fontSize: 10,
                               fontFamily: 'Montserrat_Medium',
                             ),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Row(
                             children: [
                               Image.asset(
                                 'assets/Images/rv_category.png',
                                 height: 18,
                                 width: 18,
                               ),
                               Padding(
                                 padding: EdgeInsets.only(left: 3),
                               ),
                               Text(
                                 widget.categoryName,
                                 style: TextStyle(
                                     color: Colors.black, fontSize: 14,),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),),
                      Padding(
                        padding: EdgeInsets.only(left: 2),
                      ),
                     Expanded(child:  Container(
                       margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                           top: MediaQuery.of(context).size.height * 0.03 ),
                       width: MediaQuery.of(context).size.width * 0.50,
                       child:Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'Posting Date',
                             style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 10,
                                 fontFamily: 'Montserrat_Medium'),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Row(
                             children: [
                               Image.asset(
                                 'assets/Images/date.png',
                                 height: 13,
                                 width: 15,
                               ),
                               Text(widget.postingDate,
                                   style: TextStyle(
                                       fontSize: 13,
                                       fontFamily: "Montserrat_Medium",
                                   )),
                             ],
                           ),
                         ],
                       ),
                     ),)
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),

                 Row(
                   children: [
                     Container(
                       margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                           top: MediaQuery.of(context).size.height * 0.03 ),
                     //  width: MediaQuery.of(context).size.width *0.80,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Text(
                             'Sub Category',
                             style: TextStyle(
                               color: Colors.black,
                               fontSize: 10,
                               fontFamily: 'Montserrat_Medium',
                             ),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Row(
                             children: [
                               Image.asset(
                                 'assets/Images/rv_category.png',
                                 height: 18,
                                 width: 18,
                               ),
                               Padding(
                                 padding: EdgeInsets.only(left: 3),
                               ),
                             Container(
                               width: MediaQuery.of(context).size.width* 0.90,
                               child:  Text(
                                 widget.subCategories == null || widget.subCategories == ""?"NA": widget.subCategories,
                                 maxLines: 3,
                                 style: TextStyle(
                                   color: Colors.black, fontSize: 14,),
                               ),
                             ),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),

                Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.03 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 0, bottom: 0, top: 0),
                      ),
                      Text(
                        'Price',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Montserrat_Medium',
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Container(
                          child:   Row(
                            children: [
                              widget.priceHour != ""
                             ? Expanded(child: Row(
                                children: [
                                  Image.asset(
                                    'assets/Images/my_post.png',
                                    height: 11,
                                    width: 13,
                                  ),
                                  Text(
                                    '\$'+widget.priceHour+"/Hour",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ],
                              ),)
                              :Container(),
                              widget.priceDay != ""
                             ? Expanded(child: Row(
                                children: [
                                  Image.asset(
                                    'assets/Images/my_post.png',
                                    height: 11,
                                    width: 14,
                                  ),
                                  Text(
                                    '\$'+widget.priceDay+"/Day",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ],
                              ))
                              :Container(),
                              widget.priceWeek != ""
                             ? Expanded(child: Row(
                                children: [
                                  Image.asset(
                                    'assets/Images/date.png',
                                    height: 11,
                                    width: 13,
                                  ),
                                  Text(
                                    '\$'+widget.priceWeek+"/Week",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ],
                              ))
                              :Container(),
                            ],
                          ),
                        ),
                          /*Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/Images/date.png',
                                  height: 11,
                                  width: 13,
                                ),
                                Text(
                                  '\$'+widget.priceWeek+"/Week",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat'),
                                ),
                              ],
                            ),
                          ),*/
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                          child:   Text(
                            '(Price inclusive for all taxes)',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Montserrat',
                            ),
                            textAlign: TextAlign.start,
                          ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                        right: MediaQuery.of(context).size.height * 0.02,
                        top: MediaQuery.of(context).size.height * 0.01 ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Text(
                            'Description',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Montserrat_Medium',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 12.0, right: 0, bottom: 0, top: 5),
                        ),
                       Container(
                         width: MediaQuery.of(context).size.width * 0.90,
                         child:  Text(
                           widget.description,
                           style: TextStyle(
                               fontSize: 10,
                               fontFamily: 'Montserrat',
                               fontWeight: FontWeight.w500),
                         ),
                       )
                      ],
                    ),
                  ),

                Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.04 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Montserrat_Medium',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 12.0, right: 0, bottom: 0, top: 8),
                      ),
                      InkWell(
                        onTap: (){
                          openMap();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Container(
                              width:  MediaQuery.of(context).size.width * 0.85,
                              child:  Text(
                                widget.location,
                                maxLines: 5,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2, right: 4),
                            ),
                            Image.asset(
                              'assets/Images/location.png',
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderListPage()));
                    },
                    child: Row(
                      children: [
                        Text(
                          'Booking History',
                          style: TextStyle(
                              color: Color(0xff2196f3),
                              fontSize: 12,
                              fontFamily: 'Montserrat'),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _ShowBottomSheet_warningPage() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/Images/Success.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Warning',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Are you sure want to delete this post ?',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Back"),
                        ),
                      ),
                      Container(
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {

                            setState(() {});
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Continue"),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
        });
  }

  Future<void> openMap() async {
    String lat = widget.latitude;
    String long = widget.longitude;
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + lat + ',' + long + '&travelmode=driving&dir_action=navigate';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

}
