import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bizitme/Models/userObjects.dart';

class Review {
  Contact contact;
  String text;
  double rating;
  DateTime dateTime;

  Review();

  void createReview(
      Contact contact, String text, double rating, DateTime dateTime) {
    this.contact = contact;
    this.text = text;
    this.rating = rating;
    this.dateTime = dateTime;
  }

  void getReviewInfoFromFirestore(DocumentSnapshot snapshot) {
    var documentData = snapshot.data();

/*    this.rating = documentData['rating'].toDouble() ?? 2.5;
    this.text = documentData['test'] ?? " ";

    Timestamp timestamp = documentData['dateTime'] ?? Timestamp.now();
    this.dateTime = timestamp.toDate();
    String fullName = documentData['name'] ?? " ";
    String contactID = documentData['userID'] ?? " ";

    _loadContactInfo(contactID, fullName);
    */
  }

  void _loadContactInfo(String id, String fullName) {
    String firstName = "";
    String lastName = "";
    firstName = fullName.split(" ")[0];
    lastName = fullName.split(" ")[1];
    this.contact = Contact(id: id, firstName: firstName, lastName: lastName);
  }
}
