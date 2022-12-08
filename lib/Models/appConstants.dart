import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/userObjects.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static final String appName = 'BizitMe';
  static final String googleMapsAPIKey =
      "AIzaSyADk43Ssv_jkOg8sws1s0cRkTNjQgCYbDw";
  static final Color selectedIconColor = Colors.deepOrange;
  static final Color nonSelectedIconColor = Colors.black;
  static const String Session = "session";

  static User currentUser;

  static const String CustProfile = "profile_image";
  static const String Token = "token";
  static const String CustEmail = "email";
  static const String CustMobile = "mobile";
  static const String CategoryName = "categoryname";
  static const String UserId = "userid";
  static const String StripeAccountLink = "stripeaccountlink";

  static const String TokenUser = "token";



  static final Map<int, String> monthDict = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  static final Map<int, int> daysInMonths = {
    1: 31,
    2: DateTime.now().year % 4 == 0 ? 28 : 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31,
  };



  static const String CARD_NUMBER1 = "cardinfo1";
  static const String CARD_NUMBER2 = "cardinfo2";
  static const String CARD_NUMBER3 = "cardinfo3";
  static const String CARD_NUMBER4 = "cardinfo4";
  static const String EXPIRY_MONTH = "cardinfo5";
  static const String EXPIRY_YEAR = "cardinfo6";
  static const String CARD_HOLDER_NAME = "cardinfo7";



}
