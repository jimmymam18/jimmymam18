import 'package:bizitme/Models/messagingObjects.dart';
import 'package:bizitme/Models/postingObjects.dart';
import 'package:bizitme/Models/reviewObjects.dart';
import 'package:bizitme/Models/userObjects.dart';

class PracticeData {
  // User Data
  static List<User> users = [];
  static List<Posting> posting = [];

  static populateFields() {
    User user1 = User(
      firstName: "Veasna",
      lastName: "Mam",
      email: "mam.jimmy@gmail.com ",
      bio: "I enjoy programming and build mobile apps",
      city: "Seattle",
      country: "United States of America",
    );
    user1.isHost = true;
    User user2 = User(
      firstName: "Ben",
      lastName: "Satele",
      email: "info.flawlessmusicc@gmail.com",
      bio:
          "I am a cool dude who likes old school rides and have fun in the sun",
      city: "Vancouver",
      country: "Canada",
    );
    users.add(user1);
    users.add(user2);

    Review review = Review();
    review.createReview(
      user2.createContactFromUser(),
      "Fun guy, would definitely recommend him to others",
      4.5,
      DateTime.now(),
    );
    user1.reviews.add(review);

    Conversation conversation = Conversation();
    conversation.createConversation(user2.createContactFromUser(), []);

    Message message1 = Message();
    message1.createMessage(
      user1.createContactFromUser(),
      "Hello, how are you?",
      DateTime.now(),
    );
    Message message2 = Message();
    message2.createMessage(
      user2.createContactFromUser(),
      "I been very good?",
      DateTime.now(),
    );
    conversation.messages.add(message1);
    conversation.messages.add(message2);

    user1.conversations.add(conversation);
    Posting posting1 = Posting(
      name: "Cool Place",
      type: "Business Space",
      price: 120,
      description: "Nice sharing office space in south lake union area.",
      address: "528 Boren Ave N ",
      city: "Seattle",
      country: "United States",
      host: user1.createContactFromUser(),
    );
    //posting1.setImages(['assets/images/apartment1.jpg', 'assets/images/apartment1.jpg,']);
    posting1.amenities = [
      'wifi',
      'seats',
      'nearby parking',
      'open desk',
      'coffee machine',
      'power outlets',
      'bathroom'
    ];
    posting1.beds = {
      'small': 0,
      'medium': 2,
      'large': 2,
    };
    posting1.bathrooms = {
      'full': 2,
      'half': 1,
    };
    Posting posting2 = Posting(
      name: "Coworking Space",
      type: "Office Space",
      price: 100,
      description: "A Coworking space in Downtown Vancouver.",
      address: "83 South King Street",
      city: "Vancouver",
      country: "Canada",
      host: user2.createContactFromUser(),
    );
    //posting2.setImages(['assets/images/apartment.jpg', 'assets/images/apartment.jpg,']);
    posting2.amenities = [
      'Office Desks',
      'Chairs',
      'nearby parking',
      'open desk',
      'coffee machine',
      'power outlets',
      'bathroom'
    ];
    posting2.beds = {
      'small': 1,
      'medium': 0,
      'large': 1,
    };
    posting2.bathrooms = {
      'full': 1,
      'half': 1,
    };
    posting.add(posting1);
    posting.add(posting2);

    Booking booking1 = Booking();
    booking1.createBooking(
      posting2,
      user1.createContactFromUser(),
      [
        DateTime(2020, 08, 20),
        DateTime(2020, 08, 21),
        DateTime(2020, 08, 21),
      ],
    );
    Booking booking2 = Booking();
    booking2.createBooking(
      posting2,
      user1.createContactFromUser(),
      [
        DateTime(2020, 10, 11),
        DateTime(2020, 10, 11),
      ],
    );

    posting2.bookings.add(booking1);
    posting2.bookings.add(booking2);

    Review postingReview = Review();
    postingReview.createReview(
      user2.createContactFromUser(),
      "Pretty decent place, not as big as I was expecting though",
      3.5,
      DateTime(2020, 08, 08),
    );
    posting1.reviews.add(postingReview);

    user1.bookings.add(booking1);
    user2.bookings.add(booking2);
    user1.myPostings.add(posting1);
    user2.myPostings.add(posting2);
    user1.savedPostings.add(posting2);
  }
}
