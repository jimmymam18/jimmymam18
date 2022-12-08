import 'dart:convert';

import 'dart:typed_data';

import 'package:bizitme/Models/appConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'SHDF.dart';


class MyUtils {



// convert base 64 to bytes
  List<int> convertBase64ToImage(String _base64) {
    Uint8List bytes = base64.decode(_base64);
    return bytes;
  }

  // handle null data
  String checkNull(String value) {
    if (value == null) {
      value = "";
    }
    return value;
  }

  var loadImage = new AssetImage('assets/images/noimage.png');

  String checkandReplaceNumbers(String value) {
    String newValue = "";
    StringBuffer strBuff = new StringBuffer();

    if (value == null) {
      value = "";
    }
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

    // print(value.replaceAll("\\d", ""));

    print("changedcity" + newValue.trim());
    //newValue=value;
    return newValue.trim();
  }

  Future<String> getBaseUrl() async {
    Map<String, dynamic> dmap =
        await MyUtils().parseJsonFromAssets('assets/cfg/configurations.json');
    print(dmap["base_url"]);
    return dmap["base_url"];
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  String getCurrentDate() {
    DateTime now = new DateTime.now();

    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();

    if (day.length == 1) {
      day = "0" + day;
    }
    if (month.length == 1) {
      month = "0" + month;
    }
    String date = day + "/" + month + "/" + year;

    return date;
  }

  String getCurrentTime() {
    DateTime now = new DateTime.now();

    var formatter = new DateFormat('hh:mm a');
    String time = formatter.format(now);

    //String time = now.hour.toString() + ":" + now.minute.toString();
    print(time);
    return time;
  }

  String getCurrentTimeWithSeconds() {
    DateTime now = new DateTime.now();

    var formatter = new DateFormat('hh:mm:ss a');
    String time = formatter.format(now);

    //String time = now.hour.toString() + ":" + now.minute.toString();
    print(time);
    return time;
  }

  bool validatePasswordStructure(String value) {

    String pattern = r'^(?=.*[A-Z])(?=.*?[0-9])';
    String pattern2 = r'^(?=.*?[0-9])(?=.*[A-Z])';
    RegExp regExp = new RegExp(pattern);
    RegExp regExp2 = new RegExp(pattern2);

    bool status = false;

    if (regExp.hasMatch(value) || regExp2.hasMatch(value)) {
      status = true;
    } else {
      status = false;
    }
    return status;
  }

  String convertToUtf8(String value) {
    var encoded = utf8.encode(value);
    //var decoded = utf8.decode(encoded);
    var decoded = utf8.decode(value.runes.toList());

    //print(encoded);
//print(decoded);
    return decoded;
  }

  Future<bool> getInternetStatus() async {

    bool available=false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        available=true;

      }
    } on SocketException catch (_) {

      available=false;

    }

    return available;
  }


  Future<String> getDeviceToken() async {

    String _deviceToken= await  FirebaseMessaging.instance.getToken();
    SHDFClass.saveSharedPrefValueString(AppConstants.TokenUser, _deviceToken);
    print("_deviceToken "+_deviceToken);
    return _deviceToken;
  }

}

bool progressDialog = false;
bool internetPopupStatus = false;
