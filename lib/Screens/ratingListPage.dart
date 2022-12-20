import 'dart:convert';

import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/SendNotficationRequestModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/ListCursorSliderPage.dart';
import 'package:bizitme/Screens/explorePage.dart';
import 'package:bizitme/Screens/guestHomePage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:bizitme/Views/listWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RatingListPage extends StatefulWidget {

  RatingListPage({Key key}) : super(key: key);

  @override
  _RatingListPageState createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  String str_rating = "";
  double rating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 2,
            leading: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
              child: IconButton(
                icon: Image.asset(
                  'assets/Images/back.png',
                  scale: 7,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            centerTitle: true,
            title: Text("Ratings And Review",
                style: TextStyle(fontSize: 20, fontFamily: "Montserrat"),
                textAlign: TextAlign.center),
            backgroundColor: Color(0xff4996f3),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 5),
              child: AppConstants.ratingModel.length!= 0
                  ?  ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: AppConstants.ratingModel.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctxt, int index) {
                    str_rating =  AppConstants.ratingModel [index].rating;
                    if (str_rating != "") {
                      rating = double.parse(str_rating);
                    }

                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          // next deailspage call
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: new Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      child: new Container(
                                          padding:
                                          new EdgeInsets.all(
                                              5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: <Widget>[


                                              Container(
                                                margin:
                                                const EdgeInsets
                                                    .only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: <
                                                      Widget>[



                                                    Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                          top: 5),
                                                      child: Row(
                                                        children: <
                                                            Widget>[
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                                right:
                                                                0),
                                                            child:
                                                            Text(
                                                              "Name : ",
                                                              style: TextStyle(
                                                                  fontFamily: 'EuclidCircularA-Bold',
                                                                  fontSize: 13,
                                                                  color: Colors.black),
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                            MediaQuery.of(context).size.width * 0.4,
                                                            margin: const EdgeInsets.only(
                                                                right:
                                                                0),
                                                            child:
                                                            Text(
                                                              AppConstants.ratingModel [index]
                                                                  .name.toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.black
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                          top: 5),
                                                      child: Row(
                                                        children: <
                                                            Widget>[
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                                right:
                                                                0),
                                                            child:
                                                            Text(
                                                              "Review : ",
                                                              style: TextStyle(
                                                                  fontFamily: 'EuclidCircularA-Bold',
                                                                  fontSize: 13,
                                                                  color: Colors.black),
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                            MediaQuery.of(context).size.width * 0.6,
                                                            margin: const EdgeInsets.only(
                                                                right:
                                                                0),
                                                            child:
                                                            Text(
                                                              AppConstants.ratingModel [index]
                                                                  .review.toString()==""?"NA":AppConstants.ratingModel [index]
                                                                  .review.toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.black
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),




                                                    Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                          top: 5),
                                                      child: Row(
                                                        children: <
                                                            Widget>[
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                                right:
                                                                0),
                                                            child:
                                                            Text(
                                                              "Rating : ",
                                                              style: TextStyle(
                                                                  fontFamily: 'EuclidCircularA-Bold',
                                                                  fontSize: 13,
                                                                  color: Colors.black),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                                right:
                                                                0),
                                                            child:
                                                            RatingBar.builder(
                                                              initialRating:
                                                              rating,
                                                              minRating:
                                                              1,
                                                              direction:
                                                              Axis.horizontal,
                                                              allowHalfRating:
                                                              true,
                                                              itemCount:
                                                              5,
                                                              itemSize:
                                                              15.0,
                                                              itemPadding:
                                                              EdgeInsets.symmetric(horizontal: 1.0),
                                                              itemBuilder: (context, _) =>
                                                                  Icon(
                                                                    Icons.star,
                                                                    color:
                                                                    Colors.amber,
                                                                  ),
                                                              onRatingUpdate:null,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),



                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    );
                  })
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.90,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Records Found!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )))),
    );
  }

}
