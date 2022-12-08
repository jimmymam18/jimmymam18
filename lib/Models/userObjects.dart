import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bizitme/Models/messagingObjects.dart';
import 'package:bizitme/Models/postingObjects.dart';
import 'package:bizitme/Models/reviewObjects.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'appConstants.dart';

class Contact {
  String id;
  String firstName;
  String lastName;
  MemoryImage displayImage;

  Contact(
      {this.id = "",
        this.firstName = "",
        this.lastName = "",
        this.displayImage});

  Future<void> getContactInfoFromFirestore() async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(this.id).get();

/*    this.firstName = snapshot.data()['firstName'] ?? "";
    this.lastName = snapshot.data()['lastName'] ?? "";*/

  }

  Future<MemoryImage> getImageFromStorage() async {
    if (displayImage != null) {
      return displayImage;
    }
    final String imagePath = "userImage/${this.id}/profile_pic.jpg";
    final imageData = await FirebaseStorage.instance
        .ref()
        .child(imagePath)
        .getData(1024 * 1024);
    this.displayImage = MemoryImage(imageData);
    return this.displayImage;
  }

  String getFullName() {
    return this.firstName + " " + this.lastName;
  }

  User createUserFromContact() {
    return User(
      firstName: this.firstName,
      lastName: this.lastName,
      displayImage: this.displayImage,
    );
  }
}

class User extends Contact {
  DocumentSnapshot snapshot;
  String email;
  String bio;
  String city;
  String country;
  bool isHost;
  bool isCurrentlyHosting;
  String password;

  List<Booking> bookings;
  List<Review> reviews;
  List<Conversation> conversations;
  List<Posting> savedPostings;
  List<Posting> myPostings;
  User({
    String id = "",
    String firstName = "",
    String lastName = "",
    MemoryImage displayImage,
    this.email = "",
    this.bio = "",
    this.city = "",
    this.country = "",
  }) : super(
      id: id,
      firstName: firstName,
      lastName: lastName,
      displayImage: displayImage) {
    this.isHost = false;
    this.isCurrentlyHosting = false;
    this.bookings = [];
    this.reviews = [];
    this.conversations = [];
    this.savedPostings = [];
    this.myPostings = [];
  }
  Future<void> getUserInfoFromFirestore() async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(this.id).get();
    this.snapshot = snapshot;

/*
    this.firstName = snapshot.data()['firstName'] ?? "";
    this.lastName = snapshot.data()['lastName'] ?? "";
    this.email = snapshot.data()['email'] ?? "";
    this.bio = snapshot.data()['bio'] ?? "";
    this.city = snapshot.data()['city'] ?? "";
    this.country = snapshot.data()['country'] ?? "";
    this.isHost = snapshot.data()['isHost'] ?? false;
*/

  }

  Future<void> getPersonalInfoFromFirestore() async {
    await getUserInfoFromFirestore();
    await getImageFromStorage();
    await getMyPostingsFromFirestore();
    await getSavedPostingsFromFirestore();
    await getAllBookingsFromFirestore();
  }

  Future<void> getMyPostingsFromFirestore() async {

/*    List<String> myPostingIDs = List<String>.from(snapshot.data()['myPostingIDs']) ?? [];

    for (String postingID in myPostingIDs) {
      Posting newPosting = Posting(id: postingID);
      await newPosting.getPostingInfoFromFirebaseFirestore();
      await newPosting.getAllBookingsFromFirestore();
      await newPosting.getAllImagesFromStorage();
      this.myPostings.add(newPosting);
    }
   */
  }

  Future<void> getSavedPostingsFromFirestore() async {

/*    List<String> savedPostingIDs = List<String>.from(snapshot.data()['savedPostingIDs']) ?? [];

    for (String postingID in savedPostingIDs) {
      Posting newPosting = Posting(id: postingID);
      await newPosting.getPostingInfoFromFirebaseFirestore();
      await newPosting.getFirstImageFromStorage();
      this.savedPostings.add(newPosting);
    }
    */
  }

  Future<void> addUserToFirestore() async {
    Map<String, dynamic> data = {
      "bio": this.bio,
      "city": this.city,
      "country": this.country,
      "email": this.email,
      "firstName": this.firstName,
      "isHost": false,
      "lastName": this.lastName,
      "myPostingIDs": [],
      "savedPostingIDs": []
    };
    await FirebaseFirestore.instance.doc('users/${this.id}').set(data);
  }

  Future<void> updateUserInFirestore() async {
    Map<String, dynamic> data = {
      "bio": this.bio,
      "city": this.city,
      "country": this.country,
      "firstName": this.firstName,
      "lastName": this.lastName,
    };
    await FirebaseFirestore.instance.doc('users/${this.id}').update(data);
  }

  Future<void> saveImageToFirestore(File imageFile) async {

/*    StorageReference reference = FirebaseStorage.instance.ref().child('userImages/${this.id}/profile_pic.jpg');
    await reference.putFile(imageFile).onComplete;
    this.displayImage = MemoryImage(imageFile.readAsBytesSync());
    print("DISPLAY IMAE: "+displayImage.toString());
 */
  }

  void changeCurrentlyHosting(bool isHosting) {
    this.isCurrentlyHosting = isHosting;
  }

  Future<void> becomeHost() async {
    this.isHost = true;
    Map<String, dynamic> data = {
      'isHost': true,
    };
    await FirebaseFirestore.instance.doc('users${this.id}').update(data);
    this.changeCurrentlyHosting(true);
  }

  Contact createContactFromUser() {
    return Contact(
      id: this.id,
      firstName: this.firstName,
      lastName: this.lastName,
      displayImage: this.displayImage,
    );
  }

  Future<void> addPostingToMyPosting(Posting posting) async {
    this.myPostings.add(posting);
    List<String> myPostingIDs = [];
    this.myPostings.forEach((posting) {
      myPostingIDs.add(posting.id);
    });

    await FirebaseFirestore.instance
        .doc('users/${this.id}')
        .update({'myPostingIDs': myPostingIDs});
  }

  Future<void> getAllBookingsFromFirestore() async {
    this.bookings = [];
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('users/${this.id}/bookings')
        .get();
    for (var snapshot in snapshots.docs) {
      Booking newBooking = Booking();
      await newBooking.getBookingInfoFromFirestoreFromUser(
          this.createContactFromUser(), snapshot);
      this.bookings.add(newBooking);
    }
  }

  Future<void> addBookingToFirestore(Booking booking) async {
    Map<String, dynamic> data = {
      'dates': booking.dates,
      'postingID': booking.posting.id,
    };
    await FirebaseFirestore.instance
        .doc('users/${this.id}/bookings/${booking.id}')
        .set(data);
    this.bookings.add(booking);
    await addBookingConversation(booking);
  }

  Future<void> addBookingConversation(Booking booking) async {
    Conversation conversation = Conversation();
    await conversation.addConversationToFirestore(booking.posting.host);
    String text =
        "Hi my name is ${AppConstants.currentUser.firstName} and I have "
        " just booked ${booking.posting.name} from ${booking.dates.first} to ${booking.dates.last}. "
        "If you have any questions feel free to contact me, otherwise I look forward to the stay!";
    await conversation.addMessageToFirestore(text);
  }

  List<DateTime> getAllBookedDates() {
    List<DateTime> allBookedDates = [];
    this.myPostings.forEach((posting) {
      posting.bookings.forEach((booking) {
        allBookedDates.addAll(booking.dates);
      });
    });
    return allBookedDates;
  }

  Future<void> addSavedPosting(Posting posting) async {
    for (var savedPosting in this.savedPostings) {
      if (savedPosting.id == posting.id) {
        return;
      }
    }
    this.savedPostings.add(posting);
    List<String> savedPostingIDs = [];
    this.savedPostings.forEach((savedPosting) {
      savedPostingIDs.add(savedPosting.id);
    });
    await FirebaseFirestore.instance.doc('users/${this.id}').update({
      'savedPostingIDs': savedPostingIDs,
    });
  }

  Future<void> removeSavedPosting(Posting posting) async {
    for (int i = 0; i < this.savedPostings.length; i++) {
      if (this.savedPostings[i].id == posting.id) {
        this.savedPostings.removeAt(i);
        break;
      }
    }
  }

  List<Booking> getPreviousTrips() {
    List<Booking> previousTrips = [];
    this.bookings.forEach((booking) {
      if (booking.dates.last.compareTo(DateTime.now()) <= 0) {
        previousTrips.add(booking);
      }
    });
    return previousTrips;
  }

  List<Booking> getUpcomingTrips() {
    List<Booking> upcomingTrips = [];
    this.bookings.forEach((booking) {
      if (booking.dates.last.compareTo(DateTime.now()) > 0) {
        upcomingTrips.add(booking);
      }
    });
    return upcomingTrips;
  }

  double getCurrentRating() {
    if (this.reviews.length == 0) {
      return 4;
    }
    double rating = 0;
    this.reviews.forEach((review) {
      rating += review.rating;
    });
    rating /= this.reviews.length;
    return rating;
  }

  Future<void> postNewReview(String text, double rating) async {
    Map<String, dynamic> data = {
      'dateTime': DateTime.now(),
      'name': AppConstants.currentUser.getFullName(),
      'rating': rating,
      'text': text,
      'userID': AppConstants.currentUser.id,
    };
    await FirebaseFirestore.instance
        .collection('users/${this.id}/reviews')
        .add(data);
  }
}
