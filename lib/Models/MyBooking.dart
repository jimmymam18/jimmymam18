import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MyBooking{


  static CloudStorageService instance = CloudStorageService();

  String id;
  String title;
  String description;
  String address;
  String categoryName;
  String priceHour;
  String priceDay;
  String priceWeek;
  String postingDate;
  String latitude;
  String longitude;
  String latlng;
  String wishList;
  String bookingStatus;
  String userId;
  String fromDate;
  String toDate;
  String startTime;
  String endTime;
  String noOfHour;
  List<String> names;

  List<String> displayImages;

  List<String> imageNames;

  MyBooking(
      {this.id,
        this.title = "",
        this.description = "",
        this.address = "",
        this.categoryName,
        this.priceDay,
        this.priceHour,
        this.priceWeek,
        this.names,
        this.postingDate,
        this.latlng,
        this.longitude,
        this.latitude,
        this.wishList,
        this.userId,
        this.fromDate,
        this.toDate,
        this.startTime,
        this.endTime,
        this.noOfHour,
        this.bookingStatus
      }) {
    if (this.id?.isEmpty ?? true) this.id = Uuid().v4().toString();
    this.imageNames = [];
    this.displayImages = [];
  }

  Future<void> MyBoookingInfoInFirestore(String id) async {
    // setImageNames();
    Map<String, dynamic> data = {
      "address": this.address,
      "title": this.title,
      "description": this.description,
      "imageNames": this.imageNames,
      "categoryName": this.categoryName,
      "priceDay": this.priceDay,
      "priceHour": this.priceHour,
      "priceWeek": this.priceWeek,
      "postingDate": this.postingDate,
      "latlng": this.latlng,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "wishList": this.wishList,
      "bookingStatus": this.bookingStatus,
      "userId": this.userId,
      "fromDate": this.fromDate,
      "toDate": this.toDate,
      "startTime": this.startTime,
      "endTime": this.endTime,
      "noOfHour": this.noOfHour,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    //  await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_booking").add(data);

  }


  Future<void> MyOrderInfoInFirestore(String id) async {
    Map<String, dynamic> data = {
      "address": this.address,
      "title": this.title,
      "description": this.description,
      "imageNames": this.imageNames,
      "categoryName": this.categoryName,
      "priceDay": this.priceDay,
      "priceHour": this.priceHour,
      "priceWeek": this.priceWeek,
      "postingDate": this.postingDate,
      "latlng": this.latlng,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "wishList": this.wishList,
      "bookingStatus": this.bookingStatus,
      "userId": this.userId,
      "fromDate": this.fromDate,
      "toDate": this.toDate,
      "startTime": this.startTime,
      "endTime": this.endTime,
      "noOfHour": this.noOfHour,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_order").add(data);
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("add_my_post").doc(id).collection("my_order").add(data);

  }



}