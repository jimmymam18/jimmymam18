import 'dart:convert';
import 'package:bizitme/Models/BookingPaymentRequest.dart';
import 'package:bizitme/Models/BookingPaymentResponse.dart';
import 'package:bizitme/Models/CancelBookingRequest.dart';
import 'package:bizitme/Models/CancelBookingResponse.dart';
import 'package:bizitme/Models/OtpRequest.dart';
import 'package:bizitme/Models/OtpResponse.dart';
import 'package:bizitme/Models/StripeDetails/StripeDetailRequest.dart';
import 'package:bizitme/Models/StripeDetails/StripeDetailResponse.dart';
import 'package:bizitme/helper/API.dart';
import 'package:http/http.dart' as http;

Future<BookingPaymentResponse> bookingRef(BookingPaymentRequest requestModel) async {
  BookingPaymentResponse responseModel;

  final String url = API.payment_API_bid_confirmation_web;

 try
 {

   final response = await http.post(
     Uri.parse(url),
     headers: {"Content-Type": "application/json"},
     body: json.encode(requestModel.toJson()),
   );
   print(requestModel.toJson().toString());
   if (response.statusCode == 200) {
     responseModel = BookingPaymentResponse.fromJson(json.decode(response.body));
   }
 }
 catch(e)
 {
   print("rrrreeeee "+e.toString());
 }


  return responseModel;
}

Future<CancelBookingResponse> cancelBookingRef(CancelBookingRequest requestModel) async {
  CancelBookingResponse responseModel;

  final String url = API.refund_api_web;

  final response = await http.post(
    (Uri.parse(url)),
    headers: {"Content-Type": "application/json"},
    body: json.encode(requestModel.toJson()),
  );
  print(requestModel.toJson().toString());
  if (response.statusCode == 200) {
    responseModel = CancelBookingResponse.fromJson(json.decode(response.body));
  }
  return responseModel;
}


Future<OtpResponse> otpRef(OtpRequest requestModel) async {
  OtpResponse responseModel;


  print("OtpRequest" +
      requestModel.toJson().toString());


  final String url = API.send_otp;

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(requestModel.toJson()),
  );
  print("response "+requestModel.toJson().toString());
  if (response.statusCode == 200) {
    responseModel = OtpResponse.fromJson(json.decode(response.body));
  }
  return responseModel;
}


Future<StripeDetailResponse> stripe_detail(StripeDetailRequest requestModel) async {
  StripeDetailResponse responseModel;


  print("StripeDetailRequest" +
      requestModel.toJson().toString());


  final String url = API.Stripe_payment;

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(requestModel.toJson()),
  );
  print("response "+requestModel.toJson().toString());
  if (response.statusCode == 200) {
    responseModel = StripeDetailResponse.fromJson(json.decode(response.body));
  }
  return responseModel;
}