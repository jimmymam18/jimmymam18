import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bizitme/SingleChat/ChatMessageModel.dart';
import 'package:bizitme/SingleChat/Peoples.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bizitme/Utils/MyUtilClass.dart';
import 'package:bizitme/screens/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';


typedef void OnError(Exception exception);

class ItemSingleChatMe extends StatefulWidget {
  final ChatMessageModel chatMessageModel;
  UsersData usersData;
  String strProfileEmail;
  final ValueChanged<ChangerModel> parentAction;

  ItemSingleChatMe(this.chatMessageModel, this.usersData, this.parentAction,this.strProfileEmail);

  @override
  ItemChatMeScreenState createState() => ItemChatMeScreenState();
}

class ChangerModel {
  String message = "";
  String status = "";
}

//
class ItemChatMeScreenState extends State<ItemSingleChatMe> {
  String date = "";
  String time = "";
  String strProfileEmail = "";

  @override
  void initState() {
    strProfileEmail = widget.strProfileEmail;
    time = widget.chatMessageModel.time;
    List<String> splitedWitSpace = time.split(" ");
    List<String> splitedRemovedSec = splitedWitSpace[0].split(":");
    String hour = splitedRemovedSec[0];
    String min = splitedRemovedSec[1];
    time = hour + ":" + min + " " + splitedWitSpace[1];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.chatMessageModel.date != ""
            ? Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.001,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,
               ),
                color: Colors.black45,
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  //  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                  /* boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 1,
                            color: Colors.grey)
                      ],*/
                ),
                child: Padding(
                  child: Text(
                    new MyUtils().getCurrentDate() ==
                        widget.chatMessageModel.date
                        ? "Today"
                        : widget.chatMessageModel.date,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontFamily: 'normal',
                    ),
                  ),
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.001,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                color: Colors.black45,
              ),
            ],
          )
        )
            : SizedBox(),
        Container(
          child: widget.chatMessageModel.sender_email != strProfileEmail
              ?
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                Flexible(
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: new Color(0xffE6F0FF),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.usersData.strName,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'normal',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        widget.chatMessageModel.message,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .apply(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              time,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black26,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'normal',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),

                        ],
                      )),
                ),
                SizedBox(width: 5),
              ],
            ),
            padding: EdgeInsets.only(top: 15),
          )
              :

              //chat me row
              Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 5),
                      Flexible(
                        child: Container(
                            padding: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.only(left: 30),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "You",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'normal',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              widget.chatMessageModel.message,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .apply(
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    time,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black26,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'normal',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ],
                                ),

                              ],
                            )),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 15),
                ),
        )
      ],
    );
  }
}
