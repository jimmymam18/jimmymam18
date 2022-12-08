import 'package:bizitme/Models/cloud_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:bizitme/global.dart';

class PostingModel
{

   static CloudStorageService instance = CloudStorageService();

  String receiverDeviceToken;
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
  String userName;
  String userEmail;
  String bookingForStatus;
  String stripeAccountLink;
  String calculatedAmount;
  String deviceToken;
  String documentId;
  String userBookingId;
  String compareDocID;
  bool addedFav=false;
  List<String> names;

  List<String> displayImages;

  List<String> imageNames;
  List<String> dates;
  List<String> listDates;

  String docId;
  String transaction_id;
  String date_id;
  String dateOrderId;
  String cancellationDate;
  String subCategories;
  String compareTime;

  PostingModel(
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
        this.dates,
        this.userName,
        this.userEmail,
        this.bookingStatus,
        this.stripeAccountLink,
        this.bookingForStatus,
        this.calculatedAmount,
        this.deviceToken,
        this.documentId,
        this.listDates,
        this.userBookingId,
        this.addedFav,
        this.date_id,
        this.cancellationDate,
        this.compareDocID,
        this.dateOrderId,
        this.subCategories,
        this.compareTime
        }) {
    if (this.id?.isEmpty ?? true) this.id = Uuid().v4().toString();
    this.imageNames = [];
    this.displayImages = [];

  }


  //ADD POST
  Future<void> addPostingInfoToFirestore() async {
    setImageNames();
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
      "stripeAccountLink": this.stripeAccountLink,
      "deviceToken": this.deviceToken,
      "documentId": this.documentId,
      "subCategories": this.subCategories,
    };

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    DocumentReference reference =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection("add_my_post").add(data);
    this.id = reference.id;
    docId = reference.id;
    print("docu,mment id "+this.id);
  }


  //UPDATE POST
  Future<void> updatePostingInfoInFirestore(String id) async {
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
      "documentId": this.documentId,
      "subCategories": this.subCategories,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

  //await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("add_my_post").doc(id).update(data);
    docId = id;

  }


  Future<void> addPostingForAll() async {
    setImageNames();
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
      "stripeAccountLink": this.stripeAccountLink,
      "deviceToken": this.deviceToken,
      "deviceToken": this.deviceToken,
      "documentId": this.docId,
      "subCategories": this.subCategories,
    };

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    DocumentReference reference =
    await FirebaseFirestore.instance.collection('all_post').add(data);
    this.id = reference.id;
    print(this.id);
  }


  Future<void> updatePostingForAll(String id) async {
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
      "stripeAccountLink": this.stripeAccountLink,
      "deviceToken": this.deviceToken,
      "deviceToken": this.deviceToken,
      "documentId": this.documentId,
      "subCategories": this.subCategories,
    };

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
   // DocumentReference reference = await FirebaseFirestore.instance.collection('all_post').doc(id).update(data);
    await FirebaseFirestore.instance.collection("all_post").doc(id).update(data);
    print(this.id);
  }


  Future<void> deletePostingInfoInFirestore(String id) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("add_my_post").doc(id).delete();

  }


  Future<void> deleteListDateInfoInFirestore(String id) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);
    await FirebaseFirestore.instance.collection('all_post').doc(uid).collection("booking_dates").doc(id).delete();

  }

  void setImageNames() {
    this.imageNames = [];
    for (int i = 0; i < this.displayImages.length; i++) {
      String name = displayImages[i];
      print(name);
      this.imageNames.add(name);
    }
  }

  Future<void> getPostingInfoFromFirebaseFirestore() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users').doc(user.uid).collection("add_my_post")
        .doc(this.id)
        .get();
    this.getPostingInfoFromSnapshot(snapshot);
  }

  void getPostingInfoFromSnapshot(DocumentSnapshot snapshot) {
    var documentData = snapshot.data();

/*    this.address = documentData['address'] ?? "";
    this.title = documentData['title'] ?? "";
    this.description = documentData['description'] ?? "";
    this.categoryName = documentData['categoryName'] ?? "";
    this.priceDay = documentData['priceDay'] ?? "";
    this.priceHour = documentData['priceHour'] ?? "";
    this.priceWeek = documentData['priceWeek'] ?? "";

    this.imageNames = List<String>.from(documentData['imageNames']) ?? [];
  */
  }


  //BOOKING POST
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
      "dates": this.dates,
      "bookingForStatus": this.bookingForStatus,
      "calculatedAmount": this.calculatedAmount,
      "calculatedAmount": this.calculatedAmount,
      "documentId": this.documentId,
      "userBookingId": this.userBookingId,
      "transaction_id": this.transaction_id,
      "receiverDeviceToken": this.receiverDeviceToken,
      "cancellationDate": this.cancellationDate,
      "compareDocID": this.compareDocID,
      "subCategories": this.subCategories,
      "compareTime": this.compareTime,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    DocumentReference reference =
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_booking").add(data);
    this.date_id = reference.id;
    print(this.date_id);


//      await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);
  //  await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_booking").add(data); // old query
//    await FirebaseFirestore.instance.collection('users/$uid').doc('my_booking/${this.id}').update(data);

//    await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_booking").doc(fileID).update(data); // new query

  }

  //CANCEL POST
  Future<void> CANCELBOOKINGFirestore(String id, String date) async {
    // setImageNames();
    Map<String, dynamic> data = {
      "bookingStatus": this.bookingStatus,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

//      await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);
//    await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_booking").add(data);
    //await FirebaseFirestore.instance.collection('users/$uid').doc('my_booking/${id}').update(data);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid).collection("my_booking").doc(id)
        .update({
      "bookingStatus":"Cancelled",
      "cancellationDate":date
    }).then((result){
      print("new USer true");
    }).catchError((onError){
      print("onError");
    });

  }

  //CANCEL POST
  Future<void> CANCELBOOKINGFirestore2(String id,String documentId, String date) async {
    // setImageNames();
    Map<String, dynamic> data = {
      "bookingStatus": this.bookingStatus,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

//      await FirebaseFirestore.instance.collection('users/$uid').doc('add_my_post/${this.id}').update(data);
//    await FirebaseFirestore.instance.collection('users').doc(uid).collection("my_booking").add(data);
    //await FirebaseFirestore.instance.collection('users/$uid').doc('my_booking/${id}').update(data);


    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("my_booking")
        .where("documentId", isEqualTo :documentId)
        .get().then((value){
      value.docs.forEach((element) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(id).collection("my_booking").doc(element.id)
            .update({
          "bookingStatus":"Cancelled",
          "cancellationDate":date
        }).then((result){
          print("new USer true");
        }).catchError((onError){
          print("onError");
        });
      });
    });
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
      "userEmail": this.userEmail,
      "userName": this.userName,
      "bookingForStatus": this.bookingForStatus,
      "calculatedAmount": this.calculatedAmount,
      "documentId": this.documentId,
      "userBookingId": this.userBookingId,
      "transaction_id": this.transaction_id,
      "receiverDeviceToken": this.receiverDeviceToken,
      "cancellationDate": this.cancellationDate,
      "compareDocID": this.compareDocID,
      "subCategories": this.subCategories,
      "compareTime": this.compareTime,

    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    DocumentReference reference =
    await FirebaseFirestore.instance.collection('users').doc(id).collection("my_order").add(data);  // old qurey
//    await FirebaseFirestore.instance.collection('users').doc(id).collection("my_order").doc(fileID).update(data); // new query
    this.dateOrderId = reference.id;
    print(this.dateOrderId);
  }

  Future<void> CancelMyOrderInfoInFirestore(String id,String userid,String date) async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .collection("my_order")
        .where("documentId", isEqualTo :id)
        .get().then((value){
      value.docs.forEach((element) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(userid).collection("my_order").doc(element.id)
            .update({
          "bookingStatus":"Cancelled",
          "cancellationDate":date
        }).then((result){
          print("new USer true");
        }).catchError((onError){
          print("onError");
        });
      });
    });

  }

  Future<void> CancelMyOrderInfoInFirestore2(String docId,String userid,String date) async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("my_order")
        .where("documentId", isEqualTo :docId)
        .get().then((value){
      value.docs.forEach((element) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(uid).collection("my_order").doc(element.id)
            .update({
          "bookingStatus":"Cancelled",
          "cancellationDate":date
        }).then((result){
          print("new USer true");
        }).catchError((onError){
          print("onError");
        });


      });
    });






  }




  Future<void> MyBoookingAvailableDateInfoInFirestore(String saveBookingId) async {
    // setImageNames();
    Map<String, dynamic> data = {
      "listDates": this.listDates,
      "idBooking":this.date_id,
      "idOrder":this.dateOrderId,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    await FirebaseFirestore.instance.collection('all_post').doc(saveBookingId).collection("booking_dates").add(data); // old qurey

//    await FirebaseFirestore.instance.collection('all_post').doc(id).collection("booking_dates").doc(fileID).update(data); // new query

  }



  Future<void> CancelMyBoookingAvailableDateInfoInFirestore(String idString) async {
    // setImageNames();
    Map<String, dynamic> data = {
      "listDates": this.listDates,
    };
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(user.uid);

    await FirebaseFirestore.instance.collection('all_post').doc(id).collection("booking_dates").add(data); // old qurey

//    await FirebaseFirestore.instance.collection('all_post').doc(id).collection("booking_dates").doc(fileID).update(data); // new query


  }


}