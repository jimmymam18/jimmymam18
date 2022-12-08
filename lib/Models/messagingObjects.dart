import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/userObjects.dart';

class Conversation {
  String id;
  Contact otherContact;
  List<Message> messages;
  Message lastMessage;

  Conversation() {
    messages = [];
  }

  String getLastMessageText() {
    if (messages.isEmpty)
      return '';
    else
      return messages.last.text;
  }

  String getLastMessageDateTime() {
    if (messages.isEmpty)
      return '';
    else
      return messages.last.getMessageDateTime();
  }

  void createConversation(Contact otherContact, List<Message> messages) {
    this.otherContact = otherContact;
    this.messages = messages;
    if (messages.isNotEmpty) {
      this.lastMessage = messages.last;
    }
  }

  void getConversationInfoFromFirestore(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    var documentData = snapshot.data();

    final List<DocumentSnapshot> documents = snapshot.data();

    String lastMessageText = documents[0]['lastMessageText'] ?? "";
    Timestamp lastMessageTimestamp =
        documents[0]['lastMessageDateTime'] ?? Timestamp.now();
    DateTime lastMessageDateTime = lastMessageTimestamp.toDate();
    this.lastMessage = Message();
    this.lastMessage.dateTime = lastMessageDateTime;
    this.lastMessage.text = lastMessageText;

    List<String> userIDs = List<String>.from(documents[0]['userIDs']) ?? [];
    List<String> userNames = List<String>.from(documents[0]['userNames']) ?? [];
    this.otherContact = Contact();
    for (String userID in userIDs) {
      if (userID != AppConstants.currentUser.id) {
        this.otherContact.id = userID;
        break;
      }
    }
    for (String name in userNames) {
      if (name != AppConstants.currentUser.getFullName()) {
        this.otherContact.firstName = name.split(" ")[0];
        this.otherContact.lastName = name.split(" ")[1];
        break;
      }
    }
  }

  Future<void> addConversationToFirestore(Contact otherContact) async {
    List<String> userNames = [
      AppConstants.currentUser.getFullName(),
      otherContact.getFullName(),
    ];
    List<String> userIDs = [
      AppConstants.currentUser.id,
      otherContact.id,
    ];
    Map<String, dynamic> convoData = {
      'lastMessageDataTime': DateTime.now(),
      'lastMessageText': "",
      'userNames': userNames,
      'userIDs': userIDs
    };
    DocumentReference reference = await FirebaseFirestore.instance
        .collection('conversations')
        .add(convoData);
    this.id = reference.id;
  }

  Future<void> addMessageToFirestore(String messageText) async {
    DateTime now = DateTime.now();
    Map<String, dynamic> messageData = {
      'dateTime': now,
      'senderID': AppConstants.currentUser.id,
      'text': messageText
    };
    await FirebaseFirestore.instance
        .collection('conversations/${this.id}/messages')
        .add(messageData);
    Map<String, dynamic> convoData = {
      'lastMessageDateTime': now,
      'lastMessageText': messageText
    };
    await FirebaseFirestore.instance
        .doc('conversations/${this.id}')
        .update(convoData);
  }
}

class Message {
  Contact sender;
  String text;
  DateTime dateTime;

  Message();

  void createMessage(Contact sender, String text, DateTime dateTime) {
    this.sender = sender;
    this.text = text;
    this.dateTime = dateTime;
  }

  void getMessageInfoFromFirestore(DocumentSnapshot snapshot) {
    var documentData = snapshot.data();
    final List<DocumentSnapshot> documents = snapshot.data();

    Timestamp lastMessageTimestamp =
        documents[0]['dateTime'] ?? Timestamp.now();
    this.dateTime = lastMessageTimestamp.toDate();
    String senderID = documents[0]['senderID'] ?? " ";
    this.sender = Contact(id: senderID);
    this.text = documents[0]['text'] ?? " ";
  }

  String getMessageDateTime() {
    final DateTime now = DateTime.now();
    final int today = now.day;
    if (this.dateTime.day == today) {
      return _getTime();
    } else {
      return _getDate();
    }
  }

  String _getTime() {
    String time = dateTime.toIso8601String().substring(11, 16);
    String hours = time.substring(0, 2);
    int hoursInt = int.parse(hours);
    if (hoursInt > 12) {
      hoursInt -= 12;
    }
    hours = hoursInt.toString();
    String minutes = time.substring(2);
    return hours + minutes;
  }

  String _getDate() {
    String date = dateTime.toIso8601String().substring(5, 10);
    String month = date.substring(0, 2);
    int monthInt = int.parse(month);
    String monthName = AppConstants.monthDict[monthInt];
    String day = date.substring(3, 5);
    return monthName + "/" + day;
  }
}
