import 'dart:convert';

import 'dart:typed_data';

import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:intl/intl.dart';



class MyUtils {
List<int> convertBase64ToImage(String _base64) {
  Uint8List bytes = base64.decode(_base64);
  return bytes;
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


Future<String> getDeviceToken() async {

   String _deviceToken=await FirebaseMessaging.instance.getToken();
  Bizitme.saveSharedPrefValueString(AppConstants.Token, _deviceToken);
  print(_deviceToken);
  return _deviceToken;
}

}
