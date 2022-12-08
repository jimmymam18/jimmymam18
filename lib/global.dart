import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double global_lati = 0.0;
double global_longi = 0.0;


String strUserId = "";
String strProfileName = "";
String strProfileEmail = "";
String strProfileImage = "";

bool custom_route = true;
bool sayg_route = false;

String strcustomePrice="";
String strcustomedistance="";
String strsaygPrice="";
String strsaygDistance="";

String strdistance_type="";
String strApproximatepricecad="";
String strURL="";

TextEditingController txtApproximatepricecad =
new TextEditingController();


File selectedImage;
String capitalize1(String s) => s[0].toUpperCase() + s.substring(1);
String sentence(String s) => toBeginningOfSentenceCase(s); // This is a string

String currentUserChat="";

var _loadImage = new AssetImage('assets/images/noimage.png');

int intialMainTabPosition = 0;

String strnoti_title="";
String strnoti_body="";
GlobalKey<ScaffoldState>  globalKey;
BuildContext globalContext;
bool click_flag_for_notification=false;
String NotificationClickAction="";
BuildContext context_global;

 String checkNull(String value) {
  if (value == null) {
    value = "";
  }
  return value;
}


String chatPreviousDate="";
String checkandReplaceNumbers(String value) {
  String newValue = "";
  StringBuffer strBuff = new StringBuffer();
  for (int i = 0; i < value.length; i++) {
    var char = value[i];
    try {
      if (int.parse(char) >= 4) {
        print(value[i]);
        newValue = newValue + value[i].replaceAll(value[i], "");
        print(newValue);
      }
    } catch (e) {
      print("error");
      newValue = newValue + char;
    }
  }
  print("changedcity" + newValue.trim());
  return newValue.trim();
}



bool from_mybooking=false;

